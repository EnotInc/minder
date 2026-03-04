import 'package:client/services/api.dart';
import 'package:client/services/context.dart';
import 'package:client/services/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../api_modules/auth/auth.dart';
import '../../../api_modules/body/body.dart';

class RegisterviewModel extends ChangeNotifier {
  String login = "";
  String email = "";
  String passoword = "";

  Future<void> registerUser() async {
    try {
      Map<String, dynamic> body = {"username": login, "email": email, "password": passoword};

      final Response<dynamic>? response = await ApiService().post(path: "auth/register", body: body);
      if (response != null) {
        final model = Body<Auth>.fromJson(response.data, (json) => Auth.fromJson(json as Map<String, dynamic>));

        if (model.success) {
          if (model.data != null) {
            StorageService().saveToken(type: "access", token: model.data!.accesToken);
            StorageService().saveToken(type: "refresh", token: model.data!.refreshToken);
            Navigator.pushReplacementNamed(ContextService.key.currentContext!, '/home');
          } else {
            throw ("token is null");
          }
        } else {
          //TODO: replace with alert dialog
          print(model.message ?? "some error");
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
