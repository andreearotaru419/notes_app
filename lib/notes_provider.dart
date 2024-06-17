import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class NotesProvider extends ChangeNotifier {
  final List<String> _notes = [];
  List<String> _filteredNotes = [];
  final List<PlatformFile> _files = [];

  List<String> get notes => _notes;
  List<String> get filteredNotes =>
      _filteredNotes.isNotEmpty ? _filteredNotes : _notes;
  List<PlatformFile> get files => _files;

  void addNote(String note) {
    _notes.add(note);
    _filteredNotes = [];
    notifyListeners();
  }

  void deleteNoteByIndex(int index) {
    if (_filteredNotes.isEmpty) {
      _notes.removeAt(index);
    } else {
      _notes.remove(_filteredNotes[index]);
      _filteredNotes.removeAt(index);
    }
    notifyListeners();
  }

  void searchNotes(String query) {
    if (query.isEmpty) {
      _filteredNotes = [];
    } else {
      _filteredNotes = _notes
          .where((note) => note.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void addFile(PlatformFile file) {
    _files.add(file);
    notifyListeners();
  }

  void deleteFileByIndex(int index) {
    _files.removeAt(index);
    notifyListeners();
  }
}
