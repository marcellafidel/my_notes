import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.note_alt_rounded, size: 64),
            const SizedBox(height: 16),
            const Text(
              '📝 My Notes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aplikasi catatan pribadi sederhana yang dibangun '
              'dengan Flutter, dengan navigasi modern menggunakan GoRouter.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Mata Kuliah: Pemrograman Perangkat Bergerak I\n'
              'Program Studi: D3 Manajemen Informatika\n'
              'Fakultas Teknik dan Ilmu Komputer — UNSIQ',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}