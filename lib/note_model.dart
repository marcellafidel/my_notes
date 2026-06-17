enum Category { personal, pekerjaan, lainnya }

class Note {
  final String id;
  final String title;
  final String content;
  final Category category;
  final DateTime createdAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
  });

  String get categoryName {
    switch (category) {
      case Category.personal:
        return 'Personal';
      case Category.pekerjaan:
        return 'Pekerjaan';
      case Category.lainnya:
        return 'Lainnya';
    }
  }

  String get categoryIcon {
    switch (category) {
      case Category.personal:
        return '👤';
      case Category.pekerjaan:
        return '💼';
      case Category.lainnya:
        return '📌';
    }
  }
}