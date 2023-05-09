import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smavio/screens/login_scrn.dart';

import '../apicall/api_calls.dart';
import '../constant.dart';

class ResetPasswordScrn extends StatefulWidget {
  final String forgotEmail;
  const ResetPasswordScrn({super.key, required this.forgotEmail});

  @override
  State<ResetPasswordScrn> createState() => _ResetPasswordScrnState();
}

class _ResetPasswordScrnState extends State<ResetPasswordScrn> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _otp = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SafeArea(
          child: Center(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(color: Colors.white),
          height: 400,
          width: Platform.isWindows
              ? scWidth(context) / 2.5
              : scWidth(context) / 1.8,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Du hast dein Passwort vergessen?",
                  // 'Tragen Sie Hier lhre E-Mail-Adresse ein und lhr Administrator meldet sich mit den Zugangsdaten.',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.grey[200],
                        child: TextFormField(
                          // enabled: false,
                          readOnly: true,
                          initialValue: widget.forgotEmail,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Email Address";
                            } else
                              return null;
                          },
                          // controller: _emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            focusColor: Colors.black,
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            contentPadding: EdgeInsets.only(left: 20),
                            // hintText: "Username or Email",
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            // hintText: "lhre E-Mail-Adresse",
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            disabledBorder: InputBorder.none,
                          ),
                          // onChanged: (value) => username = value,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Bitte geben Sie otp ein";
                          } else
                            return null;
                        },
                        controller: _otp,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusColor: Colors.black,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 20),
                          // hintText: "Username or Email",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: "OTP",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          disabledBorder: InputBorder.none,
                        ),
                        // onChanged: (value) => username = value,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Bitte Passwort eingeben";
                          } else
                            return null;
                        },
                        controller: _password,
                        decoration: InputDecoration(
                          focusColor: Colors.black,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 20),
                          // hintText: "Username or Email",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: "Passwort",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          disabledBorder: InputBorder.none,
                        ),
                        // onChanged: (value) => username = value,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Bitte geben Sie Passwort bestätigen ein";
                          } else
                            return null;
                        },
                        controller: _confirmPassword,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusColor: Colors.black,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 20),
                          // hintText: "Username or Email",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: "Confirm Passwort",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          disabledBorder: InputBorder.none,
                        ),
                        // onChanged: (value) => username = value,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        backgroundColor: buttonColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero)),
                    onPressed: () async {
                      hideKeyboard(context);

                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> body = {
                          "email": widget.forgotEmail,
                          "otp": _otp.text,
                          "password": _password.text,
                          "password_confirmation": _confirmPassword.text
                        };
                        log('validated $body');
                        //call forgot password

                        await ApiCalls().resetPassword(body: body).then((v) {
                          if (v!.success == true) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Das Kennwort wurde erfolgreich geändert. Sie können sich nun einloggen!")));
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScrn()),
                                (route) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(v.errors![0])));
                          }
                        });
                      }
                    },
                    child: Text('Neues Passwort anfordern')),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
