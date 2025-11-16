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

  // main one to use

  // Future<dynamic> initiateGoogleSignIn() async {
  //   try {
  //     final hasInternet = await InternetCheck.connectionStatus();
  //     if (!hasInternet) return 'Check your Internet Connection';

  //     final redirectUri = 'getRedirectUri()';
  //     final scheme = Uri.parse(redirectUri).scheme;

  //     final loginUrl = Uri.parse(
  //       '$baseUrlAddress/v1/OAuth/LoginWithProvider/oauth/login/google?redirect_uri=$redirectUri',
  //     );

  //     final result = await FlutterWebAuth2.authenticate(
  //       url: loginUrl.toString(),
  //       callbackUrlScheme: scheme,
  //     );

  //     // Example redirect: yourapp://auth-callback?accessToken=...&refreshToken=...
  //     final uri = Uri.parse(result);
  //     final accessToken = uri.queryParameters['accessToken'];
  //     final refreshToken = uri.queryParameters['refreshToken'];

  //     if (accessToken != null && refreshToken != null) {
  //       // ✅ Now you can store them in secure storage, and update session state
  //       return {
  //         'accessToken': accessToken,
  //         'refreshToken': refreshToken,
  //       };
  //     } else {
  //       return 'Login failed: Missing tokens';
  //     }
  //   } catch (e) {
  //     return e.toString();
  //   }
  // }

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
