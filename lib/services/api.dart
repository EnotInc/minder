import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import './context.dart';
import './helper.dart';

class ApiService {
  static Dio dio = Dio();

  static int token = 123;

  Future<dynamic> get({required String path}) async {
    try {
      final responce = await dio.get(path, options: Options(headers: {'Authorization': 'Bearer $token'}));
      return responce.data;
    } catch (error) {
      _somethingWentWrong();
    }
  }

  Future<dynamic> post({required String path, required dynamic body}) async {
    try {
      final responce = await dio.post(
        path,
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return responce.data;
    } catch (error) {
      _somethingWentWrong();
    }
  }

  //TODO: add message
  static void _somethingWentWrong() {
    HelperService.alertDialog(
      title: Text("foo"),
      content: Text("bar"),
      buttons: [
        TextButton(
          onPressed: () {
            Navigator.of(ContextService.key.currentContext!).pop();
          },
          child: Text("baz"),
        ),
      ],
    );
  }
}
