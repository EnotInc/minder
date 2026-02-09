import 'package:client/services/context.dart';
import 'package:flutter/material.dart';

class HelperService {
  static void alertDialog({Widget? title, required Widget content, required List<Widget> buttons}) {
    if (ContextService.key.currentContext == null) return;

    showDialog(
      context: ContextService.key.currentContext!,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(title: title, content: content, actions: buttons),
        );
      },
    );
  }
}
