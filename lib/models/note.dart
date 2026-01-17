import 'dart:convert';

class Note {
  String id;
  String text;

  Note({required this.id, required this.text});

  // Превращаем в Map для сохранения в JSON
  Map<String, dynamic> toMap() => {'id': id, 'text': text};

  // Создаем объект из Map
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(id: map['id'], text: map['text']);
  }
}