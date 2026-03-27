import 'dart:async';
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
  Future<void> downloadFile(
      {required String url,
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
        throw ApiException('Server returned HTML instead of PDF. Check authentication or URL.');
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
  Future<dynamic> postAPICall(String url, dynamic params) async {
    dio_.Response responseJson;
    final dio_.Dio dio = dio_.Dio();
    try {
      final response =
      await dio.post(
        url,
        data: params is dio_.FormData ? params : (params.isNotEmpty ? params : {}),
        options: dio_.Options(
          headers: headers,
        ),
      );
      log(
          'response api****$url***************${response.statusCode}*********${response.data}');

      responseJson = response;
    } on dio_.DioException catch (e) {
      // DioError handling.
      if (e.response != null) {
        // The server responded but with an error status.
        if(e.response?.statusCode == 401 ){
          throw ApiException(
              '${e.response?.data['message']}');
        } else if(e.response?.statusCode == 422){
          throw ApiException(
              '${e.response?.data['message']}');
        } else if(e.response?.statusCode == 500 || e.response?.statusCode == 503){
          throw ApiException(
              'Server error');
        }
        throw ApiException(
            '${e.response?.data['message']}');
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
      log(
          'response api****$url***************${response.statusCode}*********${response.data}');

      responseJson = response;
    } on dio_.DioException catch (e) {
      // DioError handling.
      if (e.response != null) {
        // The server responded but with an error status.
        if(e.response?.statusCode == 401){
          throw ApiException(
              '${e.response?.data['message']}');
        } else if(e.response?.statusCode == 422){
          throw ApiException(
              '${e.response?.data['errors']['email']}');
        } else if(e.response?.statusCode == 500 || e.response?.statusCode == 503){
          throw ApiException(
              'Server error');
        }
        throw ApiException(
            '${e.response?.data['message']}');
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

  Future<dynamic> getAPICall(String url, dynamic params, {bool? isUserApi, BuildContext? context}) async {
    late dio_.Response responseJson;
    final dio_.Dio dio = dio_.Dio();
    try {
      final response =
      await dio.get(
          url,
          queryParameters: (params is Map<String, dynamic> && params.isNotEmpty) ? params : {},
          options: dio_.Options(headers: headers)
      );

      // log(
      //     'response api****$url*****************${response.statusCode}*********${response.data}');

      responseJson = response;
    } on dio_.DioException catch (e) {
      // DioError handling.
      if(e.response?.statusCode == 401 && isUserApi == true){}
      if (e.response != null) {
        // The server responded but with an error status.
        if(e.response?.statusCode == 401){
          throw ApiException(
              '${e.response?.data['message']}');
        } else if(e.response?.statusCode == 422){
          throw ApiException(
              '${e.response?.data['success']['email']}');
        } else if(e.response?.statusCode == 500){
          throw ApiException(
              'Server error');
        } else if(e.response?.statusCode == 403){
          throw ApiException(
              '${e.response?.data['message']}');
        } else if(e.response?.statusCode == 503) {
          throw ApiException(
              '${e.response?.data ['message']}');
        }
        throw ApiException(
            '${e.response?.data ['message']}');
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
      final response =
      await dio.delete(
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
        if(e.response?.statusCode == 401){
          throw ApiException(
              '${e.response?.data['message']}');
        } else if(e.response?.statusCode == 422){
          throw ApiException(
              '${e.response?.data['errors']['email']}');
        } else if(e.response?.statusCode == 500 || e.response?.statusCode == 503){
          throw ApiException(
              'Server error');
        }
        throw ApiException(
            '${e.response?.data['message']}');
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
