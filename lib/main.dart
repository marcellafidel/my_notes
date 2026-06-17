import 'package:flutter/material.dart';
import 'note_model.dart';
import 'note_card.dart';
import 'note_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const NotesHomePage(),
    );
  }
}

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  final List<Note> _notes = [];
  Category? _activeFilter;
  String _searchQuery = '';
  bool _isSearching = false;

  List<Note> get _filteredNotes {
    List<Note> result = _notes;
    if (_activeFilter != null) {
      result = result.where((n) => n.category == _activeFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      result = result
          .where((n) =>
              n.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    return result;
  }

  int _countByCategory(Category cat) =>
      _notes.where((n) => n.category == cat).length;

  void _showAddNoteSheet() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    Category selectedCategory = Category.personal;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tambah Catatan',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: titleCtrl,
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
                      controller: contentCtrl,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Isi Catatan',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Category>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: Category.personal,
                            child: Text('Personal')),
                        DropdownMenuItem(
                            value: Category.pekerjaan,
                            child: Text('Pekerjaan')),
                        DropdownMenuItem(
                            value: Category.lainnya,
                            child: Text('Lainnya')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() => selectedCategory = val);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  _notes.insert(
                                    0,
                                    Note(
                                      id: DateTime.now()
                                          .millisecondsSinceEpoch
                                          .toString(),
                                      title: titleCtrl.text.trim(),
                                      content: contentCtrl.text.trim(),
                                      category: selectedCategory,
                                      createdAt: DateTime.now(),
                                    ),
                                  );
                                });
                                Navigator.pop(ctx);
                                _showSnackBar('Catatan berhasil ditambahkan');
                              }
                            },
                            child: const Text('Simpan'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Batal'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
              _deleteNote(note);
            },
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteNote(Note note) {
    final index = _notes.indexOf(note);
    setState(() => _notes.remove(note));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Catatan dihapus'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() => _notes.insert(index, note));
          },
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Cari catatan...',
                  border: InputBorder.none,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              )
            : const Text('📝 Catatan Saya'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) _searchQuery = '';
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatCard(),
          _buildFilterChips(),
          Expanded(
            child: _filteredNotes.isEmpty
                ? _buildEmptyState()
                : AnimatedList(
                    key: GlobalKey<AnimatedListState>(),
                    initialItemCount: _filteredNotes.length,
                    itemBuilder: (ctx, i, animation) {
                      final note = _filteredNotes[i];
                      return SizeTransition(
                        sizeFactor: animation,
                        child: NoteCard(
                          note: note,
                          onDelete: () => _confirmDelete(note),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NoteDetailPage(note: note),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteSheet,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem('Total', _notes.length.toString(), Icons.notes),
            _statItem('Personal',
                _countByCategory(Category.personal).toString(), Icons.person),
            _statItem('Pekerjaan',
                _countByCategory(Category.pekerjaan).toString(), Icons.work),
            _statItem('Lainnya',
                _countByCategory(Category.lainnya).toString(), Icons.label),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20),
        const SizedBox(height: 4),
        Text(count,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Semua'),
            selected: _activeFilter == null,
            onSelected: (_) => setState(() => _activeFilter = null),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Personal'),
            selected: _activeFilter == Category.personal,
            onSelected: (_) =>
                setState(() => _activeFilter = Category.personal),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Pekerjaan'),
            selected: _activeFilter == Category.pekerjaan,
            onSelected: (_) =>
                setState(() => _activeFilter = Category.pekerjaan),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Lainnya'),
            selected: _activeFilter == Category.lainnya,
            onSelected: (_) =>
                setState(() => _activeFilter = Category.lainnya),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada catatan',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}