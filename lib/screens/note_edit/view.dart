import 'package:client/enums/category.dart';
import 'package:client/services/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../api_modules/note/note.dart';
import '../../services/helper.dart';
import '../../services/theme.dart';
import '../../services/color.dart';

import 'viewmodel.dart';

class NoteEditview extends StatefulWidget {
  const NoteEditview({super.key, this.note});

  final Note? note;

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
    Note note = widget.note ?? Note(id: -1, title: "", description: "", color: ColorService.getRandomPastelColor(), isImportant: false, categoryId: null);
    viewModel.note = note;
    viewModel.isNew = widget.note == null;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NoteEditViewModel>();
    header.text = viewModel.note.title;
    content.text = viewModel.note.description ?? "";

    return Scaffold(
      backgroundColor: ThemeService.mainBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        iconTheme: IconThemeData(size: 32.0),
        actions: [
          PopupMenuButton<Categories>(
            icon: viewModel.categoryIcon(),
            onSelected: (type) {
              setState(() {
                viewModel.changeCategory(type);
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: Categories.none,
                child: Row(children: [Icon(Icons.remove), const Text(' None')]),
              ),
              PopupMenuItem(
                value: Categories.work,
                child: Row(children: [cIcons[1], Text(' Work')]),
              ),
              PopupMenuItem(
                value: Categories.study,
                child: Row(children: [cIcons[2], Text(' Study')]),
              ),
              PopupMenuItem(
                value: Categories.health,
                child: Row(children: [cIcons[3], Text(' Health')]),
              ),
              PopupMenuItem(
                value: Categories.sport,
                child: Row(children: [cIcons[4], Text(' Sprorts')]),
              ),
              PopupMenuItem(
                value: Categories.holidays,
                child: Row(children: [cIcons[5], Text(' Holidays')]),
              ),
              PopupMenuItem(
                value: Categories.travel,
                child: Row(children: [cIcons[6], Text(' Travel')]),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              viewModel.changeImportant();
            },
            icon: Icon(viewModel.note.isImportant ? Icons.error : Icons.error_outline),
          ),
          IconButton(
            onPressed: () {
              viewModel.askAboutDelete();
            },
            icon: Icon(Icons.delete_forever_outlined),
          ),
          IconButton(
            onPressed: () {
              HelperService.alertDialog(
                content: DateService.dateSeting(
                  note: viewModel.note,
                  onAdd: (viewModel.note.notification == null || viewModel.note.notification!.id == -1) ? viewModel.addDate : viewModel.editDate,
                  onDelete: viewModel.deleteNotification,
                ),
                color: Colors.transparent,
              );
            },
            icon: Icon(viewModel.note.notification == null ? Icons.notification_add_outlined : Icons.edit_notifications_outlined),
          ),
          IconButton(
            onPressed: () {
              Color changedColor = viewModel.note.color;
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
            color: viewModel.note.color,
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
              border: BoxBorder.all(color: viewModel.note.color, width: 4.0),
            ),
            child: Column(
              spacing: 12,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 24, bottom: 12),
                  child: Center(
                    child: TextFormField(
                      controller: header,
                      style: TextStyle(fontSize: 32),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(hintText: "So, what's up...", border: InputBorder.none, errorStyle: TextStyle(fontSize: 12)),
                      onChanged: (value) {
                        viewModel.note.title = header.text;
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(left: 8, right: 8),
                        child: Container(height: 1.0, color: viewModel.note.color),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: Scrollbar(
                      child: TextField(
                        controller: content,
                        maxLines: null,
                        minLines: 64,
                        style: TextStyle(fontSize: 20),
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(hintText: "tell me more", border: InputBorder.none, contentPadding: EdgeInsets.all(8)),
                        onChanged: (value) {
                          viewModel.note.description = content.text;
                        },
                      ),
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
          if (header.text.isEmpty) {
            HelperService.alertDialog(
              content: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.red, width: 4.0),
                  color: ThemeService.mainBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppBar(automaticallyImplyLeading: false, title: Text("Caution"), backgroundColor: Colors.transparent),
                    Text("Header must be filled in!\n"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Ok"),
                    ),
                  ],
                ),
              ),
              color: Colors.transparent,
            );
          } else {
            await viewModel.completeNote();
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
