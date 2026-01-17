import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class NoteDatabase extends ChangeNotifier{
  static late SharedPreferences prefs;

   //list of notes
  final List<Note> currentNotes = [];

  //INITIALIZE
  static Future<void> initialize() async{
    prefs = await SharedPreferences.getInstance();
  }

  //CREATE
  Future<void> addNote(String textFromUser) async{
    final id = const Uuid().v4();
    final newNote = Note(id: id, text: textFromUser);

    currentNotes.add(newNote);
    await _saveToDisk();
    notifyListeners();
  }

  //READ 
  Future<void> fetchNotes() async{
    final String? notesJson = prefs.getString('notes_list');
    if (notesJson != null) {
          List<dynamic> decoded = jsonDecode(notesJson);
          currentNotes.clear();
          currentNotes.addAll(decoded.map((item) => Note.fromMap(item)).toList());
    }
    notifyListeners();
  }

  //UPDATE 
  Future<void> updateNote(String id, String newText) async {
    int index = currentNotes.indexWhere((note) => note.id == id);
    if (index != -1) {
      currentNotes[index].text = newText;
      await _saveToDisk();
      notifyListeners();
    }
  }

  //DELETE
  Future<void> deleteNote(String id) async {
    currentNotes.removeWhere((note) => note.id == id);
    await _saveToDisk();
    notifyListeners();
  }

  //Save to disk
  Future<void> _saveToDisk() async {
    String encoded = jsonEncode(currentNotes.map((n) => n.toMap()).toList());
    await prefs.setString('notes_list', encoded);
  }
}
