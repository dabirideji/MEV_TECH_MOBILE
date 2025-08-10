// user_requests.dart

class RegisterRequest {
  const RegisterRequest({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
  });

  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson() => {
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'confirmPassword': confirmPassword,
      };
}

class LoginRequest {
  const LoginRequest({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class UpdateUserRequest {
  const UpdateUserRequest({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
      };
}

class DeleteUserRequest {
  const DeleteUserRequest({required this.id});

  final String id;

  Map<String, dynamic> toJson() => {'id': id};
}

class PasswordResetTokenRequest {
  const PasswordResetTokenRequest({required this.emailAddress});

  final String emailAddress;
  Map<String, dynamic> toJson() => {'emailAddress': emailAddress};
}

class VerifyPasswordResetTokenRequest {
  const VerifyPasswordResetTokenRequest({
    required this.token,
    required this.userReferenceValue,
  });

  final String token;
  final String userReferenceValue;

  Map<String, dynamic> toJson() => {
        'token': token,
        'userReferenceValue': userReferenceValue,
      };
}

class ResetPasswordRequest {
  const ResetPasswordRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String email;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      };
}
