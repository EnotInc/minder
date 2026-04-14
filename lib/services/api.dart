import 'package:client/enums/tokens.dart';
import 'package:client/services/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../api_modules/auth/auth.dart';
import '../api_modules/body/body.dart';
import './context.dart';
import './helper.dart';

void printDebugInfo({required String url, String? req, required String res}) {
  if (kDebugMode) {
    print(url);
    print(req ?? "{}");
    print(res);
  }
}

class ApiService {
  static final url = "http://localhost:3000/apiv1/";

  static Dio dio = Dio();
  Future<bool> isAlive() async {
    try {
      final res = await dio.get("${url}ping", options: Options(sendTimeout: Duration(seconds: 15)));
      return res.statusCode == 200 && res.toString() == "pong";
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    Navigator.of(ContextService.key.currentContext!).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    StorageService().emptyStorage();
  }

  Future<dynamic> get({required String path}) async {
    try {
      final token = await StorageService().read(Token.access.name);
      Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
      if (path.contains('auth')) {
        headers = {};
      }

      final responce = await dio.get("$url$path", options: Options(headers: headers));
      printDebugInfo(url: url + path, req: null, res: responce.toString());
      return responce;
    } on DioException catch (error) {
      if (!await isAlive()) {
        HelperService.serverUnabailabe();
        return null;
      }
      if (error.response!.statusCode == 401) {
        return await refreshToken(path: path, method: "GET");
      }
      HelperService().somethingWentWrong(error);
      ApiService().logout();
    } catch (error) {
      if (await isAlive()) {
        HelperService().somethingWentWrong(error);
      } else {
        HelperService.serverUnabailabe();
      }
      return null;
    }
  }

  Future<dynamic> post({required String path, required Map<String, dynamic> body}) async {
    try {
      final String token = await StorageService().read(Token.access.name);
      Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
      if (path.contains('auth')) {
        headers = {};
      }
      final responce = await dio.post(
        "$url$path",
        data: body,
        options: Options(headers: headers),
      );
      printDebugInfo(url: url + path, req: body.toString(), res: responce.toString());
      return responce;
    } on DioException catch (error) {
      if (!await isAlive()) {
        HelperService.serverUnabailabe();
        return null;
      }
      if (error.response!.statusCode == 401) {
        return await refreshToken(path: path, body: body, method: "POST");
      }
      HelperService().somethingWentWrong(error);
      ApiService().logout();
    } catch (error) {
      if (await isAlive()) {
        HelperService().somethingWentWrong(error);
      } else {
        HelperService.serverUnabailabe();
      }
      return null;
    }
  }

  Future<dynamic> delete({required String path, required Map<String, dynamic> body}) async {
    try {
      final token = await StorageService().read(Token.access.name);
      Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};

      final responce = await dio.delete(
        "$url$path",
        data: body,
        options: Options(headers: headers),
      );

      printDebugInfo(url: url + path, req: body.toString(), res: responce.toString());
      return responce;
    } on DioException catch (error) {
      if (!await isAlive()) {
        HelperService.serverUnabailabe();
        return null;
      }
      if (error.response!.statusCode == 401) {
        return await refreshToken(path: path, body: body, method: "DELETE");
      }
      HelperService().somethingWentWrong(error);
      ApiService().logout();
    } catch (error) {
      if (await isAlive()) {
        HelperService().somethingWentWrong(error);
      } else {
        HelperService.serverUnabailabe();
      }
      return null;
    }
  }

  Future<dynamic> refreshToken({required String path, required String method, Map<String, dynamic>? body}) async {
    try {
      final refreshOld = await StorageService().read(Token.refresh.name);
      final response = await dio.post("${url}auth/refresh", data: {"refresh_token": refreshOld});

      String access;
      String refresh;

      final model = Body<Auth>.fromJson(response.data, (json) => Auth.fromJson(json as Map<String, dynamic>));
      if (model.success && model.data != null) {
        access = model.data!.accesToken!;
        refresh = model.data!.refreshToken!;

        StorageService().write(key: Token.access.name, value: access);
        StorageService().write(key: Token.refresh.name, value: refresh);
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
      ApiService().logout();
      HelperService().somethingWentWrong(error);
      return null;
    }
  }
}
