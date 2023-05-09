import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inline_webview_macos/example/flutter_inline_webview_macos.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/flutter_inline_webview_macos.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/flutter_inline_webview_macos_controller.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/types.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smavio/constant.dart';
import 'package:smavio/screens/app_drawer.dart';

import '../apicall/api_calls.dart';
import '../common_string.dart';
import '../main.dart';
import '../utils/hive_helper.dart';

class MacOsWebview extends StatefulWidget {
  const MacOsWebview({super.key});

  @override
  State<MacOsWebview> createState() => _MacOsWebviewState();
}

class _MacOsWebviewState extends State<MacOsWebview> {
  String _platformVersion = 'Unknown';
  Timer? _timer;
  bool isLoadingfromApi = false;
  String? url;
  int currentIndex = 0;

  checkAssignCompaign() async {
    await HiveDBServices().getLoginData();
    final prefs = await SharedPreferences.getInstance();

    await ApiCalls().getAssignCompaign(body: {
      "device_uuid": loginData.last.deviceId,
      "device_type": "app"
    }).whenComplete(() {
      log(currentIndex.toString());

      if (compaignAssignModal.success == false) {
        currentIndex == 0
            ? showCustomAlertBox(
                buttonText: 'Ok',
                isOntapClos: true,
                ontap: () {
                  Navigator.pop(navigatorKey.currentContext!);
                },
                islogOut: true,
                context: context,
                title: compaignAssignModal.error!,
                body: '')
            : log('dilog should not show');
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text(compaignAssignModal.error!)));
      } else if (compaignAssignModal.success == true) {
        prefs.setString('compaignId', compaignAssignModal.campaignId!);
        //TODO:
        if (compaignAssignModal.campaignId != compaingId &&
            compaingId.toString().isNotEmpty) {
          isUpdateAvilable = compaignAssignModal.updateAvailable!;
          compaingId = compaignAssignModal.campaignId;
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
          compaingId = compaignAssignModal.campaignId;
        }

        // compaingId = prefs.getString('compaignId');

        log('${loginData[0].siteUrl}/campaign/${compaignAssignModal.campaignId}/preview?deviceid=${loginData[0].deviceId}');

        setState(() {
          isLoadingfromApi = true;

          url =
              '${loginData[0].siteUrl}/campaign/${compaignAssignModal.campaignId}/preview?deviceid=${loginData.last.deviceId}';
        });

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => AppWebView(
        //               appname: 'Smavio',
        //               deviceId: loginData.last.deviceId,
        //               url:
        //                   'https://sandbox.smavio.de/campaign/preview?deviceid=${loginData.last.deviceId}',
        //               success: compaignAssignModal.success,
        //             )));

      }
      currentIndex++;
    });
    Timer(const Duration(seconds: 8), checkAssignCompaign);
  }

  @override
  void initState() {
    checkAssignCompaign();

    super.initState();
  }

  @override
  void dispose() {
    currentIndex = 0;
    isUpdateAvilable = false;
    compaingId = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){
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
              
      }),
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 50,
          ),
          Spacer(),
          PopupMenuButton(
              color: buttonColor2,
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text(CommonString.campaignUpdate),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text(CommonString.softwareUpdate),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text(CommonString.a1),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Text(CommonString.a2),
                  ),
                  PopupMenuItem<int>(
                    value: 4,
                    child: Text(CommonString.a3),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  logout(context);

                  /*isUpdateAvilable == true
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
              */
                } else if (value == 1) {
                  print("Settings menu is selected.");
                } else if (value == 2) {
                  logout(context);
                } else if (value == 3) {
                } else if (value == 4) {
                  //shutDownDevice();
                }
              }),
        ],
      ),
      body: WeBCheck(url: url,),
    );
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
                MaterialPageRoute(builder: (context) => MacOsWebview()));
          });
        },
        islogOut: true,
        context: navigatorKey.currentContext!,
        title: 'Update',
        body: 'update completed');
  }

  logout(context) async {
    // await HiveDBServices().deleteLogin();
    await ApiCalls().getLogout(context);
    //
    // navigate();
  }
}

class WeBCheck extends StatefulWidget {
   final String? url;
  const WeBCheck({super.key, required this.url});

  @override
  State<WeBCheck> createState() => _WeBCheckState();
}

class _WeBCheckState extends State<WeBCheck> {
  final _flutterWebviewMacosPlugin = FlutterInlineWebviewMacos();
  InlineWebViewMacOsController? _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
       height: scHeight(context)*0.5,
        width: scWidth(context),
      child: InlineWebViewMacOs(
        height: scHeight(context)*0.5,
        width: scWidth(context)*0.5,
        onWebViewCreated: (controller) {
          _controller = controller;
          controller.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse(widget.url ??
                      'https://sandbox.smavio.de/campaign/12/preview?deviceid=FA73635E-88E2-511A-893D-2E3A7CEEAE1A')));
        },
      ),
    );
  }
}
