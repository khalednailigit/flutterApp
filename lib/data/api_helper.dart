import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiHelper {
  Dio _baseDio;
  static final ApiHelper _instance = ApiHelper._internal();

  final String _baseUrl = 'https://reqres.in/';

  factory ApiHelper() => _instance;

  ApiHelper._internal() {
    _baseDio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: 60000,
        receiveTimeout: 30000,
      ),
    );
    initializeInterceptor();
  }

  void initializeInterceptor() {
    _baseDio.interceptors.add(
      PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90),
    );
  }

  Future<Response> signin(
      {@required String email, @required String password}) async {
    final url = "/api/login";

    final body = {"email": email, "password": password};

    return await _baseDio.post(url, data: jsonEncode(body));
  }

  Future<Response> getUsersList({@required int page}) async {
    final url = "/api/users?page=$page";

    return await _baseDio.get(url);
  }
}
