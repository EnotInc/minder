import 'package:client/services/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../api_modules/note/note.dart';
import '../../services/helper.dart';
import '../../services/theme.dart';
import 'viewmoder.dart';

class NoteCard extends StatefulWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ThemeService.mainBackground,
        borderRadius: BorderRadius.circular(8),
        border: BoxBorder.all(color: widget.note.color, width: widget.note.isImportant ? 4 : 1),
      ),
      child: GestureDetector(
        child: Padding(
          padding: EdgeInsetsGeometry.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppBar(
                centerTitle: true,
                title: Text(widget.note.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                actions: [
                  widget.note.notification != null
                      ? IconButton(
                          onPressed: () {
                            HelperService.alertDialog(
                              content: DateService.dateSeting(note: widget.note, onAdd: viewModel.updateDate, onDelete: viewModel.deleteNotification),
                              color: Colors.transparent,
                            );
                          },
                          icon: Icon(Icons.notifications_active_outlined),
                        )
                      : SizedBox(),
                ],
              ),
              const SizedBox(height: 8),
              Text(widget.note.description ?? "", overflow: TextOverflow.ellipsis, maxLines: 10, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        onTap: () {
          Color changedColor = widget.note.color;
          showModalBottomSheet(
            useSafeArea: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) {
              final arr = [
                AppBar(
                  title: Text(widget.note.title, style: TextStyle(fontSize: 32)),
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                ),
                Container(height: 2, color: changedColor),
                ListTile(
                  title: TextButton(
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed('/note_edit', arguments: {'note': widget.note}).then((_) async {
                        await viewModel.fetchNotes();
                      });
                    },
                    child: Text("Change"),
                  ),
                ),
                ListTile(
                  title: TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      viewModel.askAboutDelete(note: widget.note);
                    },
                    child: Text("Delete"),
                  ),
                ),
                ListTile(
                  title: TextButton(
                    onPressed: () {
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
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              viewModel.changeColor(newColor: changedColor, note: widget.note);
                              setState(() {});
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
                    child: Text("Choose a color"),
                  ),
                ),
              ];
              return SafeArea(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemeService.mainBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: BoxBorder.all(color: changedColor),
                    ),
                    child: Wrap(children: arr),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
