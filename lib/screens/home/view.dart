import 'package:client/screens/home/viewmoder.dart';
import 'package:client/screens/home/note_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../api_modules/note/note.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    final viewModel = context.read<HomeViewModel>();
    viewModel.fetchNotes();
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
        leading: Icon(null),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushNamed('/profile');
            },
            icon: Icon(Icons.person),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: (viewModel.notes.isEmpty)
          ? Column(
              children: [
                Expanded(child: SizedBox()),
                Center(child: Text("Create your firt note!", style: TextStyle(fontSize: 32))),
                Expanded(child: SizedBox()),
                Center(child: AddNoteButton(viewModel: viewModel)),
                Expanded(child: SizedBox()),
              ],
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: viewModel.fetchNotes,
                child: SingleChildScrollView(
                  child: StaggeredGrid.count(
                    crossAxisCount: 2,
                    children: List.generate(notes.length, (index) {
                      return NoteCard(note: notes[index]);
                    }),
                  ),
                ),
              ),
            ),
      floatingActionButton: (viewModel.notes.isEmpty) ? null : AddNoteButton(viewModel: viewModel),
    );
  }
}

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
