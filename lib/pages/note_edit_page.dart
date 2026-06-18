import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/notes_repository.dart';
import '../models/note_model.dart';

class NoteEditPage extends StatefulWidget {
  final String noteId;

  const NoteEditPage({super.key, required this.noteId});

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  final NotesRepository _repo = NotesRepository.instance;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  late Category _selectedCategory;
  Note? _note;

  @override
  void initState() {
    super.initState();
    _note = _repo.getById(widget.noteId);
    _titleCtrl = TextEditingController(text: _note?.title ?? '');
    _contentCtrl = TextEditingController(text: _note?.content ?? '');
    _selectedCategory = _note?.category ?? Category.personal;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_note == null) return;
    if (!_formKey.currentState!.validate()) return;

    final updated = _note!.copyWith(
      title: _titleCtrl.text.trim(),
      content: _contentCtrl.text.trim(),
      category: _selectedCategory,
    );
    _repo.updateNote(updated);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_note == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Catatan tidak ditemukan')),
        body: const Center(child: Text('Catatan ini sudah tidak ada.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Catatan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Judul Catatan',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentCtrl,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                      value: Category.personal, child: Text('Personal')),
                  DropdownMenuItem(
                      value: Category.pekerjaan, child: Text('Pekerjaan')),
                  DropdownMenuItem(
                      value: Category.lainnya, child: Text('Lainnya')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCategory = val);
                  }
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}