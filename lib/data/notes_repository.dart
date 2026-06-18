import 'package:flutter/foundation.dart' hide Category;

import '../models/note_model.dart';

class NotesRepository extends ChangeNotifier {
  NotesRepository._internal();
  static final NotesRepository instance = NotesRepository._internal();

  final List<Note> _notes = [];

  List<Note> get notes => List.unmodifiable(_notes);

  Note? getById(String id) {
    for (final note in _notes) {
      if (note.id == id) return note;
    }
    return null;
  }

  int countByCategory(Category cat) =>
      _notes.where((n) => n.category == cat).length;

  void addNote({
    required String title,
    required String content,
    required Category category,
  }) {
    _notes.insert(
      0,
      Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        content: content,
        category: category,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  int removeNote(Note note) {
    final index = _notes.indexOf(note);
    if (index != -1) {
      _notes.removeAt(index);
      notifyListeners();
    }
    return index;
  }

  void restoreNote(int index, Note note) {
    _notes.insert(index, note);
    notifyListeners();
  }

  void updateNote(Note updated) {
    final index = _notes.indexWhere((n) => n.id == updated.id);
    if (index != -1) {
      _notes[index] = updated;
      notifyListeners();
    }
  }
}