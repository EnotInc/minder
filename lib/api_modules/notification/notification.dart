import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "remind_at")
  String remindAt;

  // @JsonKey(name: "notification_type")
  // String notificationType;

  Notification({required this.id, required this.remindAt});

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
