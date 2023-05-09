import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';

const buttonColor = Color(0XFF058ed1);
const buttonColor2 = Color.fromARGB(255, 82, 85, 87);
const primary = Color.fromARGB(255, 28, 30, 30);

////
dynamic compaingId = '';
bool isUpdateAvilable = false;
late bool isonline = true;

///hide keyboard
void hideKeyboard(context) => FocusScope.of(context).requestFocus(FocusNode());

showDilog(String error, context, {required VoidCallback ontap}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        content: Text(error),
        actions: [ElevatedButton(onPressed: ontap, child: const Text('OK'))],
      );
    },
  );
}

advancedStatusCheck(NewVersion newVersion, context) async {
  try {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      status.canUpdate == true
          ? newVersion.showUpdateDialog(
              context: context,
              allowDismissal: false,
              versionStatus: status,
              dialogTitle: 'Exide Samrat',
              dialogText:
                  'Hello, the latest version of app is released. Click here to update the app.',
            )
          : null;
    }
  } catch (e) {
    debugPrint('errpr $e');
  }
}

///Media Query screen height
double scHeight(context) {
  return MediaQuery.of(context).size.height;
}

///media Query screen width
double scWidth(context) {
  return MediaQuery.of(context).size.width;
}

///font size 16 and weight 500
TextStyle bodyText1({Color color = Colors.black, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  // log('${scHeight(context)}');
  double multiplier = 2.2;
  return GoogleFonts.lato(
      // fontSize: size * scHeight(context) * 0.1,
      fontSize: multiplier * unitHeightValue,
      // fontSize: 16,
      color: color,
      fontWeight: FontWeight.w500);
}

///font size 14 and weight 500
TextStyle bodyText2({Color color = Colors.black, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  // log('${scHeight(context)}');
  double multiplier = 1.85;
  return GoogleFonts.lato(
      fontSize: multiplier * unitHeightValue,
      // fontSize: 14,
      color: color,
      fontWeight: FontWeight.w500);
}

///custom Alert dilogue
showCustomAlertBox(
    {required BuildContext context,
    required String title,
    VoidCallback? ontap,
    String buttonText = 'Ok',
    VoidCallback? ontapClose,
    bool isOntapClos = false,
    bool isbarrierDismiss = true,

    ///islogout true to show yes button
    bool islogOut = false,
    required String body}) {
  return showDialog(
      barrierDismissible: isbarrierDismiss,
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: primary,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: Colors.white,
              // borderRadius: BorderRadius.only(
              //     bottomLeft: Radius.circular(10),
              //     bottomRight: Radius.circular(10))
            ),
            //height: scHeight(context) * 0.68,
            width: scWidth(context) * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '$body \n',
                  // 'Gentle reminder that you fee for this month is due. Kindly clear it to continue with the classes.',
                  // style: bodyTTexext2(context: context),
                ),
                const SizedBox(
                  height: 0,
                ),
                islogOut == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  backgroundColor: primary),
                              onPressed: ontap,
                              child: Text(
                                buttonText,
                                style: TextStyle(color: Colors.white),
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  backgroundColor: primary),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'No',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      )
                    : Center(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                backgroundColor: primary),
                            onPressed: ontap,
                            child: Text(
                              buttonText,
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'smavio',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'version 1.0.0',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      });
}

//share preferrence

class Utills {
 static String windows_Key = 'location';
 static String state = 'state';
 static String street = 'street';
 static String houseno = 'houseno';
 static String campaignId = 'houseno';



  Future saveString(String key, String data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, data);
  }

  Future getString(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  Future deleteLogincred(String key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(key);
    log('logout');
  }
  saveLoginToLocal(

    
      {required String state,
      required String street,
      required String houseno}) async {
    // await HiveDBServices().addLogin(LoginData(
    //     token: v.token.toString(),
    //     deviceId: deviceId!,
    //     siteUrl: v.siteUrl.toString(),
    //     packageName: packageName ?? '',
    //     appVersion: appVersion ?? '',
    //     id: loginModal.id.toString()));
    await Utills().saveString(Utills.state, state);
    await Utills().saveString(Utills.street, street);
    await Utills().saveString(Utills.houseno, houseno);
  }
}
