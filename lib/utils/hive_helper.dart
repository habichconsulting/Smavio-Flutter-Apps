import 'package:hive_flutter/hive_flutter.dart';
import 'package:smavio/utils/local_storage_modal.dart';

import '../constant.dart';

List<LoginData> loginData = [];

class HiveDBServices {
  static const String loginBoxName = 'Login';

  //open box of login form
  Future<Box> loginBox() async {
    var box = await Hive.openBox<LoginData>(loginBoxName);
    return box;
  }

  ///add login data to hive box
  Future<bool> addLogin(LoginData loginData) async {
    var box = await loginBox();
    bool isSaved = false;
    int inserted = await box.add(loginData);
    isSaved = inserted == 1 ? true : false;
    return isSaved;
  }

  ///get login data from hive box
  Future<List<LoginData>> getLoginData() async {
    var box = await loginBox();
    loginData = box.values.map<LoginData>((e) => e).toList();
    compaingId = loginData[0].campaignId;
    // log(loginData.id);
    return loginData;
  }

  ///clear delete login
  Future<Box> deleteLogin() async {
    final box = await loginBox();
    // await box.delete(key);
    await box.clear();
    return box;
  }
}
