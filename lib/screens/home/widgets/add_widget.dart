import 'package:flutter/material.dart';

import '../viewmodel.dart';

class AddNoteButton extends StatelessWidget {
  const AddNoteButton({super.key, required this.viewModel});
  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/note_edit', arguments: {'note': null}).then((_) async {
          await viewModel.fetchNotes();
        });
      },
      child: Icon(Icons.add),
    );
  }
}
