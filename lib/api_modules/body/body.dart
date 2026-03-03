import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Body {
  @JsonKey(name: "success")
  bool success;

  @JsonKey(name: "message")
  String? message;

  @JsonKey(name: "data")
  List<Object>? data;

  Body({required this.success, required this.message, required this.data});
}
