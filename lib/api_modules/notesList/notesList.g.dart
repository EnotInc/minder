// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notesList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Noteslist _$NoteslistFromJson(Map<String, dynamic> json) => Noteslist(
  notes: (json['notes'] as List<dynamic>?)
      ?.map((e) => Note.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$NoteslistToJson(Noteslist instance) => <String, dynamic>{
  'notes': instance.notes,
};
