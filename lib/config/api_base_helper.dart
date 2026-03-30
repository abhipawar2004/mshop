import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart' as dio_;
import 'package:flutter/material.dart';
import 'package:hyper_local/config/security.dart';

class ApiException implements Exception {
  ApiException(this.errorMessage);

  final String errorMessage;

  @override
  String toString() {
    return errorMessage;
  }
}

class ApiBaseHelper {
  String _sanitizePotentialInternalError(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('splfileobject::__construct') ||
        lower.contains('/var/www/') ||
        lower.contains('failed to open stream') ||
        lower.contains('service-account-file.json')) {
      return 'Internal server configuration error (redacted)';
    }
    return value;
  }

  bool _isSensitiveKey(String key) {
    final normalized = key.toLowerCase();
    return normalized.contains('token') ||
        normalized.contains('password') ||
        normalized.contains('authorization') ||
        normalized.contains('secret') ||
        normalized.contains('key');
  }

  String _maskStringValue(String value) {
    if (value.isEmpty) return '<empty>';
    if (value.length <= 20) return '<redacted:${value.length} chars>';
    return '${value.substring(0, 10)}...${value.substring(value.length - 10)} '
        '(${value.length} chars)';
  }

  dynamic _sanitizeForLog(dynamic data) {
    if (data is Map) {
      final sanitized = <String, dynamic>{};
      data.forEach((key, value) {
        final k = key.toString();
        if (_isSensitiveKey(k) && value is String) {
          sanitized[k] = _maskStringValue(value);
        } else if (k.toLowerCase() == 'error' && value is String) {
          sanitized[k] = _sanitizePotentialInternalError(value);
        } else {
          sanitized[k] = _sanitizeForLog(value);
        }
      });
      return sanitized;
    }

    if (data is List) {
      return data.map(_sanitizeForLog).toList();
    }

    if (data is String && data.length > 300) {
      return _maskStringValue(data);
    }

    return data;
  }

  Map<String, dynamic> _buildRequestHeaders(
    dynamic body, {
    required bool includeAuthorization,
  }) {
    final resolvedHeaders = Map<String, dynamic>.from(headers ?? {});
    final bool hasBody = body is dio_.FormData ||
        (body is Map && body.isNotEmpty) ||
        (body is List && body.isNotEmpty) ||
        (body is String && body.isNotEmpty);

    if (!includeAuthorization) {
      resolvedHeaders
          .removeWhere((key, value) => key.toLowerCase() == 'authorization');
    }

    // Avoid sending an incorrect fixed content-length for JSON/form bodies.
    if (hasBody) {
      resolvedHeaders
          .removeWhere((key, value) => key.toLowerCase() == 'content-length');
    }

    return resolvedHeaders;
  }

  String _extractApiMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
      if (responseData['error'] != null)
        return responseData['error'].toString();
      return jsonEncode(responseData);
    }

    if (responseData == null) return 'Unknown API error';
    return responseData.toString();
  }

  void _logDioError(String method, String url, dio_.DioException e) {
    log('[API][$method][ERROR] url=$url');
    log('[API][$method][ERROR] resolvedUrl=${e.requestOptions.uri}');
    log('[API][$method][ERROR] type=${e.type} message=${e.message}');
    log('[API][$method][ERROR] status=${e.response?.statusCode}');
    log('[API][$method][ERROR] response=${e.response?.data}');
    log('[API][$method][ERROR] requestHeaders=${_sanitizeForLog(e.requestOptions.headers)}');
    log('[API][$method][ERROR] requestData=${_sanitizeForLog(e.requestOptions.data)}');
  }

  Future<void> downloadFile({
    required String url,
    required dio_.CancelToken cancelToken,
    required String savePath,
    required Function(int, int) updateDownloadedPercentage,
  }) async {
    try {
      final dio_.Dio dio = dio_.Dio();
      await dio.download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: updateDownloadedPercentage,
        options: dio_.Options(
          headers: headers,
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      final file = File(savePath);
      if (!await file.exists() || await file.length() == 0) {
        throw ApiException('Downloaded file is empty or does not exist');
      }

      // Check if it's actually a PDF
      final firstBytes = await file.openRead(0, 10).first;
      final headerString = String.fromCharCodes(firstBytes.take(4));

      if (!headerString.startsWith('%PDF')) {
        // If it's HTML, read the content to see what error we got
        await file.readAsString();
        throw ApiException(
            'Server returned HTML instead of PDF. Check authentication or URL.');
      }
    } on dio_.DioException catch (e) {
      if (e.type == dio_.DioExceptionType.connectionError) {
        throw ApiException('No Internet connection');
      }
      throw ApiException(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // POST METHOD
  Future<dynamic> postAPICall(
    String url,
    dynamic params, {
    bool includeAuthorization = true,
  }) async {
    dio_.Response responseJson;
    final dio_.Dio dio = dio_.Dio();
    try {
      final requestBody =
          params is dio_.FormData ? params : (params.isNotEmpty ? params : {});

      final response = await dio.post(
        url,
        data: requestBody,
        options: dio_.Options(
          headers: _buildRequestHeaders(
            requestBody,
            includeAuthorization: includeAuthorization,
          ),
        ),
      );
      log('[API][POST][REQUEST] inputUrl=$url');
      log('[API][POST][REQUEST] resolvedUrl=${response.requestOptions.uri}');
      log('[API][POST][REQUEST] headers=${_sanitizeForLog(response.requestOptions.headers)}');
      log('[API][POST][REQUEST] body=${_sanitizeForLog(response.requestOptions.data)}');
      log('response api****$url***************${response.statusCode}*********${_sanitizeForLog(response.data)}');

      responseJson = response;
    } on dio_.DioException catch (e) {
      _logDioError('POST', url, e);
      // DioError handling.
      if (e.response != null) {
        // The server responded but with an error status.
        if (e.response?.statusCode == 401) {
          throw ApiException(_extractApiMessage(e.response?.data));
        } else if (e.response?.statusCode == 422) {
          throw ApiException(_extractApiMessage(e.response?.data));
        } else if (e.response?.statusCode == 500 ||
            e.response?.statusCode == 503) {
          throw ApiException('Server error');
        }
        throw ApiException(_extractApiMessage(e.response?.data));
      } else {
        throw ApiException(
            'POST failed without response. type=${e.type} message=${e.message}');
      }
    } on SocketException {
      throw ApiException('No Internet connection');
    } on TimeoutException {
      throw ApiException('Something went wrong, Server not Responding');
    } on Exception catch (e) {
      throw ApiException('Something Went wrong with ${e.toString()}');
    }
    return responseJson;
  }

  // PUT METHOD
  Future<dynamic> putAPICall(String url, dynamic params) async {
    dio_.Response responseJson;
    final dio_.Dio dio = dio_.Dio();
    try {
      final response = await dio.put(
        url,
        data: params.isNotEmpty ? params : [],
        options: dio_.Options(
          headers: headers,
        ),
      );
      log('response api****$url***************${response.statusCode}*********${response.data}');

      responseJson = response;
    } on dio_.DioException catch (e) {
      // DioError handling.
      if (e.response != null) {
        // The server responded but with an error status.
        if (e.response?.statusCode == 401) {
          throw ApiException('${e.response?.data['message']}');
        } else if (e.response?.statusCode == 422) {
          throw ApiException('${e.response?.data['errors']['email']}');
        } else if (e.response?.statusCode == 500 ||
            e.response?.statusCode == 503) {
          throw ApiException('Server error');
        }
        throw ApiException('${e.response?.data['message']}');
      } else {
        throw ApiException('Something Went Wrong: ${e.message}');
      }
    } on SocketException {
      throw ApiException('No Internet connection');
    } on TimeoutException {
      throw ApiException('Something went wrong, Server not Responding');
    } on Exception catch (e) {
      throw ApiException('Something Went wrong with ${e.toString()}');
    }
    return responseJson;
  }

  Future<dynamic> getAPICall(String url, dynamic params,
      {bool? isUserApi, BuildContext? context}) async {
    late dio_.Response responseJson;
    final dio_.Dio dio = dio_.Dio();
    try {
      if (kDebugMode) {
        log('[API][GET][REQUEST] url=$url');
        log('[API][GET][QUERY] ${(params is Map<String, dynamic> && params.isNotEmpty) ? params : {}}');
      }
      final response = await dio.get(url,
          queryParameters: (params is Map<String, dynamic> && params.isNotEmpty)
              ? params
              : {},
          options: dio_.Options(headers: headers));

      if (kDebugMode) {
        log('[API][GET][RESPONSE] url=$url status=${response.statusCode}');
        log('[API][GET][BODY] ${response.data}');
      }

      responseJson = response;
    } on dio_.DioException catch (e) {
      if (kDebugMode) {
        log('[API][GET][ERROR] url=$url status=${e.response?.statusCode} error=${e.message}');
        log('[API][GET][ERROR_BODY] ${e.response?.data}');
      }
      // DioError handling.
      if (e.response?.statusCode == 401 && isUserApi == true) {}
      if (e.response != null) {
        // The server responded but with an error status.
        if (e.response?.statusCode == 401) {
          throw ApiException('${e.response?.data['message']}');
        } else if (e.response?.statusCode == 422) {
          throw ApiException('${e.response?.data['success']['email']}');
        } else if (e.response?.statusCode == 500) {
          throw ApiException('Server error');
        } else if (e.response?.statusCode == 403) {
          throw ApiException('${e.response?.data['message']}');
        } else if (e.response?.statusCode == 503) {
          throw ApiException('${e.response?.data['message']}');
        }
        throw ApiException('${e.response?.data['message']}');
      } else {
        throw ApiException('Something Went Wrong: ${e.message}');
      }
    } on SocketException {
      throw ApiException('No Internet connection');
    } on TimeoutException {
      throw ApiException('Something went wrong, Server not Responding');
    } on Exception catch (e) {
      log('///////$e///////');
    }
    return responseJson;
  }

  Future<dynamic> deleteAPICall(String url, dynamic params) async {
    dio_.Response responseJson;
    final dio_.Dio dio = dio_.Dio();
    try {
      final response = await dio.delete(
        url,
        data: params.isNotEmpty ? params : [],
        options: dio_.Options(
          headers: headers,
        ),
      );
      if (kDebugMode) {
        print(
            'response api****$url***************${response.statusCode}*********${response.data}');
      }

      responseJson = response;
    } on dio_.DioException catch (e) {
      // DioError handling.
      if (e.response != null) {
        // The server responded but with an error status.
        if (e.response?.statusCode == 401) {
          throw ApiException('${e.response?.data['message']}');
        } else if (e.response?.statusCode == 422) {
          throw ApiException('${e.response?.data['errors']['email']}');
        } else if (e.response?.statusCode == 500 ||
            e.response?.statusCode == 503) {
          throw ApiException('Server error');
        }
        throw ApiException('${e.response?.data['message']}');
      } else {
        throw ApiException('Something Went Wrong: ${e.message}');
      }
    } on SocketException {
      throw ApiException('No Internet connection');
    } on TimeoutException {
      throw ApiException('Something went wrong, Server not Responding');
    } on Exception catch (e) {
      throw ApiException('Something Went wrong with ${e.toString()}');
    }
    return responseJson;
  }
}

class CustomException implements Exception {
  final dynamic message;
  final dynamic prefix;

  CustomException([this.message, this.prefix]);

  @override
  String toString() {
    return '$prefix$message';
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message])
      : super(message, 'Error During Communication: ');
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, 'Invalid Request: ');
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, 'Unauthorised: ');
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, 'Invalid Input: ');
}
