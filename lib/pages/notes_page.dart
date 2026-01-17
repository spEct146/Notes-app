import 'package:flutter/material.dart';
import 'package:notes_app/components/drawer.dart';
import 'package:notes_app/components/note_settings.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notes_app/themes/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() => readNotes());
  }

  //create
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'New note'),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  textController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              MaterialButton(
                onPressed: () async {
                  await context.read<NoteDatabase>().addNote(
                    textController.text,
                  );
                  await context.read<NoteDatabase>().fetchNotes();
                  textController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //read
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  //update
  void updateNotes(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'Update note'),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  textController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              MaterialButton(
                onPressed: () async {
                  await context.read<NoteDatabase>().updateNote(
                    note.id,
                    textController.text,
                  );
                  await context.read<NoteDatabase>().fetchNotes();
                  textController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Udpate'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //delete
  void deleteNotes(Note note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          'Are you sure to delete this note?',
          style: GoogleFonts.crimsonText(
            fontSize: 20,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  textController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              MaterialButton(
                onPressed: () async {
                  await context.read<NoteDatabase>().deleteNote(note.id);
                  await context.read<NoteDatabase>().fetchNotes();
                  textController.clear();
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteDataBase = context.watch<NoteDatabase>();

    List<Note> currentNotes = noteDataBase.currentNotes;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      drawer: MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 20),
            child: Text(
              'Notes',
              style: GoogleFonts.pacifico(
                fontSize: 48,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                final note = currentNotes[index];
                return ListTile(
                  title: Text(
                    note.text,
                    style: GoogleFonts.crimsonText(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  trailing: Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () => showPopover(
                          width: 100,
                          height: 100,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          context: context,
                          bodyBuilder: (context) => NoteSettings(
                            onEditTap: () => updateNotes(note),
                            onDeleteTap: () => deleteNotes(note),
                          ),
                        ),
                        icon: const Icon(Icons.more_vert),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
