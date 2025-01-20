
import 'package:flutter/material.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/domain/usecases/manage_contents.dart';
import 'package:notes/presentation/views/note_details_view.dart';
import 'package:notes/presentation/widgets/loading_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.readNotesUsecase});

  final MaintainNotes readNotesUsecase;

  @override
  State<StatefulWidget> createState() => _HomeState();
  
}

class _HomeState extends State<Home> {

  List<Note>? _notes;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_rounded)
          )
        ],
      ),
      body: LoadingScreen(
        screen: (_notes != null && _notes!.isNotEmpty)
          ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _notes!.length,
              itemBuilder: (context, index) {
                final note = _notes![index];
                return ElevatedButton(
                  onPressed: () {
                    gotoNoteDetails(note.id, context);
                  },
                  child: ListTile(
                    title: Text(note.name),
                    trailing: Text(note.lastEdited != null ? note.lastEdited.toString() : ''),
                  ),
                );
              }
            ),
          )
          : const Center(
            child: Text('No content'),
          ),
        loading: _loading
      )
    );
  }

  void fetchNotes() async {
    setState(() {
      _loading = true;
    });
    _notes = await widget.readNotesUsecase.getAllNotes();
    setState(() {
      _loading = false;
    });
  }

  void gotoNoteDetails(String noteId, BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return NoteScreen(
          noteId: noteId, 
          readNotesUsecase: widget.readNotesUsecase, 
          manageContents: ManageContents.instance,
        );
      })
    );
  }
  
}