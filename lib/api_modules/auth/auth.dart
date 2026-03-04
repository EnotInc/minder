import 'package:json_annotation/json_annotation.dart';

part "auth.g.dart";

@JsonSerializable()
class Auth {
  @JsonKey(name: "token")
  String token;

  Auth({required this.token});

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
  Map<String, dynamic> toJson() => _$AuthToJson(this);
}
