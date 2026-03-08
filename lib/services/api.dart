import 'package:client/enums/tokens.dart';
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

  Future<void> somethingWentWrong(Object error) async {
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

  Future<dynamic> get({required String path}) async {
    try {
      if (kDebugMode) {
        debugPrint("$url$path");
      }

      final token = await StorageService().getToken(Token.access.name);
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
      somethingWentWrong(error);
    }
  }

  Future<dynamic> post({required String path, required Map<String, dynamic> body}) async {
    try {
      if (kDebugMode) {
        debugPrint("$url$path");
        debugPrint(body.toString());
      }

      final token = await StorageService().getToken(Token.access.name);
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
      somethingWentWrong(error);
    }
  }

  Future<dynamic> delete({required String path, required Map<String, dynamic> body}) async {
    try {
      if (kDebugMode) {
        debugPrint("$url$path");
        debugPrint(body.toString());
      }

      final token = await StorageService().getToken(Token.access.name);
      Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};

      final responce = await dio.delete(
        "$url$path",
        data: body,
        options: Options(headers: headers),
      );

      return responce;
    } on DioException catch (error) {
      if (error.response!.statusCode == 401) {
        return await refreshToken(path: path, body: body, method: "DELETE");
      }
      Navigator.of(ContextService.key.currentContext!).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      StorageService().emptyStorage();
    } catch (error) {
      somethingWentWrong(error);
    }
  }

  Future<dynamic> refreshToken({required String path, required String method, Map<String, dynamic>? body}) async {
    try {
      final refreshOld = await StorageService().getToken(Token.refresh.name);
      final response = await dio.post("${url}auth/refresh", data: {"refresh_token": refreshOld});

      String access;
      String refresh;

      final model = Body<Auth>.fromJson(response.data, (json) => Auth.fromJson(json as Map<String, dynamic>));
      if (model.success && model.data != null) {
        access = model.data!.accesToken!;
        refresh = model.data!.refreshToken!;

        StorageService().saveToken(type: Token.access.name, token: access);
        StorageService().saveToken(type: Token.refresh.name, token: refresh);
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
      somethingWentWrong(error);
    }
  }
}
