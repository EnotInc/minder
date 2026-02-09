import 'package:client/screens/note_edit.dart/view.dart';
import 'package:client/screens/note_edit.dart/viewmoder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../api_modules/note.dart/note.dart';

class NoteEditScreen extends StatelessWidget {
  const NoteEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Note? note;
    final params = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (params['note'] != null) {
      note = params['note'];
    }

    return ChangeNotifierProvider(
      create: (context) => NoteEditViewModel(),
      child: NoteEditview(note: note),
    );
  }
}
