// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_flutter/adapters.dart';

part 'local_storage_modal.g.dart';

@HiveType(typeId: 1)
class LoginData {
  @HiveField(0)
  String token;
  @HiveField(1)
  String siteUrl;
  @HiveField(2)
  String id;
  @HiveField(3)
  String deviceId;
  @HiveField(4)
  String? packageName;
  @HiveField(5)
  String? appVersion;
  @HiveField(6)
  dynamic campaignId;
  LoginData(
      {required this.token,
      required this.siteUrl,
      required this.id,
      this.deviceId = '',
      required this.packageName,
      required this.appVersion,required this.campaignId});
}
