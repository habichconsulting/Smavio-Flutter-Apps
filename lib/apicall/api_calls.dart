import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smavio/model/change_location.dart';
import 'package:smavio/model/comapign_update_modal.dart';
import 'package:smavio/model/compaign_assign_modal.dart';
import 'package:smavio/model/login_modal.dart';
import 'package:http/http.dart' as http;
import 'package:smavio/model/logut_modal.dart';

import '../model/cities_modal.dart';
import '../model/forgot_pass_modal.dart';
import '../screens/login_scrn.dart';
import '../utils/hive_helper.dart';

late LoginModal loginModal;
late CompaignAssignModal compaignAssignModal;
late CompaignUpdateModal compaignUpdateModal;
late LogoutModal logoutModal;
StreamController<CompaignAssignModal>? _streamController;
List<Cities> cities = [];
late CitiesModal citiesModal;
List<String> city = [];
late ForgotPassModal forgotPassModal;
late ChangeLocation changeLocationModal;

class ApiCalls {
//  static String urlHeader =
//       "https://staging.appmate.in/Smavio-laravel-admin-dashboard";
  static String urlHeader = "https://api.smavio.de/smavio-backend";

  ///login api
  Future<LoginModal?> login({required Map body}) async {
    String url = '$urlHeader/api/appLogin';
    log('Request ***** $body ${jsonEncode(body)}');

    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        log('json ${json.toString()}');
        loginModal = LoginModal.fromJson(json);
        return loginModal;
      } else {
        throw '****** Response Code ${response.statusCode}';
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Compaign update
  Future<CompaignUpdateModal?> updateCampaign({required Map body}) async {
    String url = '$urlHeader/api/user/updateCampaign';
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer ${loginData.first.token}'
          },
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        log('json ${json.toString()}');
        compaignUpdateModal = CompaignUpdateModal.fromJson(json);
        return compaignUpdateModal;
      } else {
        throw '****** Response Code ${response.statusCode}';
      }
    } catch (e) {
      rethrow;
    }
  }

  ///get cities
  Future<List<Cities>> getCities() async {
    String url = '$urlHeader/api/cities';
    try {
      var response = await http.get(
        Uri.parse(url),
      );
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        // log('json ${response.body.toString()}');
        citiesModal = CitiesModal.fromJson(json);
        cities = citiesModal.cities!.toList();
        city = cities.map((e) => e.name!).toList();
        return cities;
      } else {
        throw '****** Response Code ${response.statusCode}';
      }
    } catch (e) {
      rethrow;
    }
  }

  ///Compaign update
  Future<CompaignAssignModal> getAssignCompaign({required Map body}) async {
    String url = '$urlHeader/api/user/getCampaign';
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer ${loginData.first.token}'
          },
          body: jsonEncode(body));
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        log('json ${json.toString()}');
        compaignAssignModal = CompaignAssignModal.fromJson(json);
        // _streamController!.sink.add(compaignAssignModal);
        return compaignAssignModal;
      } else {
        // _streamController!.sink.addError(response.statusCode);
      }
      throw '****** Response Code ${response.statusCode}';
    } catch (e) {
      rethrow;
    }
  }

  ///logout
  Future<LogoutModal?> getLogout(context) async {
    String url = '$urlHeader/api/logout';
    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${loginData.first.token}'
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        log('json ${json.toString()}');
        logoutModal = LogoutModal.fromJson(json);
        await HiveDBServices().deleteLogin();
        navigate(context);
        return logoutModal;
      } else {
        await HiveDBServices().deleteLogin();
        navigate(context);
        throw '****** Response Code ${response.statusCode}';
      }
    } catch (e) {
      await HiveDBServices().deleteLogin();
      navigate(context);
      rethrow;
    }
  }

  navigate(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScrn()),
        (route) => false);
  }

  ///forgot password api
  Future<ForgotPassModal?> forgotPassword({required Map body}) async {
    String url = '$urlHeader/api/forget-password';
    log('Request URL And Body *****  $url$body');
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            // HttpHeaders.authorizationHeader: 'Bearer ${loginData.last.token}'
          },
          body: jsonEncode(body));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        log('json ${json.toString()}');
        forgotPassModal = ForgotPassModal.fromJson(json);
        return forgotPassModal;
      } else {
        throw '****** Response Code ${response.statusCode}';
      }
    } catch (e) {
      rethrow;
    }
  }

  ///reset password api
  Future<ForgotPassModal?> resetPassword({required Map body}) async {
    String url = '$urlHeader/api/reset-password';
    log('Request URL And Body *****  $url$body');
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            // HttpHeaders.authorizationHeader: 'Bearer ${loginData.last.token}'
          },
          body: jsonEncode(body));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        log('json ${json.toString()}');
        forgotPassModal = ForgotPassModal.fromJson(json);
        return forgotPassModal;
      } else {
        throw '****** Response Code ${response.statusCode}';
      }
    } catch (e) {
      rethrow;
    }
  }

  ///change location
  Future<ChangeLocation> changeLocation({required Map body}) async {
    await HiveDBServices().getLoginData();
    String url = '$urlHeader/api/change-location';
    log('Request URL And Body *****  $url${jsonEncode(body)}');
    try {
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer ${loginData.first.token}'
          },
          body: jsonEncode(body));
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        log('json ${json.toString()}');
        changeLocationModal = ChangeLocation.fromJson(json);
        return changeLocationModal;
      } else {
        throw '****** Response Code ${response.statusCode}';
      }
    } catch (e) {
      rethrow;
    }
  }
}
