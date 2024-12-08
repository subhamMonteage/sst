package state

import (
	"bytes"
	"compress/gzip"
	"context"
	"fmt"
	"io"
	"log/slog"
	"net/http"
	"os"
	"strings"
	"sync"

	"github.com/sst/ion/pkg/project"
)

func Register(ctx context.Context, p *project.Project, mux *http.ServeMux) error {
	log := slog.New(slog.Default().Handler()).With("component", "server.state")
	log.Info("registering")
	client := &http.Client{}
	tracker, err := os.Create("tracker.txt")
	if err != nil {
		return err
	}
	var lock sync.Mutex
	mux.HandleFunc("/state/", func(w http.ResponseWriter, r *http.Request) {
		lock.Lock()
		defer lock.Unlock()
		log.Info("request", "method", r.Method, "url", r.URL.String())
		url := "https://api.pulumi.com" + strings.TrimPrefix(r.URL.Path, "/state")
		proxyReq, err := http.NewRequest(r.Method, url, r.Body)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		for header, values := range r.Header {
			for _, value := range values {
				proxyReq.Header.Add(header, value)
			}
		}
		tracker.WriteString(r.Method + " " + r.URL.String() + "\n")
		requestbody, _ := io.ReadAll(r.Body)
		fmt.Println(r.Header.Get("Content-Encoding"))
		if len(requestbody) > 0 {
			proxyReq.Body = io.NopCloser(bytes.NewBuffer(requestbody))
			tracker.WriteString("\n")
			if r.Header.Get("Content-Encoding") == "gzip" {
				gzipReader, err := gzip.NewReader(bytes.NewReader(requestbody))
				if err != nil {
					return
				}
				defer gzipReader.Close()

				uncompressedData, err := io.ReadAll(gzipReader)
				if err != nil {
					// Handle error
					return
				}

				tracker.Write(uncompressedData)
			} else {
				tracker.Write(requestbody)
			}
			tracker.WriteString("\n")
		}
		resp, err := client.Do(proxyReq)
		if err != nil {
			http.Error(w, err.Error(), http.StatusBadGateway)
			return
		}
		defer resp.Body.Close()

		tracker.WriteString(resp.Status + "\n")
		for header, values := range resp.Header {
			for _, value := range values {
				w.Header().Add(header, value)
				tracker.WriteString(header + ": " + value + "\n")
			}
		}
		w.WriteHeader(resp.StatusCode)

		var buf bytes.Buffer
		_, err = io.Copy(w, io.TeeReader(resp.Body, &buf))
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		tracker.Write(buf.Bytes())
		tracker.WriteString("\n")
	})

	log.Info("registered")
	return nil
}
