import 'package:json_annotation/json_annotation.dart';

import '../note.dart/note.dart';

part 'notesList.g.dart';

@JsonSerializable()
class Noteslist {
  @JsonKey(name: "notes")
  List<Note>? notes;

  Noteslist({required this.notes});

  factory Noteslist.fromJson(Map<String, dynamic> json) => _$NoteslistFromJson(json);
  Map<String, dynamic> toJson() => _$NoteslistToJson(this);
}
