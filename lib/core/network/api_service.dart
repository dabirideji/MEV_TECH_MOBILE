import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as path;
import 'package:template/core/error/failure_response.dart';
import 'package:template/core/storages/local_storages.dart';
import 'package:template/core/utils/constants.dart';
import 'package:template/data/connection_checker.dart';
import 'package:template/features/chat/data/models/chat_message_model.dart';
import 'package:template/features/course/data/models/course-content-models/course_content_request.dart';
import 'package:template/features/course/data/models/course-models/course_request.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';

@singleton
class ApiService {
  ApiService(this.localStorage);

  // ApiService(this.client);

  // final http.Client client;
  final LocalStorage localStorage;

  static const baseUrlAddress = 'https://mev-tech-api.onrender.com/api';
  // 'https://dev-api.virtual360mevtech.com/api';

// switch back to this  // 'https://dev-api.virtual360mevtech.com/api';
  // 'https://mev-tech-api.onrender.com/api';
  // 'http://dev-api.virtual360mevtech.com/api'
  // https://mev-tech-temp.codeweborganization.com.ng/swagger/index.html
  // static const authKey = ''; https://dev-api.virtual360mevtech.com

  Future<dynamic> postJsonRequest(
    Map<String, dynamic> jsonData,
    String progLink, {
    bool authRequired = true,
  }) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      final url = Uri.parse('$baseUrlAddress/$progLink');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${accessToken ?? MevTechUtilities.authKey}',
      };

      final headers2 = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var response = await http
          .post(
            url,
            headers: authRequired ? headers : headers2,
            body: json.encode(jsonData),
          )
          .timeout(const Duration(seconds: 25));

      // log(response.body);

      if (response.statusCode == 400 && authRequired) {
        final refreshed = await refreshTokenRequest();
        if (refreshed == null) return 'Session expired. Please login again.';

        final newToken = await localStorage.getApiKey();
        final retryHeaders = {
          ...headers,
          'Authorization': 'Bearer $newToken',
        };

        response = await http
            .post(
              url,
              headers: retryHeaders,
              body: json.encode(jsonData),
            )
            .timeout(const Duration(seconds: 25));
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      // else if (response.statusCode == 301) {
      //   return mockData();
      // }
      else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> getJsonRequest(
    String progLink, {
    bool authRequired = true,
    Map<String, dynamic>? queryParams,
    String token = '',
  }) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      final url = Uri.parse('$baseUrlAddress/$progLink')
          .replace(queryParameters: queryParams);
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (authRequired)
          'Authorization': 'Bearer ${accessToken ?? MevTechUtilities.authKey}',
      };

      // final headers2 = <String, String>{
      //   'Content-Type': 'application/json',
      //   'Accept': 'application/json',
      // };

      // log(url.toString());

      var response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(const Duration(seconds: 25));

      // final jsonTestData = json.encode(jsonData);

      if (response.statusCode == 400 && authRequired) {
        final responseCode = handleNotFoundError(response);

        if (responseCode == 401) {
          final refreshed = await refreshTokenRequest();
          if (refreshed == null) return 'Session expired. Please login again.';

          final newToken = await localStorage.getApiKey();
          final retryHeaders = {
            ...headers,
            'Authorization': 'Bearer $newToken',
          };

          response = await http
              .get(
                url,
                headers: retryHeaders,
              )
              .timeout(const Duration(seconds: 25));
        } else {
          return json.decode(response.body);
        }
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> patchJsonRequest(
    String progLink, {
    bool authRequired = true,
    Map<String, dynamic>? queryParams,
    String token = '',
  }) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      final url = Uri.parse('$baseUrlAddress/$progLink')
          .replace(queryParameters: queryParams);
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (authRequired)
          'Authorization': 'Bearer ${accessToken ?? MevTechUtilities.authKey}',
      };

      // final headers2 = <String, String>{
      //   'Content-Type': 'application/json',
      //   'Accept': 'application/json',
      // };

      // log(url.toString());

      var response = await http
          .patch(
            url,
            headers: headers,
          )
          .timeout(const Duration(seconds: 25));

      // final jsonTestData = json.encode(jsonData);

      if (response.statusCode == 400 && authRequired) {
        final responseCode = handleNotFoundError(response);

        if (responseCode == 401) {
          final refreshed = await refreshTokenRequest();
          if (refreshed == null) return 'Session expired. Please login again.';

          final newToken = await localStorage.getApiKey();
          final retryHeaders = {
            ...headers,
            'Authorization': 'Bearer $newToken',
          };

          response = await http
              .get(
                url,
                headers: retryHeaders,
              )
              .timeout(const Duration(seconds: 25));
        } else {
          return json.decode(response.body);
        }
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> getRequestBool(
    String progLink, {
    bool authRequired = true,
    String token = '',
  }) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      final url = Uri.parse('$baseUrlAddress/$progLink');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (authRequired)
          'Authorization': 'Bearer ${accessToken ?? MevTechUtilities.authKey}',
      };

      var response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(const Duration(seconds: 25));

      if (response.statusCode == 400 && authRequired) {
        final responseCode = handleNotFoundError(response);

        if (responseCode == 401) {
          final refreshed = await refreshTokenRequest();
          if (refreshed == null) return 'Session expired. Please login again.';

          final newToken = await localStorage.getApiKey();
          final retryHeaders = {
            ...headers,
            'Authorization': 'Bearer $newToken',
          };

          response = await http
              .get(
                url,
                headers: retryHeaders,
              )
              .timeout(const Duration(seconds: 25));
        } else {
          return json.decode(response.body);
        }
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> getJsonRequestCopy(
    String progLink, {
    bool authRequired = true,
    Map<String, dynamic>? queryParams,
  }) async {
    final hasInternet = await InternetCheck.connectionStatus();
    if (!hasInternet) return 'Check your Internet Connection';

    String? token = await localStorage.getApiKey();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (authRequired && token != null) 'Authorization': 'Bearer $token',
    };

    Uri url = Uri.parse('$baseUrlAddress/$progLink')
        .replace(queryParameters: queryParams);

    http.Response response = await http
        .get(url, headers: headers)
        .timeout(const Duration(seconds: 25));

    if (response.statusCode == 401 && authRequired) {
      // Access token expired, try to refresh
      final refreshToken = await localStorage.getApiRefreshToken();
      final newToken = refreshToken ?? '';
      //await refreshTokenRequest(refreshToken ?? '');
      if (newToken != null) {
        // Retry the request with new token
        final retryHeaders = {
          ...headers,
          'Authorization': 'Bearer $newToken',
        };
        response = await http
            .get(url, headers: retryHeaders)
            .timeout(const Duration(seconds: 25));
      } else {
        return 'Session expired. Please login again.';
      }
    }

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return handleError(response);
    }
  }

  Future<dynamic> updateJsonRequest(
    Map<String, dynamic> jsonData,
    String progLink,
  ) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      final url = Uri.parse('$baseUrlAddress/$progLink');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${accessToken ?? MevTechUtilities.authKey}',
      };

      var response = await http
          .put(
            url,
            headers: headers,
            body: json.encode(jsonData),
          )
          .timeout(
            const Duration(seconds: 25),
          );

      if (response.statusCode == 400) {
        final refreshed = await refreshTokenRequest();
        if (refreshed == null) return 'Session expired. Please login again.';

        final newToken = await localStorage.getApiKey();
        final retryHeaders = {
          ...headers,
          'Authorization': 'Bearer $newToken',
        };

        response = await http
            .put(
              url,
              headers: retryHeaders,
              body: json.encode(jsonData),
            )
            .timeout(const Duration(seconds: 25));
      }

      // log(response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 204) {
        return {'status': true};
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> deleteJsonRequest(
    String progLink, {
    bool authRequired = true,
  }) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      final url = Uri.parse('$baseUrlAddress/$progLink');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${accessToken ?? MevTechUtilities.authKey}',
      };

      final headers2 = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // log(url.toString());
      // log(headers.toString());

      var response = await http
          .delete(
            url,
            headers: authRequired ? headers : headers2,
          )
          .timeout(const Duration(seconds: 25));

      if (response.statusCode == 400 && authRequired) {
        final refreshed = await refreshTokenRequest();
        if (refreshed == null) return 'Session expired. Please login again.';

        final newToken = await localStorage.getApiKey();
        final retryHeaders = {
          ...headers,
          'Authorization': 'Bearer $newToken',
        };

        response = await http
            .delete(
              url,
              headers: retryHeaders,
            )
            .timeout(const Duration(seconds: 25));
      }

      // final jsonTestData = json.encode(jsonData);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 204) {
        return {
          'status': true,
          'responseMessage': 'Request was successful.',
        };
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> odataRequest({
    required Uri url,
    bool authRequired = true,
    String token = '',
  }) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      // final url = Uri.parse('$baseUrlAddress/$progLink');
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${accessToken ?? MevTechUtilities.authKey}',
      };

      final headers2 = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // log(url.toString());

      var response = await http
          .get(
            url,
            headers: authRequired ? headers : headers2,
          )
          .timeout(const Duration(seconds: 25));

      if (response.statusCode == 400 && authRequired) {
        final refreshed = await refreshTokenRequest();
        if (refreshed == null) return 'Session expired. Please login again.';

        final newToken = await localStorage.getApiKey();
        final retryHeaders = {
          ...headers,
          'Authorization': 'Bearer $newToken',
        };

        response = await http
            .get(
              url,
              headers: retryHeaders,
            )
            .timeout(const Duration(seconds: 25));
      }

      // final jsonTestData = json.encode(jsonData);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> multipartRequestCreate(
      String progLink, CreateCourseRequest requestModel) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      final url = Uri.parse('$baseUrlAddress/$progLink');

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] =
            'Bearer ${accessToken ?? MevTechUtilities.authKey}'
        ..fields['CourseName'] = requestModel.courseName
        ..fields['CourseTitle'] = requestModel.courseTitle
        ..fields['Description'] = requestModel.description
        ..fields['IsFree'] = requestModel.isFree.toString()
        ..fields['InstructorId'] = requestModel.instructorId;
      // ..files.add(
      //   await http.MultipartFile.fromPath(
      //     'CourseImageFile',
      //     requestModel.courseImageFile.path,
      //     filename: basename(requestModel.courseImageFile.path),
      //   ),
      // );

      if (requestModel.courseImageUrl != null &&
          requestModel.courseImageUrl!.isNotEmpty) {
        request.fields['CourseImageUrl'] = requestModel.courseImageUrl!;
      }

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 25));

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> multipartRequestUpdate(
    String progLink,
    UpdateCourseRequest requestModel, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      final url = Uri.parse('$baseUrlAddress/$progLink').replace(
        queryParameters: queryParams,
      );

      // log(url.toString());

      final request = http.MultipartRequest('PUT', url)
        ..headers['Authorization'] =
            'Bearer ${accessToken ?? MevTechUtilities.authKey}'
        ..fields['CourseName'] = requestModel.courseName
        ..fields['CourseTitle'] = requestModel.courseTitle
        ..fields['Description'] = requestModel.description
        ..fields['IsFree'] = requestModel.isFree.toString()
        ..fields['CourseImageUrl'] = requestModel.courseImageUrl ?? ''
        ..fields['Categories'] = requestModel.categories[0];
      // ..files.add(
      //   await http.MultipartFile.fromPath(
      //     'CourseImageFile',
      //     requestModel.courseImageFile.path,
      //     filename: basename(requestModel.courseImageFile.path),
      //   ),
      // );

      // if (requestModel.courseImageUrl != null &&
      //     requestModel.courseImageUrl!.isNotEmpty) {
      //   request.fields['CourseImageUrl'] = requestModel.courseImageUrl!;
      // }

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 25));

      final response = await http.Response.fromStream(streamedResponse);
      // log(response.body);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 204) {
        return {'status': true};
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> multipartCreateCourseContent(
      String progLink, CreateCourseContentRequest requestModel) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      final url = Uri.parse('$baseUrlAddress/$progLink');

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] =
            'Bearer ${accessToken ?? MevTechUtilities.authKey}'
        ..fields.addAll(requestModel.toJson());

      final courseContentThumbnailFile =
          requestModel.courseContentThumbnailFile;
      if (courseContentThumbnailFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'CourseImageFile',
            courseContentThumbnailFile.path,
            filename: basename(requestModel.courseContentThumbnailFile!.path),
          ),
        );
      }

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 25));

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> multipartRequestUploadImage({
    required String progLink,
    required String userId,
    required File imageFile,
  }) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      final url = Uri.parse('$baseUrlAddress/$progLink');

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] =
            'Bearer ${accessToken ?? MevTechUtilities.authKey}'
        ..fields['UserId'] = userId
        ..files.add(
          await http.MultipartFile.fromPath(
            'UserProfilePictureFile',
            imageFile.path,
            filename: basename(imageFile.path),
          ),
        );

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 25));

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> refreshTokenRequest() async {
    try {
      final accessToken = await localStorage.getApiKey();
      final refreshToken = await localStorage.getApiRefreshToken();

      if (accessToken == null || refreshToken == null) {
        throw Exception('Session expired. Please log in again.');
      }

      final url = Uri.parse('$baseUrlAddress/v1/auth/refresh-token');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode({
              'accessToken': accessToken,
              'refreshToken': refreshToken,
            }),
          )
          .timeout(const Duration(seconds: 25));
      // log(response.body);

      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;

        if (result['status'] == true && result['data'] != null) {
          final data = result['data'] as Map<String, dynamic>;

          final newToken = data['accessToken'];
          final newRefreshToken = data['refreshToken'];

          if (newToken != null && newToken is String) {
            await localStorage.setApiKey(newToken);
            MevTechUtilities.authKey = newToken;
            if (newRefreshToken != null && newRefreshToken is String) {
              await localStorage.setApiRefreshToken(newRefreshToken);
            }
            return newToken;
          }
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<dynamic> initiateGoogleSignIn() async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) return 'Check your Internet Connection';

      final redirectUri = getRedirectUri();
      final url = Uri.parse(
        'https://mev-tech-api.onrender.com/get-google-auth-url?redirectUri=$redirectUri',
      );
      final uri = Uri.parse(redirectUri);
      final scheme = uri.scheme;

      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        final returnedData = json.decode(response.body) as Map<String, dynamic>;

        if (returnedData['status'] == true && returnedData['data'] != null) {
          final data = returnedData['data'] as Map<String, dynamic>;
          final returnedUrl = data['url'] as String;

          final result = await FlutterWebAuth2.authenticate(
            url: returnedUrl,
            callbackUrlScheme: scheme,
          );

          return result;
        } else {
          throw FailureResponse.fromResponse(returnedData);
        }
      } else {
        return handleError(response);
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> youtubeVideoRequest({
    required String baseUrl,
    required String progLink,
  }) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) return 'Check your Internet Connection';

      final url = Uri.parse('$baseUrl$progLink');

      final response = await http.get(url).timeout(const Duration(seconds: 25));

      // final jsonTestData = json.encode(jsonData);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> uploadFileRequest(String progLink, File file) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final url = Uri.parse('$baseUrlAddress/$progLink');

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer ${MevTechUtilities.authKey}'
        ..files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: basename(file.path),
          ),
        );

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 25));

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> downloadFileRequest(
    String progLink, {
    bool authRequired = true,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      final url = Uri.parse('$baseUrlAddress/$progLink')
          .replace(queryParameters: queryParams);
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${accessToken ?? MevTechUtilities.authKey}',
      };

      final headers2 = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final response = await http
          .get(
            url,
            headers: authRequired ? headers : headers2,
          )
          .timeout(const Duration(seconds: 25));

      // final jsonTestData = json.encode(jsonData);

      if (response.statusCode == 200) {
        log(response.body);
        return response.body;
        // return json.decode(response.body);
      } else {
        handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

// chat functionality

  Future<dynamic> chatMultipartRequestCreate(
    String progLink,
    ChatMessageRequest requestModel,
  ) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

      final accessToken = await localStorage.getApiKey();

      final url = Uri.parse('$baseUrlAddress/$progLink');

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] =
            'Bearer ${accessToken ?? MevTechUtilities.authKey}'
        ..fields['RoomId'] = requestModel.roomId
        ..fields['Content'] = requestModel.content
        ..fields['MessageType'] = requestModel.messageType
        ..fields['ReplyToId'] = requestModel.replyToId;

      if (requestModel.mediaFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'MediaFile',
            requestModel.mediaFile!.path,
            filename: basename(requestModel.mediaFile!.path),
          ),
        );
      }

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 25));

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

