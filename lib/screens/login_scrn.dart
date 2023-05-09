import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:smavio/constant.dart';
import 'package:smavio/main.dart';
import 'package:smavio/screens/forgot_pass_scrn.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:smavio/screens/splash_scrn.dart';
import 'package:smavio/screens/webview_windows.dart';
import 'dart:io' show Platform, exit;

import '../apicall/api_calls.dart';
import '../utils/hive_helper.dart';
import '../utils/local_storage_modal.dart';

class LoginScrn extends StatefulWidget {
  const LoginScrn({super.key});

  @override
  State<LoginScrn> createState() => _LoginScrnState();
}

class _LoginScrnState extends State<LoginScrn> {
  final _emailcontroller = TextEditingController();
  final _passController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController houseNumberController = TextEditingController();

  //******** Device and app info ********//
  String? osVersion;
  String? platform;
  String? operatingSystem;
  String? appVersion;
  String? deviceId;
  String? manufacturer;
  String? model;
  bool? isPhysicalDevice;
  //******** Location ********//
  String? _currentAddress;
  String? locality;
  String? subLocality;
  Position? _currentPosition;
  String? packageName;
  String? _administrativeArea;
  late bool serviceEnabled;

  final GlobalKey<FormState> _key = GlobalKey();
  final GlobalKey<FormState> _key2 = GlobalKey();
  bool isLoading = false;
  bool isApiLoading = false;
  String? windowsLocation;
  @override
  void initState() {
    super.initState();

    getAllMethods().then((value) {
      setState(() {
        isApiLoading = true;
      });
    });
  }

  Future getAllMethods() async {
    await ApiCalls().getCities();
    await deviceInfo();
    // if (Platform.isAndroid || Platform.isIOS) {
    //   await _handleLocationPermission();
    //   await _getCurrentPosition();
    // }
    //  else {
      // windowsLocationFromDropDown();
      savedLocation();
    // }
  }

  windowsLocationFromDropDown() async {
    windowsLocation = await Utills().getString(Utills.windows_Key);
    if (selectedItems == null) {
      selectedItems = windowsLocation;
      var a = cities.where((element) => element.name == selectedItems).toList();
      log(a[0].state.toString());
      subLocality = "${a[0].state} ${a[0].district}";
      locality = selectedItems;
    } else {
      var a = cities.where((element) => element.name == selectedItems).toList();
      log(a[0].state.toString());
      subLocality = "${a[0].state} ${a[0].district}";
      locality = selectedItems;
    }
  }

 Future savedLocation() async {
    windowsLocation = await Utills().getString(Utills.state);
    //  String street = await Utills().getLocationWindows(Utills.street);
    // String houseno =await Utills().getLocationWindows(Utills.houseno);
  }

  deviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    late AndroidDeviceInfo androidInfo;
    late IosDeviceInfo iosDeviceInfo;
    late WindowsDeviceInfo windowsDeviceInfo;
    late MacOsDeviceInfo macOsDeviceInfo;
    // androidInfo = await deviceInfo.androidInfo;
    // iosDeviceInfo = await deviceInfo.iosInfo;
    // macOsDeviceInfo = await deviceInfo.macOsInfo;
    // windowsDeviceInfo = await deviceInfo.windowsInfo;

