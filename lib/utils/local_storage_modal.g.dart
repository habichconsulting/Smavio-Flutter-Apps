// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_storage_modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginDataAdapter extends TypeAdapter<LoginData> {
  @override
  final int typeId = 1;

  @override
  LoginData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginData(
      token: fields[0] as String,
      siteUrl: fields[1] as String,
      id: fields[2] as String,
      deviceId: fields[3] as String,
      packageName: fields[4] as String?,
      appVersion: fields[5] as String?,
      campaignId: fields[6] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, LoginData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.siteUrl)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.deviceId)
      ..writeByte(4)
      ..write(obj.packageName)
      ..writeByte(5)
      ..write(obj.appVersion)
      ..writeByte(6)
      ..write(obj.campaignId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
