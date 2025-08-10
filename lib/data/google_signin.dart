import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:template/data/connection_checker.dart';
import 'package:template/features/auth/pages/google_login_web_view_page.dart';

class GoogleSigninService {
  static const baseUrlAddress = 'https://mev-tech-api.onrender.com/api';
  // GoogleSignIn googleSignIn = GoogleSignIn(
  //   scopes: ['email', 'profile'],
  // );

  // Future<dynamic> signInWithGoogle() async {
  //   try {
  //     final user = await googleSignIn.signIn();
  //     debugPrint('User signed in: ${user?.email}');

  //     if (user != null) {
  //       return user.id;
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  Future<dynamic> initiateGoogleSignInOld() async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();

      if (!hasInternet) {
        return 'Check your Internet Connection';
      }

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

          // dev.adryanev.template://?code=YOUR_AUTHORIZATION_CODE

          // Step 3: Extract code/token from redirect
          final token = Uri.parse(result).queryParameters['id'];

          // Step 4: Send the code to your backend to complete login
          final loginUrl = Uri.parse(
            'https://mev-tech-api.onrender.com/api/auth/google-mobile',
          );

          log(loginUrl.toString());
          log(token.toString());
          final headers = <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          };

          if (token != null) {
            final loginResponse = await http.post(
              loginUrl,
              body: json.encode({'idToken': token}),
              headers: headers,
            );

            if (loginResponse.statusCode == 200) {
              return json.decode(loginResponse.body);
            } else {
              throw Exception(loginResponse.body);
            }
          } else {
            return null;
          }
        } else {
          throw Exception(
            returnedData['responseMessage'] ?? 'Unknown Error Occured',
          );
        }
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      return e.toString();
    }
  }

  // main one to use

  Future<dynamic> initiateGoogleSignIn() async {
    try {
      final hasInternet = await InternetCheck.connectionStatus();
      if (!hasInternet) return 'Check your Internet Connection';

      final redirectUri = getRedirectUri();
      final scheme = Uri.parse(redirectUri).scheme;

      final loginUrl = Uri.parse(
        '$baseUrlAddress/v1/OAuth/LoginWithProvider/oauth/login/google?redirect_uri=$redirectUri',
      );

      final result = await FlutterWebAuth2.authenticate(
        url: loginUrl.toString(),
        callbackUrlScheme: scheme,
      );

      // Example redirect: yourapp://auth-callback?accessToken=...&refreshToken=...
      final uri = Uri.parse(result);
      final accessToken = uri.queryParameters['accessToken'];
      final refreshToken = uri.queryParameters['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        // ✅ Now you can store them in secure storage, and update session state
        return {
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        };
      } else {
        return 'Login failed: Missing tokens';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // String getRedirectUri() {
  //   const currentFlavor = String.fromEnvironment('FLAVOR');
  //   switch (currentFlavor) {
  //     case 'production':
  //       return 'dev.adryanev.template';
  //     case 'staging':
  //       return 'dev.adryanev.template.stg';
  //     case 'development':
  //       return 'dev.adryanev.template.dev';
  //     default:
  //       throw Exception('Unknown or missing FLAVOR');
  //   }
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

//   Future<void> initiateOAuthLogin(String provider) async {
//   final redirectUri = 'yourapp://auth/callback'; // Must be registered
//   final authUrl = Uri.parse(
//     '$baseUrlAddress/api/v1/OAuth/LoginWithProvider/oauth/login/$provider'
//   );

//   final finalUrl = Uri.parse('$authUrl?redirect_uri=$redirectUri');

//   if (await canLaunchUrl(finalUrl)) {
//     await launchUrl(finalUrl, mode: LaunchMode.externalApplication);
//   } else {
//     throw 'Could not launch $finalUrl';
//   }
// }

// void handleRedirect(Uri uri) {
//   if (uri.toString().startsWith('yourapp://auth/callback')) {
//     final token = uri.queryParameters['token'];
//     final userData = uri.queryParameters['userData'];
//     // Save token, update session, etc.
//   }
// }

  static Future<void> initiateOAuthLogin(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (_) => const GoogleLoginWebViewPage(provider: 'google'),
      ),
    );

    if (result != null && result['token'] != null) {
      final token = result['token'];
      final user = result['user'];
      // 🔐 Save token securely and update session
    }
  }
}
