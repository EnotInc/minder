// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) =>
    Note(id: (json['id'] as num).toInt(), title: json['title'] as String, description: json['description'] as String, color: json['color'] as String?);

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{'id': instance.id, 'title': instance.title, 'description': instance.description, 'color': instance.color};