    packageName = packageInfo.packageName;
    appVersion = packageInfo.version;
    osVersion = Platform.operatingSystemVersion;
    operatingSystem = Platform.operatingSystem;
    log('$platform ,$osVersion,$operatingSystem');
    log("$deviceId");
    if (Platform.isAndroid) {
      //f0r validati0n
      selectedItems = '';
      androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      manufacturer = androidInfo.manufacturer;
      model = androidInfo.model;
      isPhysicalDevice = androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      //f0r validati0n
      selectedItems = '';
      iosDeviceInfo = await deviceInfo.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor;
      manufacturer = iosDeviceInfo.name;
      model = iosDeviceInfo.model;
      isPhysicalDevice = iosDeviceInfo.isPhysicalDevice;
    } else if (Platform.isWindows) {
      windowsDeviceInfo = await deviceInfo.windowsInfo;
      deviceId = windowsDeviceInfo.deviceId;
      manufacturer = windowsDeviceInfo.productName;
      model = windowsDeviceInfo.computerName;
      isPhysicalDevice = true;
    } else if (Platform.isMacOS) {
      macOsDeviceInfo = await deviceInfo.macOsInfo;
      deviceId = macOsDeviceInfo.systemGUID;
      manufacturer = macOsDeviceInfo.computerName;
      model = macOsDeviceInfo.model;
      isPhysicalDevice = true;
    }
    // } else if (Platform.isMacOS) {
    //   deviceId = macOsDeviceInfo.systemGUID;
    //   manufacturer = macOsDeviceInfo.computerName;
    //   model = macOsDeviceInfo.model;
    //   isPhysicalDevice = true;
    // } else if (Platform.isWindows) {
    //   deviceId = windowsDeviceInfo.deviceId;
    //   manufacturer = windowsDeviceInfo.computerName;
    //   model = windowsDeviceInfo.productName;
    //   isPhysicalDevice = true;
    // }
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showCustomAlertBox(
          ontap: () {
            Navigator.pop(context);
          },
          islogOut: true,
          context: context,
          title: 'Enable Location',
          body: 'Location services are disabled. Please enable the services');

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        if (Platform.isAndroid || Platform.isIOS) {
          _currentAddress =
              '${place.street}, ${place.subLocality},${place.locality} ${place.subAdministrativeArea}, ${place.postalCode}';
          locality = place.locality;
          subLocality = place.subAdministrativeArea;
          _administrativeArea = place.administrativeArea;
        }

