import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smavio/common_string.dart';
import 'package:smavio/main.dart';
import 'package:smavio/screens/app_drawer.dart';
import 'package:smavio/utils/hive_helper.dart';
import 'package:webview_windows/webview_windows.dart';
import '../apicall/api_calls.dart';
import '../constant.dart';
import 'login_scrn.dart';

class WebViewWindows extends StatefulWidget {
  const WebViewWindows({super.key});

  @override
  State<WebViewWindows> createState() => _WebViewWindowsState();
}

class _WebViewWindowsState extends State<WebViewWindows> {
  final _controller = WebviewController();
  bool _isWebviewSuspended = false;
  bool isLoadingfromApi = false;
  String? url;
  int currentIndex = 0;
  GlobalKey<FormState> _key = GlobalKey();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();
  @override
  void initState() {
    allMethods();
    super.initState();
  }

  allMethods() async {
    await checkAssignCompaign();
    await initPlatformState(url!);
  }

  checkAssignCompaign() async {
    await HiveDBServices().getLoginData();
    final prefs = await SharedPreferences.getInstance();
    await ApiCalls().getAssignCompaign(body: {
      "device_uuid": loginData.last.deviceId,
      "device_type": "app"
    }).then((value) {
      log(currentIndex.toString());

      if (value.success == false) {
        currentIndex == 0
            ? showCustomAlertBox(
                buttonText: 'Ok',
                isOntapClos: true,
                ontap: () {
                  Navigator.pop(navigatorKey.currentContext!);
                },
                islogOut: true,
                context: context,
                title: value.error!,
                body: '')
            : log('dilog should not show');
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(value.error!)));
      } else if (value.success == true) {
        prefs.setString('compaignId', value.campaignId!);
        //TODO:
        if (value.campaignId != compaingId &&
            compaingId.toString().isNotEmpty) {
          isUpdateAvilable = value.updateAvailable!;
          compaingId = value.campaignId;
          showCustomAlertBox(
              buttonText: 'Ok',
              isOntapClos: true,
              ontap: () {
                Navigator.pop(navigatorKey.currentContext!);
              },
              islogOut: true,
              context: context,
              title: 'Update Avilable',
              body: '');
          // Navigator.pushReplacement(
          //     context, MaterialPageRoute(builder: (context) => AppWebView()));
        } else if (compaingId.toString().isEmpty) {
          compaingId = value.campaignId;
        }

        // compaingId = prefs.getString('compaignId');

        log('${loginData[0].siteUrl}/campaign/${value.campaignId}/preview?deviceid=${loginData[0].deviceId}');

        setState(() {
          isLoadingfromApi = true;

          url =
              '${loginData[0].siteUrl}/campaign/${value.campaignId}/preview?deviceid=${loginData.last.deviceId}';
        });

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => AppWebView(
        //               appname: 'Smavio',
        //               deviceId: loginData.last.deviceId,
        //               url:
        //                   'https://sandbox.smavio.de/campaign/preview?deviceid=${loginData.last.deviceId}',
        //               success: value.success,
        //             )));
      }
      currentIndex++;
    });
    Timer(const Duration(seconds: 8), checkAssignCompaign);
  }

  Future<void> initPlatformState(String webUrl) async {
    // Optionally initialize the webview environment using
    // a custom user data directory
    // and/or a custom browser executable directory
    // and/or custom chromium command line flags
    //await WebviewController.initializeEnvironment(
    //    additionalArguments: '--show-fps-counter');

    try {
      await _controller.initialize();
      _controller.url.listen((url) {});

      await _controller.setBackgroundColor(Colors.transparent);
      await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await _controller.loadUrl(webUrl);

      if (!mounted) return;
      setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Error'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Code: ${e.code}'),
                      Text('Message: ${e.message}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('Continue'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      });
    }
  }

  Widget compositeView() {
    if (!_controller.value.isInitialized) {
      return const Text(
        '',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Stack(
        children: [
          Webview(
            _controller,
            permissionRequested: _onPermissionRequested,
          ),
          StreamBuilder<LoadingState>(
              stream: _controller.loadingState,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == LoadingState.loading) {
                  return LinearProgressIndicator();
                } else {
                  return SizedBox();
                }
              }),
        ],
      );
    }
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }

  logout(context) async {
    // await HiveDBServices().deleteLogin();
    await ApiCalls().getLogout(context);
    //
    // navigate();
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
                MaterialPageRoute(builder: (context) => WebViewWindows()));
          });
        },
        islogOut: true,
        context: navigatorKey.currentContext!,
        title: 'Update',
        body: 'update completed');
  }

  ///shutdown pc
  shutDownDevice() async {
    showCustomAlertBox(
        ontap: () async {
          // await FlutterExitWindowsEx.exitWindowsEx(EWX_SHUTDOWN);
        },
        isOntapClos: true,
        // islogOut: true,
        ontapClose: () {
          Navigator.pop(context);
        },
        buttonText: 'Ok',
        context: context,
        title: CommonString.a4,
        body: CommonString.turnOfDevice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 25,
        elevation: 0,
        //  title:Text(loginData[0].windows_location??'',style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white24,
        automaticallyImplyLeading: false,
        leading: PopupMenuButton(

            // color: buttonColor2,
            icon: Icon(
              Icons.more_horiz,
              color: Colors.black,
            ),
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      // padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      color: buttonColor,
                      child: Text(CommonString.campaignUpdate,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white))),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      // padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      color: buttonColor,
                      child: Text(CommonString.softwareUpdate,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white))),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      // padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      color: buttonColor2,
                      child: Text(CommonString.a1,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white))),
                ),
                PopupMenuItem<int>(
                  value: 3,
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      // padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      color: buttonColor2,
                      child: Text(CommonString.a2,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white))),
                ),
                PopupMenuItem<int>(
                  value: 4,
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      // padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      color: buttonColor2,
                      child: Text(CommonString.a3,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white))),
                ),
                PopupMenuItem<int>(
                  value: 6,
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      // padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      color: buttonColor2,
                      child: Text(CommonString.changeLocation,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white))),
                ),
                PopupMenuItem<int>(
                  onTap: null,
                  value: 5,
                  child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      // padding: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text("Smavio",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Text("version 1.0.0",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 11)),
                        ],
                      )),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                isUpdateAvilable == true
                    ? updateCompaign()
                    : showCustomAlertBox(
                        buttonText: 'Ok',
                        isOntapClos: true,
                        ontap: () {
                          Navigator.pop(navigatorKey.currentContext!);
                        },
                        islogOut: true,
                        context: context,
                        title: 'Compaign is already updated',
                        body: '');
              } else if (value == 1) {
                print("Settings menu is selected.");
              } else if (value == 2) {
                logout(context);
                // Utills().deleteLogincred(Utills.windows_Key);
              } else if (value == 3) {
                showCustomAlertBox(
                    // isOntapClos: true,
                    ontapClose: () {
                      Navigator.pop(context, true);
                    },
                    ontap: () => exit(0),
                    islogOut: false,
                    context: context,
                    title: 'Exit',
                    body: 'Do you Want to exit App! ');
              } else if (value == 4) {
                shutDownDevice();
              } else if (value == 6) {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
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
                                  keyboardType: TextInputType.emailAddress,

                                  decoration: InputDecoration(
                                    // focusColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    // hintStyle: bodyText2(
                                    //     context: context, color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    hintText: "Stadt",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    disabledBorder: InputBorder.none,
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
                                  keyboardType: TextInputType.emailAddress,

                                  decoration: InputDecoration(
                                    // focusColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    // hintStyle: bodyText2(
                                    //     context: context, color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    hintText: "Straße",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    disabledBorder: InputBorder.none,
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
                                  keyboardType: TextInputType.emailAddress,

                                  decoration: InputDecoration(
                                    // focusColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    // hintStyle: bodyText2(
                                    //     context: context, color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    hintText: "Hausnummer",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                  onPressed: () async {
                                    await HiveDBServices().getLoginData();
                                    if (_key.currentState!.validate()) {
                                      log('form 2 validated');
                                      //TODO: call api
                                      Map requestBody = {
                                        "city": cityController.text,
                                        "state": streetController.text,
                                        "houseno": houseNumberController.text,
                                        "deviceId": loginData.first.deviceId
                                      };

                                      await ApiCalls()
                                          .changeLocation(body: requestBody)
                                          .then((v) {
                                        if (v.success == false) {
                                          showCustomAlertBox(
                                              buttonText: 'Ok',
                                              ontap: () {
                                                Navigator.pop(navigatorKey
                                                    .currentContext!);
                                              },
                                              islogOut: true,
                                              context: context,
                                              title: 'Fehler',
                                              body: v.msg!);
                                        } else if (v.success == true) {
                                          Utills().saveLoginToLocal(
                                              state: cityController.text,
                                              street: streetController.text,
                                              houseno:
                                                  houseNumberController.text);
                                          Navigator.pop(context);

                                          // Navigator.pushReplacement(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             const WebViewWindows()));
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
              }
            }),
      ),
      body: compositeView(),
    );
  }
}
