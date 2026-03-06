import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

import '../../services/color.dart';

part 'note.g.dart';

Color _colorFromJson(String? json) {
  return json != null ? ColorService().fromString(json) : ColorService.getRandomPastelColor();
}

String? _colorToJson(Color color) {
  return color.value.toRadixString(16);
}

@JsonSerializable()
class Note {
  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "title")
  String title;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color color;

  @JsonKey(name: "is_important")
  bool isImportant;
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
    required this.color,
    required this.isImportant,
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
