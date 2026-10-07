import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../config/config.dart';

Dio dio = Dio();

Future<String> apiRequest(
  String url,
  Map jsonMap, {
  bool showLog = true,
}) async {
  if (showLog) {
    debugPrint("$url : ${jsonEncode(jsonMap)}");
  }

  try {
    final response = await dio.post(
      url,
      options: Options(
        responseType: ResponseType.plain,
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
      ),
      data: jsonEncode(jsonMap),
    );

    if (showLog) debugPrint("$url [SUCCESS] : ${response.data}");
    return response.data.toString();
  } on DioException catch (e) {
    debugPrint("$url [ERROR] : ${e.response?.statusCode}");
    debugPrint("Response data: ${e.response?.data}");
    debugPrint("Message: ${e.message}");
    return e.response?.data?.toString() ?? "Unknown error";
  } catch (e, s) {
    debugPrint("Unexpected error: $e");
    debugPrintStack(stackTrace: s);
    return "Unexpected error: $e";
  }
}

Future<String> apiRequestfullUrl(String url, jsonMap) async {
  final response = await dio.post(
    url,
    options: Options(
      responseType: ResponseType.plain,
      headers: {
        HttpHeaders.connectionHeader: "keep-alive",
        HttpHeaders.contentEncodingHeader: "gzip",
        HttpHeaders.contentTypeHeader: "application/json",
      },
    ),
    data: jsonEncode(jsonMap),
  );

  debugPrint("url: $url ${jsonMap.toString()} data: $response");
  return response.toString();
}

Future<String> uploadImg(File img, String ext) async {
  final Uint8List bytes = await img.readAsBytes();
  final Map jsonMap = {"file": base64.encode(bytes), "ext": ext};
  final String result = await apiRequest("$generalServer/uploads", jsonMap);
  final Map map = json.decode(result);
  return "$website/api/${map["link"]}";
}
