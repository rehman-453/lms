import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lms/core/network/api_headers.dart';
import 'package:lms/core/storage/local_storage.dart';
import 'package:lms/core/storage/local_storage_keys.dart';

class ApiServices {
  static const Duration _timeout = Duration(seconds: 30);

  Future<String> getMethod(
    String completeUrl, [
    bool isAccessToken = false,
  ]) async {
    final response = await http
        .get(
          Uri.parse(completeUrl),
          headers: isAccessToken
              ? ApiHeaders.headerWithTokenAndContentTypeJsonOnly()
              : ApiHeaders.headerWithContentTypeJsonOnly(),
        )
        .timeout(_timeout);

    return returnResponse(response);
  }

  Future<String> postMethod(
    String completeUrl,
    Map<String, dynamic> apiBody, [
    bool isAccessToken = false,
  ]) async {
    final response = await http
        .post(
          Uri.parse(completeUrl),
          body: jsonEncode(apiBody),
          headers: isAccessToken
              ? ApiHeaders.headerWithTokenAndContentTypeJsonOnly()
              : ApiHeaders.headerWithContentTypeJsonOnly(),
        )
        .timeout(_timeout);

    return returnResponse(response);
  }

  Future<String> patchMethod(
    String completeUrl,
    Map<String, dynamic> apiBody, [
    bool isAccessToken = false,
  ]) async {
    final response = await http
        .patch(
          Uri.parse(completeUrl),
          body: jsonEncode(apiBody),
          headers: isAccessToken
              ? ApiHeaders.headerWithTokenAndContentTypeJsonOnly()
              : ApiHeaders.headerWithContentTypeJsonOnly(),
        )
        .timeout(_timeout);

    return returnResponse(response);
  }

  Future<String> putMethod(
    String completeUrl,
    Map<String, dynamic> apiBody, [
    bool isAccessToken = false,
  ]) async {
    final response = await http
        .put(
          Uri.parse(completeUrl),
          body: jsonEncode(apiBody),
          headers: isAccessToken
              ? ApiHeaders.headerWithTokenAndContentTypeJsonOnly()
              : ApiHeaders.headerWithContentTypeJsonOnly(),
        )
        .timeout(_timeout);

    return returnResponse(response);
  }

  Future<String> deleteMethod(
    String completeUrl, [
    bool isAccessToken = false,
  ]) async {
    final response = await http
        .delete(
          Uri.parse(completeUrl),
          headers: isAccessToken
              ? ApiHeaders.headerWithTokenAndContentTypeJsonOnly()
              : ApiHeaders.headerWithContentTypeJsonOnly(),
        )
        .timeout(_timeout);

    return returnResponse(response);
  }

  String returnResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.body;
    }

    String errorMessage = 'Something went wrong.';

    try {
      final responseData = jsonDecode(response.body);

      if (responseData is Map<String, dynamic>) {
        if (responseData['errors'] is Map) {
          final errors = responseData['errors'] as Map;

          errorMessage = errors.values
              .expand((error) => error is List ? error : [error])
              .join('\n');
        } else {
          errorMessage = responseData['message']?.toString() ?? errorMessage;
        }
      }
    } catch (_) {
      // Response JSON format mein nahi hai.
    }

    switch (response.statusCode) {
      case 401:
        LocalStorage.deleteData(key: LocalStorageKeys.accessTokenKey);
        throw Exception(
          errorMessage == 'Something went wrong.'
              ? 'Unauthorized. Please login again.'
              : errorMessage,
        );

      case 403:
        throw Exception(errorMessage);

      case 404:
        throw Exception(
          errorMessage == 'Something went wrong.'
              ? 'Resource not found.'
              : errorMessage,
        );

      case 422:
        throw Exception(errorMessage);

      case 500:
        throw Exception('Internal server error.');

      default:
        throw Exception(errorMessage);
    }
  }
}
