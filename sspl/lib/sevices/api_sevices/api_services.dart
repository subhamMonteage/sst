import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class BaseApiServices {
  Future<dynamic> getApi(String url);

  Future<dynamic> postApi(dynamic data, String url);
}

class ApiServices {
  //Get Api
  Future<dynamic> getApi(String url) async {
    try {
      final response = await http.get(Uri.parse(""));
      var data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return e.toString();
    }
  }
}

class NetworkApiServices extends BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    if (kDebugMode) {
      print(url);
    }
    dynamic responseJson;
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException("");
    } on RequestTimeOut {
      throw RequestTimeOut("");
    }
    return responseJson;
  }

  Future<dynamic> postApi(var data, String url) async {
    if (kDebugMode) {
      // print(url);
      // print(data);
    }

    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: <String, String>{
          'Content-Type': 'application/json',
          // Add any other headers you might need
        },
      ).timeout(Duration(seconds: 10));
      responseJson = returnResponse(response);
    } on SocketException {
      throw InternetException("Internet exception ");
    } on RequestTimeOut {
      throw RequestTimeOut("server request exception");
    }
    if (kDebugMode) {
      // print(" response json ${responseJson}");
    }
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        // print(" response json in return method  ${responseJson}");
        return responseJson;
      case 400:
        print(
            " response json in return method case 400  ${jsonDecode(response.body)}");
        throw InvalidUrlException;

      default:
        print(
            " response json in return method  case default${jsonDecode(response.body)}");

        throw FetchDataException(
            "Error occured in server" + response.statusCode.toString());
    }
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class InternetException extends AppException {
  InternetException([String? message]) : super(message, "No Internet");
}

class RequestTimeOut extends AppException {
  RequestTimeOut([String? message]) : super(message, "Request Time Out");
}

class InvalidUrlException extends AppException {
  InvalidUrlException([String? message]) : super(message, "Invalid URL");
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, "");
}

enum Status { Loading, Complete, Error }
