import 'package:client/services/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../api_modules/auth/auth.dart';
import '../api_modules/body/body.dart';
import './context.dart';
import './helper.dart';

class ApiService {
  static final url = "http://localhost:3000/apiv1/";

  static Dio dio = Dio();

  Future<dynamic> get({required String path}) async {
    try {
      if (kDebugMode) {
        debugPrint("$url$path");
      }

      final token = await StorageService().getToken("access");
      Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
      if (path.contains('auth')) {
        headers = {};
      }

      final responce = await dio.get("$url$path", options: Options(headers: headers));
      return responce;
    } on DioException catch (error) {
      if (error.response!.statusCode == 401) {
        return await refreshToken(path: path, method: "GET");
      }

      Navigator.of(ContextService.key.currentContext!).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      StorageService().emptyStorage();
    } catch (error) {
      _somethingWentWrong(error);
    }
  }

  Future<dynamic> post({required String path, required Map<String, dynamic> body}) async {
    try {
      if (kDebugMode) {
        debugPrint("$url$path");
        debugPrint(body.toString());
      }

      final token = await StorageService().getToken("access");
      Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
      if (path.contains('auth')) {
        headers = {};
      }

      final responce = await dio.post(
        "$url$path",
        data: body,
        options: Options(headers: headers),
      );

      return responce;
    } on DioException catch (error) {
      if (error.response!.statusCode == 401) {
        return await refreshToken(path: path, body: body, method: "POST");
      }
      Navigator.of(ContextService.key.currentContext!).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      StorageService().emptyStorage();
    } catch (error) {
      _somethingWentWrong(error);
    }
  }

  static void _somethingWentWrong(Object error) {
    HelperService.alertDialog(
      title: Text("Error"),
      content: Text("Something went wrong: $error"),
      buttons: [
        TextButton(
          onPressed: () {
            Navigator.of(ContextService.key.currentContext!).pop();
          },
          child: Text("ok"),
        ),
      ],
    );
  }

  Future<dynamic> refreshToken({required String path, required String method, Map<String, dynamic>? body}) async {
    try {
      final refreshOld = await StorageService().getToken("refresh");
      print(refreshOld);
      final response = await dio.post("${url}auth/refresh", data: {"refresh_token": refreshOld});

      String access;
      String refresh;

      final model = Body<Auth>.fromJson(response.data, (json) => Auth.fromJson(json as Map<String, dynamic>));
      if (model.success && model.data != null) {
        access = model.data!.accesToken;
        refresh = model.data!.refreshToken;

        print("it parsed");

        StorageService().saveToken(type: "access", token: access);
        StorageService().saveToken(type: "refresh", token: refresh);

        print("I fking did IT!!!!!!!!111");
        print("I fking did IT!!!!!!!!111");
        print("I fking did IT!!!!!!!!111");
        print("I fking did IT!!!!!!!!111");
        print("I fking did IT!!!!!!!!111");
        print("I fking did IT!!!!!!!!111");
      } else {
        throw ("Unable to get login");
      }

      Map<String, dynamic> headers = {'Authorization': 'Bearer $access'};
      switch (method) {
        case "GET":
          return await dio.get("$url$path", options: Options(headers: headers));
        case "POST":
          return await dio.post(
            "$url$path",
            data: body,
            options: Options(headers: headers),
          );
        case "DELETE":
          return await dio.delete(
            "$url$path",
            data: body,
            options: Options(headers: headers),
          );
      }
    } catch (error) {
      Navigator.of(ContextService.key.currentContext!).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      StorageService().emptyStorage();
      _somethingWentWrong(error);
    }
  }
}
