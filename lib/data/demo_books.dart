import '../models/book.dart';

class DemoBooks {
  static const List<Book> _baseBooks = [
    Book(
      id: '',
      title: 'The Little Rainbow',
      ageGroup: '0-4',
      format: '',
      description: 'A colorful story about colors, clouds and friendship.',
      emoji: '🌈',
      fileName: '',
      isDefault: true,
    ),
    Book(
      id: '',
      title: 'Benny the Bunny',
      ageGroup: '0-4',
      format: '',
      description: 'A short bedtime story about a curious little bunny.',
      emoji: '🐰',
      fileName: '',
      isDefault: true,
    ),
    Book(
      id: '',
      title: 'Mia and the Magic Crayons',
      ageGroup: '4-8',
      format: '',
      description: 'Mia discovers crayons that bring drawings to life.',
      emoji: '🖍️',
      fileName: '',
      isDefault: true,
    ),
    Book(
      id: '',
      title: 'The Brave Little Turtle',
      ageGroup: '4-8',
      format: '',
      description: 'A turtle learns that being slow can still be powerful.',
      emoji: '🐢',
      fileName: '',
      isDefault: true,
    ),
    Book(
      id: '',
      title: 'The Secret Library',
      ageGroup: '8-12',
      format: '',
      description: 'Three kids find a hidden library full of magical books.',
      emoji: '📖',
      fileName: '',
      isDefault: true,
    ),
    Book(
      id: '',
      title: 'Captain Luna',
      ageGroup: '8-12',
      format: '',
      description: 'A young space captain travels between stars and planets.',
      emoji: '🚀',
      fileName: '',
      isDefault: true,
    ),
  ];

  static List<Book> defaultBooks() {
    final List<Book> result = [];

    for (final book in _baseBooks) {
      result.add(_copyBookWithFormat(book, 'PDF'));
      result.add(_copyBookWithFormat(book, 'WORD'));
    }

    return result;
  }

  static Book _copyBookWithFormat(Book book, String format) {
    return Book(
      id: '',
      title: book.title,
      ageGroup: book.ageGroup,
      format: format,
      description: book.description,
      emoji: book.emoji,
      fileName: _createFileName(book.title, format),
      isDefault: true,
    );
  }

  static String _createFileName(String title, String format) {
    final extension = format == 'PDF' ? 'pdf' : 'docx';

    final cleanTitle = title
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    return '$cleanTitle.$extension';
  }
}