        log(place.toString());
        
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passController.dispose();
    super.dispose();
  }

  String? selectedItems;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: isApiLoading == false
              ? Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Center(
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
                            height: 15,
                          ),
                          const Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Form(
                            key: _key,
                            child: Column(
                              children: [
                                TextFormField(
                                  // style: const TextStyle(color: Colors.white),
                                  controller: _emailcontroller,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter email';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    // focusColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    // hintStyle: bodyText1(
                                    //   context: context,
                                    // ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    hintText: "E-Mail-Adresse",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    disabledBorder: InputBorder.none,
                                  ),
                                  // onChanged: (value) => username = value,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter passwort';
                                    }
                                    return null;
                                  },
                                  // style: TextStyle(color: Colors.white),
                                  controller: _passController,
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    // focusColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.only(left: 20),
                                    // hintStyle: bodyText2(
                                    //     context: context, color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    hintText: "Passwort",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                                //drop down to get location for windows and mac os
                                /* Platform.isWindows || Platform.isMacOS
                                  ? Container(
                                      margin: EdgeInsets.only(top: 20),
                                      // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                      child: DropdownSearch<String>(
                                        dropDownButton: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                        ),
                                        validator: (value) {
                                          if (selectedItems == null) {
                                            return 'Please select city';
                                          } else {
                                            return null;
                                          }
                                        },
                                        popupBackgroundColor: buttonColor2,
                                        searchBoxDecoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white),
                                          ),
                                        ),
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                                hintStyle: bodyText2(
                                                    context: context,
                                                    color: Colors.white38),
                                                contentPadding:
                                                    EdgeInsets.only(left: 20),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                labelStyle: bodyText2(
                                                    context: context,
                                                    color: Colors.white)),
                                        //mode of dropdown
                                        mode: Mode.DIALOG,
                  
                                        //to show search box
                                        showSearchBox: true,
                                        showSelectedItem: true,
                                        //list of dropdown items
                                        items: city,
                                        // label: "City",
                                        hint:
                                            'Bitte wählen Sie Ihre Stadt aus',
                                        onChanged: (value) {
                                          selectedItems = value!;
                                        },
                                        //show selected item
                                        selectedItem: selectedItems,
                                      ),
                                    )
                                  : SizedBox()*/
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 15),
                                        backgroundColor: buttonColor,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero)),
                                    onPressed: () async {
                                      hideKeyboard(context);

                                      if (_key.currentState!.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        //request body for android and ios
                                        Map requestBody = {};
                                       /* Platform.isAndroid || Platform.isIOS
                                            ? requestBody = {
                                                // "email": "gajendrashaktawat13@gmail.com",
                                                "email": _emailcontroller.text,
                                                // "password": "qweds1",
                                                "password":
                                                    _passController.text,
                                                "device_detail": {
                                                  "name": manufacturer,
                                                  "model": model,
                                                  "platform": operatingSystem,
                                                  "operatingSystem":
                                                      operatingSystem,
                                                  "osVersion": osVersion,
                                                  "manufacturer": manufacturer,
                                                  "isVirtual":
                                                      isPhysicalDevice == true
                                                          ? false
                                                          : true,
                                                  "webViewVersion": ""
                                                },
                                                "appversion": appVersion,
                                                "deviceId": deviceId,
                                                // "deviceId": "0097ef7e-efab-4546-9f5c-2a4e756b3f34",
                                                "device_type": "app",
                                                "locality": locality,
                                                "subAdministrativeArea": ''
                                                // "subAdministrativeArea":
                                                //     subLocality.isEmpty || subLocality==null
                                                //         ? _administrativeArea??''
                                                //         : subLocality??''
                                              }
                                            //request body for windows
                                            : */
                                            requestBody = {
                                                // "email": "gajendrashaktawat13@gmail.com",
                                                "email": _emailcontroller.text,
                                                // "password": "qweds1",
                                                "password":
                                                    _passController.text,
                                                "device_detail": {
                                                  "name": manufacturer,
                                                  "model": model,
                                                  "platform": operatingSystem,
                                                  "operatingSystem":
                                                      operatingSystem,
                                                  "osVersion": osVersion,
                                                  "manufacturer": manufacturer,
                                                  "isVirtual":
                                                      isPhysicalDevice == true
                                                          ? false
                                                          : true,
                                                  "webViewVersion": ""
                                                },
                                                "appversion": appVersion,
                                                "deviceId": deviceId,
                                                // "deviceId": "0097ef7e-efab-4546-9f5c-2a4e756b3f34",
                                                "device_type": "app",
                                                "locality": locality,
                                                "subAdministrativeArea":
                                                    subLocality
                                                // "subAdministrativeArea":
                                                //     subLocality.isEmpty || subLocality==null
                                                //         ? _administrativeArea??''
                                                //         : subLocality??''
                                              };
                                        await ApiCalls()
                                            .login(body: requestBody)
                                            .then(
                                          (v) {
                                            if (v!.success == false) {
                                              showCustomAlertBox(
                                                  buttonText: 'Ok',
                                                  ontap: () {
                                                    Navigator.pop(navigatorKey
                                                        .currentContext!);
                                                  },
                                                  islogOut: true,
                                                  context: context,
                                                  title: 'Fehler',
                                                  body:
                                                      'E-Mail-Adresse und/older Passwort sind leider falsch Bitte uberprufen sie lhre Eingabe.');
                                            } else if (v.success == true) {
                                              // Platform.isAndroid ||
                                              //         Platform.isIOS
                                              //     ?
                                              HiveDBServices().addLogin(
                                                      LoginData(
                                                        campaignId: v.campaignId,
                                                          token: v.token
                                                              .toString(),
                                                          deviceId: deviceId!,
                                                          siteUrl: v.siteUrl
                                                              .toString(),
                                                          packageName:
                                                              packageName,
                                                          appVersion:
                                                              appVersion,
                                                          id: loginModal.id
                                                              .toString()));
                                                              Utills().saveString(Utills.campaignId,v.campaignId!);
                                                  // : null;
                                                  

                                              // Platform.isAndroid ||
                                              //         Platform.isIOS
                                              //     ? Navigator.push(
                                              //         context,
                                              //         MaterialPageRoute(
                                              //             builder: (context) =>
                                              //                 const SplashScrn()))
                                              //     : null;
                                              //drop down location
                                              /*   Platform.isWindows
                                                ? showDialog(
                                                    // barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        // backgroundColor: Colors.black,
                                                        // contentTextStyle: TextStyle(color: Colors.black),
                                                        actions: [
                                                          Center(
                                                            child:
                                                                ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                15,
                                                                            horizontal:
                                                                                50)),
                                                                    onPressed:
                                                                        () async {
                                                                      // Navigator.pop(
                                                                      //     context);
                            
                                                                      await ApiCalls()
                                                                          .login(
                                                                              body: requestBody)
                                                                          .then(
                                                                        (v) {
                                                                          if (v!.success ==
                                                                              false) {
                                                                            showCustomAlertBox(
                                                                                buttonText: 'Ok',
                                                                                ontap: () {
                                                                                  Navigator.pop(navigatorKey.currentContext!);
                                                                                },
                                                                                islogOut: true,
                                                                                context: context,
                                                                                title: 'Fehler',
                                                                                body: 'E-Mail-Adresse und/older Passwort sind leider falsch Bitte uberprufen sie lhre Eingabe.');
                                                                          } else {
                                                                            saveLoginToLocal(v: v);
                                                                            Navigator.pushReplacement(context,
                                                                                MaterialPageRoute(builder: (context) => const WebViewWindows()));
                                                                          }
                                                                        },
                                                                      );
                                                                    },
                                                                    child: Text(
                                                                        'OK')),
                                                          ),
                                                        ],
                                                        content: Container(
                                                          width:
                                                              scWidth(context) /
                                                                  2.5,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 20),
                                                          // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                                          child: DropdownSearch<
                                                                  String>(
                                                              dropDownButton:
                                                                  Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                // color: Colors.b,
                                                              ),
                                                              validator:
                                                                  (value) {
                                                                if (selectedItems ==
                                                                    null) {
                                                                  return 'Please select city';
                                                                } else {
                                                                  return null;
                                                                }
                                                              },
                                                              // popupBackgroundColor:
                                                              //     buttonColor2,
                                                              searchBoxDecoration:
                                                                  InputDecoration(
                                                                hintStyle:
                                                                    bodyText2(
                                                                  context:
                                                                      context,
                                                                ),
                                                                labelStyle:
                                                                    bodyText2(
                                                                  context:
                                                                      context,
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                              ),
                                                              dropdownSearchDecoration:
                                                                  InputDecoration(
                                                                      hintStyle:
                                                                          bodyText2(
                                                                        context:
                                                                            context,
                                                                      ),
                                                                      contentPadding: EdgeInsets.only(
                                                                          left:
                                                                              20),
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(),
                                                                      ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(),
                                                                      ),
                                                                      labelStyle: bodyText2(
                                                                          context:
                                                                              context,
                                                                          color: Colors
                                                                              .white)),
                                                              //mode of dropdown
                                                              mode: Mode.DIALOG,
                            
                                                              //to show search box
                                                              showSearchBox:
                                                                  true,
                                                              showSelectedItem:
                                                                  true,
                                                              //list of dropdown items
                                                              items: city,
                            
                                                              // label: "City",
                                                              showClearButton:
                                                                  true,
                                                              hint:
                                                                  'Bitte wählen Sie Ihre Stadt aus',
                                                              onChanged:
                                                                  (value) {
                                                                selectedItems =
                                                                    value!;
                                                              },
                                                              //show selected item
                                                              selectedItem:
                                                                  windowsLocation ==
                                                                          null
                                                                      ? selectedItems
                                                                      : windowsLocation),
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : null;
                                                */

                                              // locaton in textfield
                                              // windowsLocation == null
                                              //     ?
                                                   showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        25),
                                                            child: Form(
                                                              key: _key2,
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Text(
                                                                        'Standort'),
                                                                    SizedBox(
                                                                      height: 20,
                                                                    ),
                                                                    Flexible(
                                                                      child:
                                                                          TextFormField(
                                                                        validator:
                                                                            (value) {
                                                                          if (value!
                                                                              .isEmpty) {
                                                                            return 'Bitte Stadt eingeben';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        // style: TextStyle(color: Colors.white),
                                                                        controller:
                                                                            cityController,
                                                                        keyboardType:
                                                                            TextInputType
                                                                                .emailAddress,
                                                              
                                                                        decoration:
                                                                            InputDecoration(
                                                                          // focusColor: Colors.white,
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          contentPadding:
                                                                              EdgeInsets.only(left: 20),
                                                                          // hintStyle: bodyText2(
                                                                          //     context: context, color: Colors.black),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                          hintText:
                                                                              "Stadt",
                                                                          focusedBorder:
                                                                              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                          disabledBorder:
                                                                              InputBorder.none,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            20),
                                                                    Flexible(
                                                                      child:
                                                                          TextFormField(
                                                                        validator:
                                                                            (value) {
                                                                          if (value!
                                                                              .isEmpty) {
                                                                            return 'Bitte Straße eingeben';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        // style: TextStyle(color: Colors.white),
                                                                        controller:
                                                                            streetController,
                                                                        keyboardType:
                                                                            TextInputType
                                                                                .emailAddress,
                                                              
                                                                        decoration:
                                                                            InputDecoration(
                                                                          // focusColor: Colors.white,
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          contentPadding:
                                                                              EdgeInsets.only(left: 20),
                                                                          // hintStyle: bodyText2(
                                                                          //     context: context, color: Colors.black),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                          hintText:
                                                                              "Straße",
                                                                          focusedBorder:
                                                                              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                          disabledBorder:
                                                                              InputBorder.none,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            20),
                                                                    Flexible(
                                                                      child:
                                                                          TextFormField(
                                                                        validator:
                                                                            (value) {
                                                                          if (value!
                                                                              .isEmpty) {
                                                                            return 'Bitte geben Sie die Hausnummer ein';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        // style: TextStyle(color: Colors.white),
                                                                        controller:
                                                                            houseNumberController,
                                                                        keyboardType:
                                                                            TextInputType
                                                                                .emailAddress,
                                                              
                                                                        decoration:
                                                                            InputDecoration(
                                                                          // focusColor: Colors.white,
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          contentPadding:
                                                                              EdgeInsets.only(left: 20),
                                                                          // hintStyle: bodyText2(
                                                                          //     context: context, color: Colors.black),
                                                                          enabledBorder:
                                                                              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                          hintText:
                                                                              "Hausnummer",
                                                                          focusedBorder:
                                                                              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                                                                          disabledBorder:
                                                                              InputBorder.none,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            20),
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          if (_key2
                                                                              .currentState!
                                                                              .validate()) {
                                                                            log('form 2 validated');
                                                                            //TODO: call api
                                                                            requestBody =
                                                                                {
                                                                              "city":
                                                                                  cityController.text,
                                                                              "state":
                                                                                  streetController.text,
                                                                              "houseno":
                                                                                  houseNumberController.text,
                                                                              "deviceId":
                                                                                  deviceId
                                                                            };
                                                              
                                                                            await ApiCalls()
                                                                                .changeLocation(body: requestBody)
                                                                                .then((v) {
                                                                              if (v.success ==
                                                                                  false) {
                                                                                showCustomAlertBox(
                                                                                    buttonText: 'Ok',
                                                                                    ontap: () {
                                                                                      Navigator.pop(navigatorKey.currentContext!);
                                                                                    },
                                                                                    islogOut: true,
                                                                                    context: context,
                                                                                    title: 'Fehler',
                                                                                    body: 'E-Mail-Adresse und/older Passwort sind leider falsch Bitte uberprufen sie lhre Eingabe.');
                                                                              } else if (v.success ==
                                                                                  true) {
                                                                               Utills().saveLoginToLocal(state: cityController.text, street: streetController.text, houseno: houseNumberController.text);
                                                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Platform.isWindows? WebViewWindows():SplashScrn()));
                                                                              }
                                                                            });
                                                                          }
                                                                        },
                                                                        child: isLoading
                                                                            ? const SizedBox(
                                                                                height: 20,
                                                                                width: 20,
                                                                                child: CircularProgressIndicator(
                                                                                  color: Colors.white,
                                                                                  strokeWidth: 2,
                                                                                ))
                                                                            : Text('Absenden'))
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  // : Navigator.pushReplacement(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (_) => Platform
                                                  //                 .isAndroid
                                                  //             ? SplashScrn()
                                                  //             : WebViewWindows()));
                                            }
                                          },
                                        );
                                        //show popup for windows and mac

                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    },
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ))
                                        : const Text('Login')),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: isLoading
                                            ? buttonColor2
                                            : buttonColor2.withOpacity(0.5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 15),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero)),
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            showCustomAlertBox(
                                                isOntapClos: true,
                                                ontapClose: () {
                                                  Navigator.pop(context, true);
                                                },
                                                ontap: () => exit(0),
                                                islogOut: false,
                                                context: context,
                                                title: 'Exit',
                                                body:
                                                    'Do you Want to exit App! ');
                                          },
                                    child: Text(
                                      'Beenden',
                                      style: TextStyle(
                                          color: isLoading
                                              ? Colors.white54
                                              : Colors.white),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Keine Zugandgsdaten?',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgotPassScrn()));
                                  },
                                  child: const Text(
                                    'Anforden',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Smavio',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Version 1.0.0',
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }

  
}
