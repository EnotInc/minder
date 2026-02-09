import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../api_modules/note.dart/note.dart';
import '../../services/helper.dart';
import '../../services/theme.dart';
import '../../services/color.dart';

import 'viewmoder.dart';

class NoteEditview extends StatefulWidget {
  NoteEditview({super.key, this.note});

  late Note? note;

  @override
  State<NoteEditview> createState() => _NoteEditviewState();
}

class _NoteEditviewState extends State<NoteEditview> {
  final header = TextEditingController();
  final content = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (widget.note == null) {
      widget.note = Note(id: 1, title: "", content: "", color: ColorService.getRandomPastelColor());
    }

    final viewModel = context.watch<NoteEditViewModel>();
    viewModel.note = widget.note!;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NoteEditViewModel>();
    Color changedColor = viewModel.note!.color!;

    if (header.text != viewModel.note!.title) {
      header.text = viewModel.note!.title;
    }
    if (content.text != viewModel.note!.content) {
      content.text = viewModel.note!.content;
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: 32.0),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.delete_forever_outlined)),
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_active_outlined)),
          IconButton(
            onPressed: () {
              HelperService.alertDialog(
                title: Text("Choose a color"),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: viewModel.note!.color!,
                    onColorChanged: (color) {
                      changedColor = color;
                    },
                  ),
                ),
                buttons: [
                  TextButton(
                    onPressed: () {
                      viewModel.changeColor(newColor: changedColor);
                      Navigator.of(context).pop();
                    },
                    child: Text("Ok"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              );
            },
            icon: Icon(Icons.square_rounded),
            color: viewModel.note!.color,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: ThemeService.mainBackground,
              borderRadius: BorderRadius.circular(16),
              border: BoxBorder.all(color: viewModel.note!.color!, width: 4.0),
            ),
            child: Column(
              spacing: 12,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 24, bottom: 12),
                  child: Center(
                    child: TextField(
                      controller: header,
                      style: TextStyle(fontSize: 32),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(hintText: "So, what's up...", border: InputBorder.none),
                    ),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: content,
                      maxLines: null,
                      minLines: 512,
                      style: TextStyle(fontSize: 20),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(hintText: "tell me more", border: InputBorder.none, contentPadding: EdgeInsets.all(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
