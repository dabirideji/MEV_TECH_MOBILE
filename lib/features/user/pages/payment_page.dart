import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({required this.paymentUrl, super.key});
  final String paymentUrl;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        // onPageFinished: _handlePageFinished,
        onNavigationRequest: (NavigationRequest request) {
          // Define your custom deep link scheme here.
          // This is the URL you provided to the payment gateway.
          // const myAppDeepLink = 'dev.adryanev.template.dev://payment_complete';
          const myAppDeepLink = 'https://www.google.com';
          // 'myapp://payment_complete';
          // https://www.google.com/

          // Check if the URL starts with your deep link.
          if (request.url.startsWith(myAppDeepLink)) {
            // The callback URL has been received.
            // You can parse the URL for status, reference, etc.
            debugPrint('Intercepted callback URL: ${request.url}');

            // Close the current webview page and navigate back.
            // Navigator.pop() returns to the previous page on the stack.
            Navigator.of(context).pop(true);

            // You can also push a new page or show a dialog here.
            // For example: Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PaymentSuccessPage()));

            // Prevent the webview from loading the URL.
            return NavigationDecision.prevent;
          }

          // Allow all other URLs to be loaded by the webview.
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  Future<void> _handlePageFinished(String url) async {
    try {
      final content = await _controller
          .runJavaScriptReturningResult('document.body.innerText');
      // final parsedContent =
      //     (content as String).replaceAll(r'\"', '"').replaceAll(r'\n', '');
      // final cleanJson = parsedContent.trim().replaceAll(RegExp(r'^"|"$'), '');

      // final json = jsonDecode(cleanJson) as Map<String, dynamic>;

      // if (json['status'] == true && json['data']?['token'] != null) {
      //   final token = json['data']['token'];
      //   final user = json['data']['user'];
      //   // ✅ Store token, update session, navigate, etc.
      //   print('TOKEN: $token');
      //   print('USER: $user');

      //   if (mounted) {
      //     Navigator.of(context).pop({'token': token, 'user': user});
      //   }
      // }
      if (mounted) {
        Navigator.of(context).pop({'token': 'token', 'user': 'user'});
      }
    } catch (e) {
      print('Error parsing login result: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Complete Payment',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          )),
      body: WebViewWidget(controller: _controller),
    );
  }
}
