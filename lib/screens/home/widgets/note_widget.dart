import 'package:client/enums/category.dart';
import 'package:client/services/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../../api_modules/note/note.dart';
import '../../../services/helper.dart';
import '../../../services/theme.dart';
import '../viewmodel.dart';

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
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ThemeService.mainBackground,
        borderRadius: BorderRadius.circular(8),
        border: BoxBorder.all(color: widget.note.color, width: widget.note.isImportant ? 4 : 1),
      ),
      child: GestureDetector(
        child: Padding(
          padding: EdgeInsetsGeometry.all(12),
          child: Column(
            children: [
              (widget.note.categoryId == null && widget.note.notification == null)
                  ? SizedBox()
                  : Row(
                      children: [
                        widget.note.categoryId == null ? SizedBox() : cIcons[widget.note.categoryId!],
                        Spacer(),
                        widget.note.notification == null
                            ? SizedBox()
                            : GestureDetector(
                                onTap: () => HelperService.alertDialog(
                                  content: DateService.dateSeting(note: widget.note, onAdd: viewModel.updateDate, onDelete: viewModel.deleteNotification),
                                  color: Colors.transparent,
                                ),
                                child: Icon(widget.note.notification!.isSent ? Icons.done : Icons.notifications_active_outlined),
                              ),
                      ],
                    ),
              Text(widget.note.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              (widget.note.description == null)
                  ? SizedBox()
                  : Column(
                      children: [
                        Row(
                          children: [Expanded(child: Container(height: 1, color: widget.note.color))],
                        ),
                        const SizedBox(height: 8),
                        Text(widget.note.description ?? "", overflow: TextOverflow.ellipsis, maxLines: 10, style: TextStyle(fontSize: 12)),
                      ],
                    ),
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed('/note_edit', arguments: {'note': widget.note}).then((_) async {
            await viewModel.fetchNotes();
          });
        },
        onLongPress: () {
          Color changedColor = widget.note.color;
          showModalBottomSheet(
            useSafeArea: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) {
              final arr = [
                AppBar(
                  title: Text(widget.note.title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
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
                    child: Text("Change", style: TextStyle(fontSize: 20)),
                  ),
                ),
                ListTile(
                  title: TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      viewModel.askAboutDelete(note: widget.note);
                    },
                    child: Text("Delete", style: TextStyle(fontSize: 20)),
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
                    child: Text("Choose a color", style: TextStyle(fontSize: 20)),
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
