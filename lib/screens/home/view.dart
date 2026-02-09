import 'dart:math';

import 'package:client/screens/home/viewmoder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../services/theme.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    //final viewModer = context.read<HomeViewModel>();
    // here I can use this to fetch user's notes
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    List<Note> notes = viewModel.notes;

    if (notes != viewModel.notes) {
      notes = viewModel.notes;
    }

    return Scaffold(
      appBar: AppBar(
        title: SearchBar(hintText: "foobarbaz"),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            children: List.generate(notes.length, (index) {
              return NoteCard(note: notes[index]);
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
    );
  }
}

final List<Color> _noteColors = [Color(0xffffffff), Color(0xfff28b81), Color(0xfffbf476), Color(0xffcdff90), Color(0xffa7feeb), Color(0xffcbf0f8), Color(0xffafcbfa)];

class NoteCard extends StatefulWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  static Color _getRandomPastelColor() {
    return _noteColors[Random().nextInt(_noteColors.length)];
  }

  //late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    widget.note.color = _getRandomPastelColor();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: ThemeService.mainBackground,
        borderRadius: BorderRadius.circular(8),
        border: BoxBorder.all(color: widget.note.color!),
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
                actions: [widget.note.isNotify ? IconButton(onPressed: () {}, icon: Icon(Icons.notifications_active_outlined)) : SizedBox()],
              ),
              const SizedBox(height: 8),
              Text(widget.note.content, overflow: TextOverflow.ellipsis, maxLines: 10, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
        onLongPress: () {
          showModalBottomSheet(
            useSafeArea: true,
            context: context,
            //context: ContextService.key.currentContext!,
            backgroundColor: Colors.transparent,
            builder: (context) {
              final arr = [
                AppBar(
                  title: Text(widget.note.title, style: TextStyle(fontSize: 32)),
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                ),
                Container(height: 2, color: widget.note.color),
                ListTile(
                  title: TextButton(onPressed: () {}, child: Text("Изменить")),
                ),
                ListTile(
                  title: TextButton(
                    onPressed: () async {
                      await viewModel.delNote(note: widget.note);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Удалить"),
                  ),
                ),
                Row(
                  children: List.generate(_noteColors.length, (index) {
                    return Icon(Icons.circle, color: _noteColors[index]);
                  }),
                ),
              ];
              return SafeArea(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemeService.mainBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: BoxBorder.all(color: widget.note.color!),
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
