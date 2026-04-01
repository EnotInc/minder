import 'package:client/enums/view_state.dart';
import 'package:client/screens/home/calendar_view.dart';
import 'package:client/screens/home/viewmodel.dart';
import 'package:flutter/material.dart' hide GridView;
import 'package:provider/provider.dart';

import '../../api_modules/note/note.dart';
import '../../services/storage.dart';
import 'widgets/add_widget.dart';
import 'grid_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ViewState curView = ViewState.grid;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<HomeViewModel>();
    viewModel.fetchNotes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
        leading: IconButton(
          onPressed: () {
            setState(() {
              switch (curView) {
                case ViewState.grid:
                  curView = ViewState.calendar;
                case ViewState.calendar:
                  curView = ViewState.grid;
              }
            });
          },
          icon: getIcon(curView),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              //Navigator.of(context).pushNamed('/profile');
              StorageService().emptyStorage();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            },
            icon: Icon(Icons.exit_to_app_rounded),
          ),
          //  IconButton(
          //     onPressed: () async {
          //       Navigator.of(context).pushNamed('/profile');
          //     },
          //     icon: Icon(Icons.person),
          //   ),
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
          : IndexedStack(
              index: curView.index,
              children: [
                GridView(viewModel: viewModel),
                CalendarView(viewModel: viewModel),
              ],
            ),
      floatingActionButton: (viewModel.notes.isEmpty) ? null : AddNoteButton(viewModel: viewModel),
    );
  }
}

Icon getIcon(ViewState state) {
  switch (state) {
    case ViewState.grid:
      return Icon(Icons.calendar_month_outlined);
    case ViewState.calendar:
      return Icon(Icons.grid_view_rounded);
  }
}
