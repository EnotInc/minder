import 'package:json_annotation/json_annotation.dart';

part "auth.g.dart";

@JsonSerializable()
class Auth {
  @JsonKey(name: "access_token")
  String accesToken;

  @JsonKey(name: "refresh_token")
  String refreshToken;

  Auth({required this.accesToken, required this.refreshToken});

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);
  Map<String, dynamic> toJson() => _$AuthToJson(this);
}
