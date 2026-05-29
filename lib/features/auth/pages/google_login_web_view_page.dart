import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleLoginWebViewPage extends StatefulWidget {
  const GoogleLoginWebViewPage({required this.provider, super.key});
  final String provider;

  @override
  State<GoogleLoginWebViewPage> createState() => _GoogleLoginWebViewPageState();
}

class _GoogleLoginWebViewPageState extends State<GoogleLoginWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: _handlePageFinished,
      ))
      ..loadRequest(Uri.parse(
          'https://mev-tech-api.onrender.com/api/v1/OAuth/LoginWithProvider/oauth/login/${widget.provider}'));
  }

  Future<void> _handlePageFinished(String url) async {
    try {
      final content = await _controller
          .runJavaScriptReturningResult('document.body.innerText');
      final parsedContent =
          (content as String).replaceAll(r'\"', '"').replaceAll(r'\n', '');
      final cleanJson = parsedContent.trim().replaceAll(RegExp(r'^"|"$'), '');

      final json = jsonDecode(cleanJson) as Map<String, dynamic>;

      if (json['status'] == true && json['data']?['token'] != null) {
        final token = json['data']['token'];
        final user = json['data']['user'];
        // ✅ Store token, update session, navigate, etc.
        print('TOKEN: $token');
        print('USER: $user');

        if (mounted) {
          Navigator.of(context).pop({'token': token, 'user': user});
        }
      }
    } catch (e) {
      print('Error parsing login result: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in with Google')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
