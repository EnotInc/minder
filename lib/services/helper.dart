import 'package:client/services/context.dart';
import 'package:flutter/material.dart';

class HelperService {
  static void alertDialog({Widget? title, Widget? content, List<Widget>? buttons, Color? color}) {
    if (ContextService.key.currentContext == null) return;

    showDialog(
      context: ContextService.key.currentContext!,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(title: title, content: content, actions: buttons, backgroundColor: color),
        );
      },
    );
  }

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
}
