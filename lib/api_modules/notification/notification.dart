import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

String? _dateToJson(DateTime date) {
  return date.toIso8601String();
}

DateTime _dateFromJson(String json) {
  DateTime date = DateTime.parse(json);
  return date.add(Duration(hours: 3));
}

@JsonSerializable()
class Notification {
  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "remind_at", fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime remindAt;

  // @JsonKey(name: "notification_type")
  // String notificationType;

  @JsonKey(name: "is_sent")
  bool isSent;

  Notification({required this.id, required this.remindAt, required this.isSent});

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