// Future<File> downloadImageToFile(String imageUrl) async {
//   final response = await http.get(Uri.parse(imageUrl));

//   if (response.statusCode == 200) {
//     // Get temporary directory
//     final tempDir = await getTemporaryDirectory();

//     // Create file path
//     final fileName = path.basename(imageUrl);
//     final file = File('${tempDir.path}/$fileName');

//     // Write the bytes
//     await file.writeAsBytes(response.bodyBytes);

//     return file;
//   } else {
//     throw Exception('Failed to download image');
//   }
// }

  File? selectedImageFile;
  String? imageUrl; //
  Future<void> onImageTapped() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImageFile = File(pickedFile.path);
      imageUrl = null; // Clear URL, since we now have a file
      // Update UI
    }
  }

// When submitting:
// Future<void> onSubmit() async {
//   File fileToUpload;

//   if (selectedImageFile != null) {
//     // User picked new image
//     fileToUpload = selectedImageFile!;
//   } else if (imageUrl != null) {
//     // Use the existing network image → download it
//     fileToUpload = await downloadImageToFile(imageUrl!);
//   } else {
//     throw Exception('No image selected');
//   }

//   // Now upload fileToUpload to API as Multipart
// }

  String getRedirectUri() {
    const currentFlavor = String.fromEnvironment('FLAVOR');
    switch (currentFlavor) {
      case 'production':
        return 'dev.adryanev.template://auth-callback';
      case 'staging':
        return 'dev.adryanev.template.stg://auth-callback';
      case 'development':
        return 'dev.adryanev.template.dev://auth-callback';
      default:
        throw Exception('Unknown or missing FLAVOR');
    }
  }

  String getYouTubeVideoId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? '';
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    }
    return '';
  }

  dynamic handleError(http.Response response) {
    try {
      final error = json.decode(response.body);
      return error;
    } catch (_) {
      return response.reasonPhrase ?? 'An error occurred';
    }
  }

  int handleNotFoundError(http.Response response) {
    try {
      final error = json.decode(response.body);
      if (error is Map) {
        final responseString = error['responseCode'] as String;
        final responseCode = int.parse(responseString);
        return responseCode;
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  Future<dynamic> videoToThumbnailRequest(String videoUrl) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) return 'Check your Internet Connection';

      final videoId = MevTechUtilities.extractYoutubeId(videoUrl);

      final url = Uri.parse('https://www.youtube.com/embed/$videoId');

      final response = await http.get(url).timeout(const Duration(seconds: 25));

      // final jsonTestData = json.encode(jsonData);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> videoEmbedableRequest(String videoUrl) async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) return 'Check your Internet Connection';

      final videoId = MevTechUtilities.extractYoutubeId(videoUrl);

      final url = Uri.parse(
          'https://www.googleapis.com/youtube/v3/videos?part=status&id=$videoId&key=$youtubeApiKey');

      final response = await http.get(url).timeout(const Duration(seconds: 25));

      // final jsonTestData = json.encode(jsonData);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return handleError(response);
      }
    } on TimeoutException {
      return 'Request timed out. Please try again.';
    } catch (e) {
      return e.toString();
    }
  }

  dynamic mockData() async {
    return {
      'status': true,
      'responseCode': '200',
      'responseMessage': 'Request was successful.',
      'data': {
        'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
        'userInformation': {
          'id': '70c4e4f6-cba1-4635-5e92-08ddb88cec3b',
          'username': 'kunle7',
          'firstName': 'kunle',
          'lastName': 'kelani',
          'email': 'kunle@gmail.com',
          'phoneNumber': '08023456721',
          'password': null,
          'isAdmin': false,
          'isInstructor': true,
          'userType': null,
          'status': 'ACTIVE',
          'isEmailVerified': false,
          'isPhoneNumberVerified': false,
          'roles': null,
          'isLockedOut': false,
          'isDisabled': false,
          'createdAt': '2025-07-01T10:49:15.2842169',
          'updatedAt': '2025-07-01T10:49:15.2842172',
        },
      },
    };
  }
}

// $expand
// $filter
// $select
// $orderby
// top
// skip

// .expand("user")
// .filter("contains(comment, 'flutter')")
// .select("id,comment")
// .orderBy("createdDate desc")
// .top(10)
// .skip(20)

// Future<String?> getToken() async {
//   return MevTechUtilities.authKey ??
//          context.read<SessionCubit>().state.token ??
//          await localStorage.getApiKey();
// }

// final token = await getToken();
