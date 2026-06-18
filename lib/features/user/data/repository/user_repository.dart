import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mevtech/core/error/failure_response.dart';
import 'package:mevtech/core/network/api_service.dart';
import 'package:mevtech/core/utils/constants.dart';
import 'package:mevtech/data/generic_repository.dart';
import 'package:mevtech/data/google_signin.dart';
import 'package:mevtech/data/paginated_model.dart';
import 'package:mevtech/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:mevtech/features/quiz/data/models/question_model.dart';
import 'package:mevtech/features/quiz/data/models/subject_model.dart';
import 'package:mevtech/features/user/data/models/login_model.dart';
import 'package:mevtech/features/user/data/models/subscription_model.dart';
import 'package:mevtech/features/user/data/models/user_model.dart';
import 'package:mevtech/features/user/data/models/user_requests.dart.dart';

@singleton
class UserRepository {
  UserRepository(this.apiService);

  final ApiService apiService;
  final googleSigninService = GoogleSigninService();

  Future<String> refreshToken({
    required String token,
    required String refreshToken,
  }) async {
    final result = await apiService.refreshTokenRequest();
    if (result == null) {
      throw FailureResponse.fromResponse(
        'Session expired. Please login again.',
      );
    }
    return result;
  }

  Future<LoginModel> checkUserSession({
    required String token,
    required String id,
    required String refreshToken,
  }) async {
    final progLink = 'Student/GetById/$id';
    final result = await apiService.getJsonRequest(progLink, token: token);

    // this result is a test and should be removed, the above comment is the original
    // final result = await apiService.mockData();

    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final userInformation = result['data'] as Map<String, dynamic>;

        final data = <String, dynamic>{
          'accessToken': token,
          'refreshToken': refreshToken,
          'userSubscription': userInformation['userSubscription'],
          'userInformation': userInformation,
        };

        MevTechUtilities.authKey = token;
        MevTechUtilities.refreshToken = refreshToken;
        MevTechUtilities.id = id;
        // log(id);

        return LoginModel.fromJson(data);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown Error');
    }
  }

  // /api/v1/test/TestOneSignalConnection/test-onesignal-connection

  Future<String> testNotifiion(String userId) async {
    const progLink =
        'v1/test/TestOneSignalConnection/test-onesignal-connection';
    final result = await apiService.testPostJson(
      progLink,
      queryParameters: {'userId': userId},
    );

    // this result is a test and should be removed, the above comment is the original
    // final result = await apiService.mockData();

    if (result != null && result is String) {
      // if (result is Map && result['status'] == true && result['data'] != null) {
      //   // final data = result['data'] as Map<String, dynamic>;
      //   return 'test';
      // } else {
      //   throw FailureResponse.fromResponse(result);
      // }
      return result;
    } else {
      throw FailureResponse.fromResponse('Unknown Error');
    }
  }

  Future<LoginModel> googleSignIn() async {
    final userData = await returnedGoogleData();

    final progLink = 'Student/GetById/${userData.id}';
    final result = await apiService.getJsonRequest(
      progLink,
      token: userData.accessToken,
    );

    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final userInformation = result['data'] as Map<String, dynamic>;

        final data = <String, dynamic>{
          'accessToken': userData.accessToken,
          'refreshToken': userData.refreshtoken,
          'userSubscription': null,
          'userInformation': userInformation,
        };

        MevTechUtilities.authKey = userData.accessToken;
        MevTechUtilities.refreshToken = userData.refreshtoken;
        MevTechUtilities.id = userData.id;
        // log(id);

        return LoginModel.fromJson(data);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // ======================== Students Endpoint ========================

  Future<String> createStudent(RegisterRequest jsonData) async {
    final result = await apiService.postJsonRequest(
      jsonData.toJson(),
      'Student/Create',
      authRequired: false,
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<LoginModel> loginStudent(LoginRequest jsonData) async {
    final result = await apiService.postJsonRequest(
      jsonData.toJson(),
      'Student/Login',
      authRequired: false,
    );
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        MevTechUtilities.authKey = data['accessToken'].toString();
        MevTechUtilities.refreshToken = data['refreshToken'].toString();

        final userInfo = data['userInformation'] as Map<String, dynamic>;

        MevTechUtilities.id = userInfo['id'].toString();

        return LoginModel.fromJson(data);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  //  final data = result['data'] as Map<String, dynamic>;

  //       MevTechUtilities.authKey = data['accessToken'].toString();
  //       MevTechUtilities.refreshToken = data['refreshToken'].toString();

  //       final userInfo = data['userInformation'] as Map<String, dynamic>;

  //       MevTechUtilities.id = userInfo['id'].toString();

  //       return LoginModel.fromJson(data);

  Future<UserGoogleModel> returnedGoogleData() async {
    final result = await apiService.initiateGoogleSignIn();
    if (result != null && result is String) {
      try {
        return UserGoogleModel.fromJson(result);
      } catch (e) {
        throw FailureResponse.fromResponse('$result $e');
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<UserModel> getStudentbyID(String id) async {
    final result = await apiService.getJsonRequest('Student/GetById/$id');
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        return UserModel.fromJson(data);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<UserModel> updateStudent(UpdateUserRequest jsonData, String id) async {
    final result = await apiService.updateJsonRequest(
      jsonData.toJson(),
      'Student/Update/${jsonData.id}',
    );

    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;
        final userInfo = data['userInformation'] as Map<String, dynamic>;
        return UserModel.fromJson(userInfo);
      } else if (result is Map && result['status'] == true) {
        final user = await getStudentbyID(id);
        return user;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> deleteStudent(DeleteUserRequest jsonData, String id) async {
    final result = await apiService.deleteJsonRequest(
      'Student/Delete/${jsonData.id}',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // dynamic data = {'status': true, 'responseMessage': 'Hell Yah Success'};

  Future<String> deleteAccount() async {
    final result = await apiService.deleteJsonRequest('v1/auth/delete-account');
    // final result = await Future.delayed(const Duration(seconds: 2), () {
    //   return data;
    // });
    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<bool> markNotifAsread(String id) async {
    final result = await apiService.patchJsonRequest(
      'Notification/MarkNotificationAsRead/$id/mark-as-read',
    );

    if (result != null) {
      if (result is bool && result == true) {
        return result;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // email verify

  Future<String> sendEmailConfirmToken(Map<String, dynamic> jsonData) async {
    final result = await apiService.postJsonRequest(
      jsonData,
      'Token/SendToken',
      authRequired: false,
    );
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;
        final message = data['message'] as String;

        return message;
        // return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> verifyEmailConfirmToken(Map<String, dynamic> jsonData) async {
    final result = await apiService.getJsonRequest(
      'Token/VerifyToken',
      queryParams: jsonData,
      authRequired: false,
    );
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;
        final message = data['message'] as String;

        return message;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> sendPasswordResetToken(
    PasswordResetTokenRequest jsonData,
  ) async {
    final result = await apiService.postJsonRequest(
      jsonData.toJson(),
      'Token/SendPasswordResetToken',
      authRequired: false,
    );
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;
        final message = data['message'] as String;

        return message;
        // return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> verifyPasswordResetToken(
    VerifyPasswordResetTokenRequest jsonData,
  ) async {
    final result = await apiService.postJsonRequest(
      jsonData.toJson(),
      'Token/VerifyPasswordResetToken',
      authRequired: false,
    );
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;
        final message = data['message'] as String;

        return message;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> resetPasswordStudent(ResetPasswordRequest jsonData) async {
    final result = await apiService.postJsonRequest(
      jsonData.toJson(),
      'Student/ResetPassword',
      authRequired: false,
    );
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        final message = data['message'] as String;

        return message;

        // return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<UserModel>> getAllStudent() async {
    final result = await apiService.getJsonRequest('Student/GetAll');
    // /api/Student/GetAllAsQueryable
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;
        return data
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<UserModel>> getAllAsQueryStudent() async {
    final result = await apiService.getJsonRequest('Student/GetAllAsQueryable');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;
        return data
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<void> requestEmailVerifToken(Map<String, dynamic> jsonData) async {
    final result = await apiService.postJsonRequest(
      jsonData,
      'Token/SendToken',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        // if (result['data'] != null) {
        //   myList.clear();
        //   final user = result['data'] as Map<String, dynamic>;

        //   myList.add(user);
        // }
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<void> verifyEmailToken(Map<String, dynamic> queryParams) async {
    final result = await apiService.getJsonRequest(
      'Token/VerifyToken',
      queryParams: queryParams,
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        // if (result['data'] != null) {
        //   myList.clear();
        //   final user = result['data'] as Map<String, dynamic>;

        //   myList.add(user);
        // }
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<UserModel> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    final result = await apiService.multipartRequestUploadImage(
      progLink: 'Student/UploadProfilePicture',
      userId: userId,
      imageFile: imageFile,
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        // return result['responseMessage'] as String;
        final data = result['data'] as Map<String, dynamic>;
        return UserModel.fromJson(data);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // Future<void> uploadImage() async {
  //   final picker = ImagePicker();
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     final file = File(picked.path);
  //     final result = await apiService.uploadFileRequest('File/upload', file);
  //     if (result != null) {
  //       if (result is Map && result['status'] == true) {
  //       } else {
  //         throw FailureResponse.fromResponse(result);
  //       }
  //     } else {
  //       throw FailureResponse.fromResponse('Unknown');
  //     }
  //   } else {
  //     throw FailureResponse.fromResponse('Image Not Selected');
  //   }
  // }

  Future<void> downloadImage() async {
    final queryParams = <String, dynamic>{
      'path': 'FileUploads/UserUploads/p5kb0OP6kU.png',
    };
    final result = await apiService.downloadFileRequest(
      'File/download',
      queryParams: queryParams,
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        // if (result['data'] != null) {
        //   myList.clear();
        //   final user = result['data'] as Map<String, dynamic>;

        //   myList.add(user);
        // }
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // ========================== Instructor Endpoint ====================

  Future<String> createInstructor(RegisterRequest jsonData) async {
    final result = await apiService.postJsonRequest(
      jsonData.toJson(),
      'Instructor/Create',
      authRequired: false,
    );

    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<LoginModel> loginInstructor(LoginRequest jsonData) async {
    final result = await apiService.postJsonRequest(
      jsonData.toJson(),
      'Instructor/Login',
      authRequired: false,
    );
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        MevTechUtilities.authKey = data['accessToken'].toString();
        MevTechUtilities.refreshToken = data['refreshToken'].toString();

        final userInfo = data['userInformation'] as Map<String, dynamic>;

        MevTechUtilities.id = userInfo['id'].toString();

        return LoginModel.fromJson(data);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<UserModel> getInstructorbyID(String id) async {
    final result = await apiService.getJsonRequest('Instructor/GetById/$id');
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        return UserModel.fromJson(data);
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<UserModel> updateInstructor(
    UpdateUserRequest jsonData,
    String id,
  ) async {
    final result = await apiService.updateJsonRequest(
      jsonData.toJson(),
      'Instructor/Update/${jsonData.id}',
    );

    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;
        final userInfo = data['userInformation'] as Map<String, dynamic>;
        return UserModel.fromJson(userInfo);
      } else if (result is Map && result['status'] == true) {
        final user = await getInstructorbyID(id);
        return user;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> resetPasswordInstructor(ResetPasswordRequest jsonData) async {
    final result = await apiService.postJsonRequest(
      jsonData.toJson(),
      'Instructor/ResetPassword',
      authRequired: false,
    );
    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        final message = data['message'] as String;

        return message;

        // return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<List<UserModel>> getAllInstructors() async {
    final result = await apiService.getJsonRequest('Instructor/GetAll');
    if (result != null) {
      if (result is Map && result['status'] == true) {
        final data = result['data'] as List<dynamic>;
        return data
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  Future<String> deleteInstructor(UpdateUserRequest jsonData, String id) async {
    final result = await apiService.deleteJsonRequest(
      'Instructor/Delete/${jsonData.id}',
    );
    if (result != null) {
      if (result is Map && result['status'] == true) {
        return result['responseMessage'] as String;
      } else {
        throw FailureResponse.fromResponse(result);
      }
    } else {
      throw FailureResponse.fromResponse('Unknown');
    }
  }

  // wrapper methods

  Future<PaginatedResponse<T>> fetchPaginated<T>({
    required String endPoint,
    required int page,
    required int pageSize,
    required T Function(Map<String, dynamic>) fromJson,
    String token = '',
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.getPaginated(page: page, pageSize: pageSize, token: token);
  }

  Future<List<T>> fetchAll<T>({
    required String endPoint,
    required T Function(Map<String, dynamic>) fromJson,
    bool authRequired = true,
    String token = '',
    Map<String, String>? queryParams,
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.getAll(
      queryParams: queryParams,
      authRequired: authRequired,
      token: token,
    );
  }

  Future<T> fetchById<T>({
    required String endPoint,
    required T Function(Map<String, dynamic>) fromJson,
    required String id,
    bool authRequired = true,
    String token = '',
    Map<String, String>? queryParams,
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.getById(
      id,
      queryParams: queryParams,
      authRequired: authRequired,
      token: token,
    );
  }

  Future<String> create<T>({
    required String endPoint,
    required Map<String, dynamic> jsonData,
    required T Function(Map<String, dynamic>) fromJson,
    bool authRequired = true,
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.add(jsonData, authRequired: authRequired);
  }

  Future<T> createModel<T>({
    required String endPoint,
    required Map<String, dynamic> jsonData,
    required T Function(Map<String, dynamic>) fromJson,
    bool authRequired = true,
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.addModel(jsonData, authRequired: authRequired);
  }

  Future<T> update<T>({
    required String endPoint,
    required Map<String, dynamic> jsonData,
    required String id,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.edit(jsonData, id);
  }

  Future<String> delete<T>({
    required String endPoint,
    required String id,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: endPoint,
      fromJson: fromJson,
    );
    return repo.remove(id);
  }

  Future<List<T>> fetchOdata<T>({
    required Uri url,
    required T Function(Map<String, dynamic>) fromJson,
    bool authRequired = true,
    String token = '',
  }) {
    final repo = GenericRepository<T>(
      apiService: apiService,
      endPoint: '',
      fromJson: fromJson,
    );
    return repo.getOdata(url: url, authRequired: authRequired, token: token);
  }

  // Quiz Section

  // Future<Subject> getSubjects() async {
  //   final result = await apiService.getJsonRequest('v1/quiz/subjects');
  //   if (result != null) {
  //     if (result is Map && result['status'] == true) {
  //       final data = result['data'] as Map<String, dynamic>;

  //       return Subject.fromJson(data);
  //     } else {
  //       throw FailureResponse.fromResponse(result);
  //     }
  //   } else {
  //     throw FailureResponse.fromResponse('Unknown');
  //   }
  // }

  // Future<List<QuestionModel>> getQuizQuestions({
  //   Map<String, dynamic>? queryParams,
  //   String? count,
  // }) async {
  //   final result = await apiService.getJsonRequest(
  //     // 'v1/quiz/questions/many',
  //     'v1/quiz/questions/$count',
  //     queryParams: queryParams,
  //   );
  //   if (result != null) {
  //     if (result is Map && result['status'] == true) {
  //       final data = result['data'] as Map<String, dynamic>;
  //       final actualData = data['data'] as List<dynamic>;

  //       return actualData
  //           .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
  //           .toList();
  //     } else {
  //       throw FailureResponse.fromResponse(result);
  //     }
  //   } else {
  //     throw FailureResponse.fromResponse('Unknown');
  //   }
  // }

  // Future<String> getQuizExplanation(String message) async {
  //   final jsonData = <String, dynamic>{'message': message};
  //   final result = await apiService.postJsonRequest(jsonData, 'chat');
  //   if (result != null) {
  //     if (result is Map && result['status'] == true) {
  //       final data = result['data'] as Map<String, dynamic>;
  //       final returnedMessage = data['response'] as String;
  //       return returnedMessage;
  //     } else {
  //       throw FailureResponse.fromResponse(result);
  //     }
  //   } else {
  //     throw FailureResponse.fromResponse('Unknown');
  //   }
  // }
}
