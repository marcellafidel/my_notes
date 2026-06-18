import 'package:flutter/material.dart';
import 'models/note_model.dart';

class NoteDetailPage extends StatelessWidget {
  final Note note;

  const NoteDetailPage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.categoryIcon + ' ' + note.categoryName),
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