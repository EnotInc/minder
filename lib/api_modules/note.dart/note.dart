import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "title")
  String title;

  @JsonKey(name: "description")
  String description;

  String? color;
  // DateTime? eventDate;
  // String? endDate;
  // String? categoryId;
  // String? location;
  // bool? isPrivate;
  // bool? isRecurring;
  // bool? isCompleted;
  // int? priority;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  // String? reminderId;
  // String? remindAt;
  // String? notificationType;

  Note({
    required this.id,
    required this.title,
    required this.description,
    this.color,
    // this.eventDate,
    // this.endDate,
    // this.categoryId,
    // this.location,
    // this.isPrivate,
    // this.isRecurring,
    // this.isCompleted,
    // this.priority,
    // this.createdAt,
    // this.updatedAt,
    // this.reminderId,
    // this.remindAt,
    // this.notificationType,
  });

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
