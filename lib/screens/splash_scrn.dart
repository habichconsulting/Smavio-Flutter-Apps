import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smavio/screens/app_web_view.dart';
import 'package:smavio/screens/login_scrn.dart';
import 'package:smavio/screens/macos_webview.dart';
import 'package:smavio/screens/webview_windows.dart';
import 'package:smavio/utils/hive_helper.dart';

import '../utils/local_storage_modal.dart';

class SplashScrn extends StatefulWidget {
  const SplashScrn({super.key});

  @override
  State<SplashScrn> createState() => _SplashScrnState();
}

class _SplashScrnState extends State<SplashScrn> {
  bool isLoading = false;
  Future loginCheck(BuildContext context) async {
    await HiveDBServices().getLoginData();
    navigateRoute(loginData);
  }

  navigateRoute(List<LoginData> data) {
    if (data.isNotEmpty) {
      if (Platform.isWindows) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WebViewWindows()));
      } else if (Platform.isIOS || Platform.isAndroid ) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AppWebView()));
      } else if (Platform.isMacOS) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MacOsWebview()));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginScrn()));
    }
  }

  Future startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      if (mounted) {
        loginCheck(context);
      }
    });
  }

  @override
  void initState() {
    startTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/app-icon.png',
          scale: 2.5,
        ),
      ),
    );
  }
}
