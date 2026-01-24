// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final typeId = 3;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      diaryCreationHour: fields[0] == null ? 23 : (fields[0] as num).toInt(),
      diaryLength: fields[1] == null ? 1 : (fields[1] as num).toInt(),
      notificationEnabled: fields[2] == null ? true : fields[2] as bool,
      chatReminderEnabled: fields[3] == null ? false : fields[3] as bool,
      theme: fields[4] == null ? 'light' : fields[4] as String,
      lastBackupDate: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.diaryCreationHour)
      ..writeByte(1)
      ..write(obj.diaryLength)
      ..writeByte(2)
      ..write(obj.notificationEnabled)
      ..writeByte(3)
      ..write(obj.chatReminderEnabled)
      ..writeByte(4)
      ..write(obj.theme)
      ..writeByte(5)
      ..write(obj.lastBackupDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
