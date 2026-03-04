import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import './context.dart';
import './helper.dart';

class ApiService {
  static final url = "http://localhost:3000/apiv1/";

  static Dio dio = Dio();

  static int token = 123;

  Future<dynamic> get({required String path}) async {
    try {
      final responce = await dio.get(path, options: Options(headers: {'Authorization': 'Bearer $token'}));
      //TODO: add responce.statusCode check
      return responce.data;
    } catch (error) {
      _somethingWentWrong(error);
    }
  }

  Future<dynamic> post({required String path, required Map<String, dynamic> body}) async {
    try {
      //Map<String, dynamic> headers = {'Authorization': 'Bearer $token'};
      // if (path.contains('auth')) {
      //   headers = {};
      // }

      if (kDebugMode) {
        debugPrint(body.toString());
      }

      final responce = await dio.post(
        "$url$path",
        data: body,
        //options: Options(headers: headers),
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
