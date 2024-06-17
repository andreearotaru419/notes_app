import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:notes/notes_provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      Provider.of<NotesProvider>(context, listen: false)
          .addFile(result.files.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
        onPressed: () async {
          await _pickFile();
        },
        icon: const Icon(
          Icons.attach_file,
          color: Colors.white,
        ),
        label: const Text(
          'Pick a file',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
            stops: const [0.5, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Search notes',
                  labelStyle: TextStyle(color: Colors.blue.shade200),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.blue,
                  ),
                ),
                onChanged: (value) {
                  Provider.of<NotesProvider>(context, listen: false)
                      .searchNotes(value);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Write your note here...',
                  hintStyle: TextStyle(color: Colors.blue.shade200),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue, width: 1),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: InkWell(
                    onTap: () {
                      if (_controller.text.isNotEmpty) {
                        Provider.of<NotesProvider>(context, listen: false)
                            .addNote(_controller.text);
                        _controller.clear();
                      }
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                  ),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    Provider.of<NotesProvider>(context, listen: false)
                        .addNote(value);
                    _controller.clear();
                  }
                },
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<NotesProvider>(
                  builder: (context, notesProvider, child) {
                    final notes = notesProvider.filteredNotes;
                    final files = notesProvider.files;

                    if (notes.isEmpty && files.isEmpty) {
                      return const Center(
                        child: Text(
                          'No notes added yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemCount: notes.length + files.length,
                      itemBuilder: (context, index) {
                        Widget itemWidget;
                        if (index < notes.length) {
                          final note = notes[index];
                          itemWidget =
                              _buildNoteItem(note, notesProvider, index);
                        } else {
                          final fileIndex = index - notes.length;
                          final file = files[fileIndex];
                          itemWidget =
                              _buildFileItem(file, notesProvider, fileIndex);
                        }
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: itemWidget,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteItem(String note, NotesProvider notesProvider, int index) {
    return ListTile(
      title: Text(
        note,
        style: const TextStyle(fontSize: 16),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.blue),
            onPressed: () {
              Share.share(note);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              notesProvider.deleteNoteByIndex(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFileItem(
      PlatformFile file, NotesProvider notesProvider, int fileIndex) {
    return ListTile(
      title: Text(
        file.name,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text('${file.size} bytes'),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          notesProvider.deleteFileByIndex(fileIndex);
        },
      ),
    );
  }
}
