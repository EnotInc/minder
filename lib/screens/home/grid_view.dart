import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'viewmodel.dart';
import 'widgets/note_widget.dart';

class GridView extends StatelessWidget {
  const GridView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: viewModel.fetchNotes,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            children: List.generate(viewModel.notes.length, (index) {
              return NoteCard(note: viewModel.notes[index]);
            }),
          ),
        ),
      ),
    );
  }
}
