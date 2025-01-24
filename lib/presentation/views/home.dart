
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/domain/usecases/maintain_notes.dart';
import 'package:notes/domain/usecases/manage_contents.dart';
import 'package:notes/presentation/views/note_details_view.dart';
import 'package:notes/presentation/widgets/loading_screen.dart';

class Home extends StatefulWidget {
  Home({super.key, required this.readNotesUsecase});

  final MaintainNotes readNotesUsecase;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy - HH:mm');

  @override
  State<StatefulWidget> createState() => _HomeState();
  
}

class _HomeState extends State<Home> {

  List<Note>? _notes;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () { 
              _createNoteModal();
            },
            icon: const Icon(Icons.add_rounded)
          )
        ],
      ),
      body: LoadingScreen(
        screen: (_notes != null && _notes!.isNotEmpty)
          ? GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                for (Note nt in _notes!)
                  GestureDetector(
                    onTap: () { 
                      _gotoNoteDetails(nt.id, context);
                    },
                    child: Card(
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 80.0,
                              child: Center(
                                child: Text(
                                  nt.name,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(widget._dateFormat.format(nt.createdAt))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ]
            )
          : const Center(
              child: Text('No content'),
            ),
        loading: _loading
      )
    );
  }

  void _createNoteModal() async {
    final String? noteName = await showDialog(
      context: context, 
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        return AlertDialog(
          title: const Text('Create note'),
          content: TextField(
            autofocus: true,
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Digite algo aqui...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () { 
                Navigator.pop(context, null);
              }, 
              child: const Text('Cancel')
            ),
            TextButton(
              onPressed: () { 
                final String name = nameController.text;
                if (name.isEmpty) {
                  Navigator.pop(context, null);
                  return;
                }
                Navigator.pop(context, name.trim());
              }, 
              child: const Text('Create')
            ),
          ],
        );
      }
    );

    if (noteName != null) _createNote(noteName);
  }

  void _createNote(String name) async {
    final Note? note = await widget.readNotesUsecase.createNote(name);
    await showDialog(
      // ignore: use_build_context_synchronously
      context: context, 
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        });
        return AlertDialog(
          content: Text(note != null ? 'Note created' : 'Note could not be created'),
        );
      }
    );
    _notes ??= [];
    if (note != null) {
      setState(() {
        _notes!.add(note);
        _notes!.sort((Note first, Note second) {
          return first.createdAt.compareTo(second.createdAt);
        });
      });
    }
  }

  void _fetchNotes() async {
    setState(() {
      _loading = true;
    });
    _notes = await widget.readNotesUsecase.getAllNotes();
    setState(() {
      _loading = false;
    });
  }

  void _gotoNoteDetails(String noteId, BuildContext context) async {
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