import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService.internal();
  NetworkService.internal();
  factory NetworkService() => _instance;
  late Response response;
  Dio dio = Dio();

  var _connectivityResult;

  Future<Response> get(String url,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters}) async {
    _connectivityResult = await (Connectivity().checkConnectivity());
    if (_connectivityResult == ConnectivityResult.none) {
      response = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Please check internet connection'},
          statusCode: 0);
    } else {
      debugPrint("api >>> $url");
      debugPrint("headers >>> ${headers.toString()}");
      response = await dio.get(url,
          options: Options(headers: headers), queryParameters: queryParameters);
    }
    return response;
  }

  Future<Response> post(String url,
      {Map<String, dynamic>? headers, body, encoding}) async {
    _connectivityResult = await (Connectivity().checkConnectivity());
    if (_connectivityResult == ConnectivityResult.none) {
      response = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Please check internet connection'},
          statusCode: 00);
    } else {
      debugPrint("api >>> $url");
      debugPrint("headers >>> ${headers.toString()}");
      debugPrint("request >>> ${body.toString()}");
      response =
          await dio.post(url, options: Options(headers: headers), data: body);
    }
    return response;
  }

  Future<Response> put(String url,
      {Map<String, dynamic>? headers, body, encoding}) async {
    _connectivityResult = await (Connectivity().checkConnectivity());
    if (_connectivityResult == ConnectivityResult.none) {
      response = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Please check internet connection'},
          statusCode: 0);
    } else {
      response =
          await dio.put(url, options: Options(headers: headers), data: body);
    }
    return response;
  }

  Future<Response> delete(String url, {Map<String, dynamic>? headers}) async {
    _connectivityResult = await (Connectivity().checkConnectivity());
    if (_connectivityResult == ConnectivityResult.none) {
      response = Response(
          requestOptions: RequestOptions(path: ''),
          data: {'message': 'Please check internet connection'},
          statusCode: 0);
    } else {
      debugPrint("api >>> $url");
      response = await dio.delete(url, options: Options(headers: headers));
    }
    return response;
  }
}
