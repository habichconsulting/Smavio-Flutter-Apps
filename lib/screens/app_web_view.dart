import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smavio/apicall/api_calls.dart';
import 'package:smavio/main.dart';
import 'package:smavio/screens/app_drawer.dart';
import 'package:smavio/utils/hive_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constant.dart';

///app web view just pass the url and app bar name
class AppWebView extends StatefulWidget {
  static String routName = "/join_user";
  // final String? url, appname, deviceId;
  // final bool? success;
  final bool isDynamicUrl;
  const AppWebView({
    Key? key,
    // required this.url,
    // required this.appname,
    this.isDynamicUrl = false,
    // this.success,
    // required this.deviceId
  }) : super(key: key);

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  bool isLoading = true;
  bool isLoadingfromApi = false;
  WebViewController? _controller;
  Timer? _timer;
  String? url;
  int currentIndex = 0;
  ConnectivityResult? _connectivityResult;
  StreamSubscription? internetconnection;
  StreamSubscription? connection;

  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    // connection = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   // whenevery connection status is changed.
    //   if (result == ConnectivityResult.none ) {
    //     isonline = false;

    //     //there is no any connection

    //     showAlert(context);
    //   } else if (result == ConnectivityResult.mobile) {
    //     //connection is mobile data network
    //     if (isonline == false) {
    //       isonline = true;
    //       Navigator.pop(navigatorKey.currentContext!);
    //     }
    //   } else if (result == ConnectivityResult.wifi) {
    //     if (isonline == false) {
    //       isonline = true;
    //       Navigator.pop(navigatorKey.currentContext!);
    //     }

    //     //connection is from wifi
    //     // Navigator.pop(navigatorKey.currentContext!);

    //   }
    // });
    // // isonline == true ? checkAssignCompaign() : null;
    checkAssignCompaign();

    super.initState();
  }

  Future<void> checkConnectivity() async {
    _connectivityResult = await Connectivity().checkConnectivity();
    if (_connectivityResult == ConnectivityResult.none) {
      // Device is offline
      showAlert(context);
    }
  }

  void showAlert(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No internet connection'),
          content: Text('Please check your internet connection and try again.'),
        );
      },
    );
  }

  checkAssignCompaign() async {
    await HiveDBServices().getLoginData();
   compaingId= await Utills().getString(Utills.campaignId);
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
       
       
        if (value.campaignId != compaingId) {
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

  @override
  void dispose() {
    currentIndex = 0;
    isUpdateAvilable = false;
    compaingId = '';
    super.dispose();
  }

  void reloadWebView() {
    _controller?.reload();
  }

  final _key = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        log('back Button Pressed');
        final shouldPop = await showWaning(context);

        return shouldPop ?? false;
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        backgroundColor: buttonColor2,
        body: SafeArea(
          child: Stack(
            children: [
              isLoadingfromApi == false
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(color: Colors.white),
                    )
                  : WebView(
                      zoomEnabled: true,
                      gestureNavigationEnabled: true,
                      key: _key,
                      onPageFinished: (finish) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      onWebViewCreated: (WebViewController controller) {
                        _controller = controller;
                        // _controller!.loadUrl(url!);
                      },
                      javascriptMode: JavascriptMode.unrestricted,
                      // navigationDelegate: (navigation) {
                      //   return navigation.url.isEmpty?_controller!.loadFile(''):navigation.url;
                      // },

                      navigationDelegate: (NavigationRequest? request) {
                        log('request url ${request!.url}');

                        if (Platform.isIOS) {
                          if (request.url.isEmpty) {
                            return NavigationDecision.prevent;
                          }
                          return NavigationDecision.navigate;
                        } else if (Platform.isAndroid) {
                          if (request.url.isNotEmpty) {
                            //

                            return NavigationDecision.prevent;
                          }
                          return NavigationDecision.navigate;
                        } else {
                          return NavigationDecision.navigate;
                        }
                      },

                      initialUrl: url,
                    ),
              // initialUrl:
              //     '${loginData[0].siteUrl}/campaign/${compaignAssignModal.campaignId}/preview?deviceid=${loginData.last.deviceId}'),
             /* Positioned(
                top: MediaQuery.of(context).size.height / 3,
                left: -55,
                child: Lottie.asset('assets/lf20_6UVhfF.json',
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.3),
              ),*/
              isLoading
                  ? isLoadingfromApi == false
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Lottie.asset(
                            'assets/lf20_6UVhfF.json',
                            width: MediaQuery.of(context).size.width * 0.15,
                            // height: MediaQuery.of(context).size.height * 0.3),
                          ))
                      : const Center(
                          child: CircularProgressIndicator(),
                        )
                  : Stack(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> showWaning(BuildContext context) async {
    return showCustomAlertBox(
        // isOntapClos: true,
        ontapClose: () {
          Navigator.pop(context, true);
        },
        ontap: () => exit(0),
        islogOut: false,
        context: context,
        title: 'Exit',
        body: 'Do you Want to exit App! ');
  }
}
