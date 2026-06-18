import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/notes_repository.dart';
import '../models/note_model.dart';

class NoteDetailPage extends StatefulWidget {
  final String noteId;

  const NoteDetailPage({super.key, required this.noteId});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final NotesRepository _repo = NotesRepository.instance;

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  void _confirmDelete(Note note) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('Catatan "${note.title}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              _repo.removeNote(note);
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final note = _repo.getById(widget.noteId);

    if (note == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Catatan tidak ditemukan')),
        body: const Center(
          child: Text('Catatan ini sudah tidak ada.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${note.categoryIcon} ${note.categoryName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () => context.push('/home/note/edit/${note.id}'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Hapus',
            onPressed: () => _confirmDelete(note),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),
            const Divider(height: 32),
            Text(
              note.content.isEmpty ? '(Tidak ada isi catatan)' : note.content,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}