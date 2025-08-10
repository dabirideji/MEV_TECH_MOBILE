import 'package:template/core/utils/constants.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.isAdmin,
    required this.isInstructor,
    required this.status,
    required this.isEmailVerified,
    required this.isPhoneNumberVerified,
    required this.isLockedOut,
    required this.isDisabled,
    this.profilePictureUrl,
    this.roles,
    this.userType,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '') as String,
      username: (json['username'] ?? '') as String,
      firstName: (json['firstName'] ?? '') as String,
      lastName: (json['lastName'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phoneNumber: (json['phoneNumber'] ?? '') as String,
      isAdmin: (json['isAdmin'] ?? false) as bool,
      isInstructor: (json['isInstructor'] ?? false) as bool,
      profilePictureUrl: checkNullString(json['profilePictureUrl']),
      status: (json['status'] ?? '') as String,
      isEmailVerified: (json['isEmailVerified'] ?? false) as bool,
      isPhoneNumberVerified: (json['isPhoneNumberVerified'] ?? false) as bool,
      isLockedOut: (json['isLockedOut'] ?? false) as bool,
      isDisabled: (json['isDisabled'] ?? false) as bool,
      roles: (json['roles'] ?? '') as String,
      userType: (json['userType'] ?? '') as String,
      createdAt: (json['createdAt'] ?? '') as String,
      updatedAt: (json['updatedAt'] ?? '') as String,
    );
  }

  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? password;
  final bool isAdmin;
  final bool isInstructor;
  final String? profilePictureUrl;
  final String? userType;
  final String status;
  final bool isEmailVerified;
  final bool isPhoneNumberVerified;
  final String? roles;
  final bool isLockedOut;
  final bool isDisabled;
  final String? createdAt;
  final String? updatedAt;
}

// new user data with refresh token

// {
//   "status": true,
//   "responseCode": "200",
//   "responseMessage": "Request was successful.",
//   "data": {
//     "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTdWJqZWN0IjoiQkFTRV9BVVRIRU5USUNBVElPTiIsIlVzZXJJZCI6IjcwYzRlNGY2LWNiYTEtNDYzNS01ZTkyLTA4ZGRiODhjZWMzYiIsIkVtYWlsQWRkcmVzcyI6Imt1bmxlQGdtYWlsLmNvbSIsIlVzZXJOYW1lIjoia3VubGU3IiwibmJmIjoxNzUyMTUwOTkwLCJleHAiOjE3NTIxNTQ1OTAsImlhdCI6MTc1MjE1MDk5MCwiaXNzIjoiTUVWIFRFQ0gifQ.ru09RHNhIPMdl_aRiBTNF6c2rFdJQgKenBbMIP1tSNY",
//     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJTdWJqZWN0IjoiQkFTRV9BVVRIRU5USUNBVElPTiIsIlVzZXJJZCI6IjcwYzRlNGY2LWNiYTEtNDYzNS01ZTkyLTA4ZGRiODhjZWMzYiIsIkVtYWlsQWRkcmVzcyI6Imt1bmxlQGdtYWlsLmNvbSIsIlVzZXJOYW1lIjoia3VubGU3IiwibmJmIjoxNzUyMTUwOTkwLCJleHAiOjE3NTIxNTQ1OTAsImlhdCI6MTc1MjE1MDk5MCwiaXNzIjoiTUVWIFRFQ0gifQ.ru09RHNhIPMdl_aRiBTNF6c2rFdJQgKenBbMIP1tSNY",
//     "refreshToken": "hSwYmZ7E36OtuX67PkyXkzlXRRwGO6gajr15WSHWa3A=",
//     "userInformation": {
//       "id": "70c4e4f6-cba1-4635-5e92-08ddb88cec3b",
//       "username": "kunle7",
//       "firstName": "kunle",
//       "lastName": "kelani",
//       "email": "kunle@gmail.com",
//       "phoneNumber": "08023456721",
//       "password": null,
//       "isAdmin": false,
//       "isInstructor": true,
//       "userType": null,
//       "status": "ACTIVE",
//       "isEmailVerified": false,
//       "isPhoneNumberVerified": false,
//       "roles": null,
//       "isLockedOut": false,
//       "isDisabled": false,
//       "createdAt": "2025-07-01T10:49:15.2842169",
//       "updatedAt": "2025-07-01T10:49:15.2842172"
//     }
//   }
// }

// reset password response (change)
// {
//   "status": true,
//   "responseCode": "200",
//   "responseMessage": "Request was successful.",
//   "data": {
//     "response": true,
//     "message": "PASSWORD RESET SUCCESSFUL"
//   }
// }

// request
// {
//   "email": "ade@gmail.com",
//   "password": "Crypto123#",
//   "confirmPassword": "Crypto123#"
// }
