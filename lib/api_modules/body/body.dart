import 'package:json_annotation/json_annotation.dart';

part "body.g.dart";

@JsonSerializable(genericArgumentFactories: true)
class Body<T> {
  @JsonKey(name: "success")
  bool success;

  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "data")
  T? data;

  Body({required this.success, required this.message, required this.data});

  factory Body.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) => _$BodyFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => _$BodyToJson(this, toJsonT);
}
