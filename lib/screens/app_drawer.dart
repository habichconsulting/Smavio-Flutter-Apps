import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:new_version/new_version.dart';
import 'package:smavio/apicall/api_calls.dart';
import 'package:smavio/common_string.dart';
import 'package:smavio/main.dart';
import 'package:smavio/screens/login_scrn.dart';
import 'package:smavio/utils/hive_helper.dart';

import '../constant.dart';
import 'app_web_view.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  NewVersion? newVersion;
  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    await HiveDBServices().getLoginData();
    newVersion = NewVersion(
      // iOSId: 'com.google.Vespa',
      androidId: loginData[0].packageName,
    );
  }

  navigateRoute() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScrn()));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("You are logged Out"),
      animation: null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(color: primary),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: buttonColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: const Text(
                    'Hauptmenü',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        color: buttonColor,
                        child: ListTile(
                          tileColor: buttonColor,
                          selectedTileColor: buttonColor,
                          onTap: () async {
                            Navigator.pop(context);
                            isUpdateAvilable == true
                                ? await updateCompaign()
                                : showCustomAlertBox(
                                    buttonText: 'Ok',
                                    isOntapClos: true,
                                    ontap: () {
                                      Navigator.pop(
                                          navigatorKey.currentContext!);
                                    },
                                    islogOut: true,
                                    context: context,
                                    title: 'Compaign is already updated',
                                    body: '');
                          },
                          title: Text(
                            CommonString.campaignUpdate,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        color: buttonColor,
                        child: ListTile(
                          tileColor: buttonColor,
                          onTap: () async {
                            Navigator.pop(context);
                            await advancedStatusCheck(newVersion!, context);
                          },
                          title: Text(
                            CommonString.softwareUpdate,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        color: buttonColor,
                        child: ListTile(
                          onTap: () async {
                            await ApiCalls().getLogout(context);
                            // await HiveDBServices().deleteLogin();
                            // navigate();
                          },
                          title: Text(
                            CommonString.a1,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                        Container(
                        margin: const EdgeInsets.only(top: 10),
                        color: buttonColor,
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 25),
                                    child: Form(
                                      key: _key,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Standort'),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Flexible(
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Bitte Stadt eingeben';
                                                }
                                                return null;
                                              },
                                              // style: TextStyle(color: Colors.white),
                                              controller: cityController,
                                              keyboardType:
                                                  TextInputType.emailAddress,

                                              decoration: InputDecoration(
                                                // focusColor: Colors.white,
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.only(left: 20),
                                                // hintStyle: bodyText2(
                                                //     context: context, color: Colors.black),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                hintText: "Stadt",
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                disabledBorder:
                                                    InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Flexible(
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Bitte Straße eingeben';
                                                }
                                                return null;
                                              },
                                              // style: TextStyle(color: Colors.white),
                                              controller: streetController,
                                              keyboardType:
                                                  TextInputType.emailAddress,

                                              decoration: InputDecoration(
                                                // focusColor: Colors.white,
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.only(left: 20),
                                                // hintStyle: bodyText2(
                                                //     context: context, color: Colors.black),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                hintText: "Straße",
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                disabledBorder:
                                                    InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Flexible(
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Bitte geben Sie die Hausnummer ein';
                                                }
                                                return null;
                                              },
                                              // style: TextStyle(color: Colors.white),
                                              controller: houseNumberController,
                                              keyboardType:
                                                  TextInputType.emailAddress,

                                              decoration: InputDecoration(
                                                // focusColor: Colors.white,
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.only(left: 20),
                                                // hintStyle: bodyText2(
                                                //     context: context, color: Colors.black),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                hintText: "Hausnummer",
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                disabledBorder:
                                                    InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          ElevatedButton(
                                              onPressed: () async {
                                                await HiveDBServices()
                                                    .getLoginData();
                                                if (_key.currentState!
                                                    .validate()) {
                                                  log('form 2 validated');
                                                  //TODO: call api
                                                  Map requestBody = {
                                                    "city": cityController.text,
                                                    "state":
                                                        streetController.text,
                                                    "houseno":
                                                        houseNumberController
                                                            .text,
                                                    "deviceId":
                                                        loginData.first.deviceId
                                                  };

                                                  await ApiCalls()
                                                      .changeLocation(
                                                          body: requestBody)
                                                      .then((v) {
                                                    if (v.success == false) {
                                                      showCustomAlertBox(
                                                          buttonText: 'Ok',
                                                          ontap: () {
                                                            Navigator.pop(
                                                                navigatorKey
                                                                    .currentContext!);
                                                          },
                                                          islogOut: true,
                                                          context: context,
                                                          title: 'Fehler',
                                                          body: v.msg!);
                                                    } else if (v.success ==
                                                        true) {
                                                      Utills().saveLoginToLocal(
                                                          state: cityController
                                                              .text,
                                                          street:
                                                              streetController
                                                                  .text,
                                                          houseno:
                                                              houseNumberController
                                                                  .text);
                                                      Navigator.pop(context);
                                                    }
                                                  });
                                                }
                                              },
                                              child: Text('Absenden'))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          title: Text(
                            CommonString.changeLocation,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                   
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        color: buttonColor2,
                        child: ListTile(
                          onTap: () {
                            showCustomAlertBox(
                                ontapClose: () {
                                  Navigator.pop(context);
                                },
                                ontap: () => exit(0),
                                islogOut: false,
                                buttonText: 'Yes',
                                context: context,
                                title: 'Exit',
                                body: 'Do you Want to exit App! ');
                          },
                          title: Text(
                            CommonString.a2,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        color: buttonColor2,
                        child: ListTile(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          title: Text(
                            CommonString.a3,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                     ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      CommonString.a4,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white),
                    )),
                Container(
                  alignment: Alignment.center,
                  color: buttonColor2,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '${CommonString.a5}${loginData[0].appVersion}',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  navigate() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScrn()),
        (route) => false);
  }

  updateCompaign() async {
    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return const SimpleDialog(
          children: [
            LinnearAnimation(
              title: 'Update wird heruntergeladen',
            ),
          ],
        );
      },
    );
    await showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return const SimpleDialog(
          children: [
            LinnearAnimation(
              title: 'Update wird installiert',
            ),
          ],
        );
      },
    );

    await showCustomAlertBox(
        buttonText: 'Ok',
        isbarrierDismiss: false,
        ontap: () async {
          Navigator.pop(navigatorKey.currentContext!);
          await ApiCalls().updateCampaign(body: {
            "device_uuid": loginData.last.deviceId,
            "device_type": 'app'
          }).whenComplete(() {
            Navigator.pushReplacement(navigatorKey.currentContext!,
                MaterialPageRoute(builder: (context) => AppWebView()));
          });
        },
        islogOut: true,
        context: navigatorKey.currentContext!,
        title: 'Update',
        body: 'update completed');
  }
}

class LinnearAnimation extends StatefulWidget {
  final String title;
  const LinnearAnimation({super.key, required this.title});

  @override
  State<LinnearAnimation> createState() => _LinnearAnimationState();
}

class _LinnearAnimationState extends State<LinnearAnimation> {
  double _progressValue = 0;
  bool _isComplete = false;
  String _percentageText = '0%';
  @override
  void initState() {
    _startProgress();

    super.initState();
  }

  void _startProgress() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (Timer t) {
      setState(() {
        _progressValue += 0.2;
        _percentageText = '${(_progressValue * 100).round()}%';
        if (_progressValue >= 1.0) {
          _isComplete = true;
          t.cancel();
          Navigator.pop(context);

          //show popup
        }
      });
    });
  }

  showpopup() {
    showDilog('Compaign updated', context, ontap: () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Text(
            // 'Update wird heruntergeladen',
            widget.title,
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: LinearProgressIndicator(
              minHeight: 50,
              value: _isComplete ? null : _progressValue,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            _percentageText,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'smavio',
            style: TextStyle(fontSize: 16),
          ),
          const Text(
            'version 1.0.0',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
