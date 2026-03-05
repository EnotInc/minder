import 'package:client/services/date.dart';
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
  void initState() {
    super.initState();
    final viewModel = context.read<NoteEditViewModel>();

    viewModel.note = widget.note ?? Note(id: -1, title: "", description: "", color: ColorService.getRandomPastelColor().toString());
    viewModel.isNew = true;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NoteEditViewModel>();

    if (header.text != viewModel.note!.title) {
      header.text = viewModel.note!.title;
    }
    if (content.text != viewModel.note!.description) {
      content.text = viewModel.note!.description;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (header.text.isNotEmpty || content.text.isNotEmpty) {
              viewModel.askAboutGoBack();
            } else {
              Navigator.of(context).pop();
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
        iconTheme: IconThemeData(size: 32.0),
        actions: [
          IconButton(
            onPressed: () {
              viewModel.askAboutDelete();
            },
            icon: Icon(Icons.delete_forever_outlined),
          ),
          IconButton(
            onPressed: () {
              HelperService.alertDialog(
                content: DateService.dateSeting(note: viewModel.note!),
                color: Colors.transparent,
              );
            },
            icon: Icon(Icons.edit_notifications_outlined),
          ),
          IconButton(
            onPressed: () {
              Color changedColor = ColorService().fromString(widget.note!.color);
              HelperService.alertDialog(
                title: Text("Choose a color"),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: changedColor,
                    onColorChanged: (color) {
                      changedColor = color;
                    },
                  ),
                ),
                buttons: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      viewModel.changeColor(newColor: changedColor);
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
            color: ColorService().fromString(viewModel.note!.color),
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
              border: BoxBorder.all(color: ColorService().fromString(widget.note!.color), width: 4.0),
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
                      onChanged: (value) {
                        viewModel.note!.title = header.text;
                      },
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
                      onChanged: (value) {
                        viewModel.note!.description = content.text;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await viewModel.completeNote();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
