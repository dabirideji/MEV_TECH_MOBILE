import 'dart:developer';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:template/core/error/failure_response.dart';
import 'package:template/core/network/api_service.dart';
import 'package:template/core/utils/constants.dart';
import 'package:template/data/google_signin.dart';
import 'package:template/features/presentation/utilities-class/mev_tech_utilities.dart';
import 'package:template/features/user/data/models/login_model.dart';
import 'package:template/features/user/data/models/subscription_model.dart';
import 'package:template/features/user/data/models/user_model.dart';
import 'package:template/features/user/data/models/user_requests.dart.dart';

@singleton
class UserRepository {
  UserRepository(this.apiService);

  final ApiService apiService;
  final googleSigninService = GoogleSigninService();

  Future<LoginModel> checkUserSession({
    required String token,
    required String id,
    required String refreshToken,
    String? userType,
  }) async {
    final progLink = userType == UserType.instructor
        ? 'Instructor/GetById/$id'
        : 'Student/GetById/$id';
    final result = await apiService.getJsonRequest(
      progLink,
      token: token,
    );

// this result is a test and should be removed, the above comment is the original
    // final result = await apiService.mockData();

    if (result != null) {
      if (result is Map && result['status'] == true && result['data'] != null) {
        final userInformation = result['data'] as Map<String, dynamic>;

        final data = <String, dynamic>{
          'accessToken': token,
          'refreshToken': refreshToken,
          'userSubscription': null,
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

  Future<UserModel> getStudentbyID(String id) async {
    final result = await apiService.getJsonRequest(
      'Student/GetById/$id',
    );
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

  Future<String> resetPasswordStudent(
    ResetPasswordRequest jsonData,
  ) async {
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
    final result =
        await apiService.postJsonRequest(jsonData, 'Token/SendToken');
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

  Future<void> uploadImage() async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      final result = await apiService.uploadFileRequest('File/upload', file);

      if (result != null) {
        if (result is Map && result['status'] == true) {
        } else {
          throw FailureResponse.fromResponse(result);
        }
      } else {
        throw FailureResponse.fromResponse('Unknown');
      }
    } else {
      throw FailureResponse.fromResponse('Image Not Selected');
    }
  }

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
    final result = await apiService.getJsonRequest(
      'Instructor/GetById/$id',
    );
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
      UpdateUserRequest jsonData, String id) async {
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

  Future<String> resetPasswordInstructor(
    ResetPasswordRequest jsonData,
  ) async {
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
}
