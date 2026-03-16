// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
  id: (json['id'] as num).toInt(),
  remindAt: json['remind_at'] as String,
);

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{'id': instance.id, 'remind_at': instance.remindAt};
