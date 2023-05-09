import 'package:flutter/material.dart';
import 'package:smavio/screens/login_scrn.dart';
import 'package:smavio/screens/splash_scrn.dart';
import 'package:smavio/utils/hive_helper.dart';
import 'package:smavio/utils/local_storage_modal.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  State<CheckLogin> createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
   Future loginCheck(BuildContext context) async {
    await HiveDBServices().getLoginData();
    navigateRoute(loginData);
    
  }
    navigateRoute(List<LoginData> data){
if (data.isNotEmpty) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const SplashScrn()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScrn()));
    }
  }
  @override
  void initState() {
    loginCheck(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
