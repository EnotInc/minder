import 'package:client/services/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import './context.dart';
import './helper.dart';

class ApiService {
  static final url = "http://localhost:3000/apiv1/";

  static Dio dio = Dio();

  Future<dynamic> get({required String path}) async {
    try {
      final token = await StorageService().getToken("access");
      Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
      if (path.contains('auth')) {
        headers = {};
      }

      final responce = await dio.get("$url$path", options: Options(headers: headers));
      return responce;
    } on DioException catch (_) {
      StorageService().emptyStorage();
      Navigator.of(ContextService.key.currentContext!).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    } catch (error) {
      _somethingWentWrong(error);
    }
  }

  Future<dynamic> post({required String path, required Map<String, dynamic> body}) async {
    try {
      final token = await StorageService().getToken("access");
      Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
      if (path.contains('auth')) {
        headers = {};
      }

      if (kDebugMode) {
        debugPrint(body.toString());
      }

      final responce = await dio.post(
        "$url$path",
        data: body,
        options: Options(headers: headers),
      );

      return responce;
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
}
