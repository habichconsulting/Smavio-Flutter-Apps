import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smavio/apicall/api_calls.dart';
import 'package:smavio/screens/reset_pass_scrn.dart';

import '../constant.dart';

class ForgotPassScrn extends StatefulWidget {
  const ForgotPassScrn({super.key});

  @override
  State<ForgotPassScrn> createState() => _ForgotPassScrnState();
}

class _ForgotPassScrnState extends State<ForgotPassScrn> {
  TextEditingController _emailcontroller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();
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
                  'Zugangsdaten anforden',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Du hast dein Passwort vergessen?",
                  // 'Tragen Sie Hier lhre E-Mail-Adresse ein und lhr Administrator meldet sich mit den Zugangsdaten.',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                /* const TextField(
                  style: TextStyle(color: Colors.black),
                  // controller: _emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    focusColor: Colors.black,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(left: 20),
                    // hintText: "Username or Email",

                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintText: "Admin-Email",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    disabledBorder: InputBorder.none,
                  ),
                  // onChanged: (value) => username = value,
                ),
                // const SizedBox(
                //   height: 20,
                // ),*/
                Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Email Address";
                      } else
                        return null;
                    },
                    controller: _emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(left: 20),
                      // hintText: "Username or Email",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: "lhre E-Mail-Adresse",
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      disabledBorder: InputBorder.none,
                    ),
                    // onChanged: (value) => username = value,
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
                        log('validated');
                        //call forgot password
                        await ApiCalls().forgotPassword(
                            body: {"email": _emailcontroller.text}).then((v) {
                          if (v!.success == true) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text(v.message ?? "Something wen wrong")));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPasswordScrn(
                                        forgotEmail: _emailcontroller.text)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(v.errors![0])));
                          }
                        });
                      }
                    },
                    child: Text('Neues Passwort anfordern')),
                const SizedBox(
                  height: 25,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Zurück zum login'))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
