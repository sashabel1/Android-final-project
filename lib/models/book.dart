import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String ageGroup;
  final String format;
  final String description;
  final String emoji;
  final String fileName;
  final bool isDefault;

  const Book({
    required this.id,
    required this.title,
    required this.ageGroup,
    required this.format,
    required this.description,
    required this.emoji,
    required this.fileName,
    required this.isDefault,
  });

  factory Book.fromDocument(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data() ?? {};

    return Book(
      id: document.id,
      title: data['title'] ?? '',
      ageGroup: data['ageGroup'] ?? '',
      format: data['format'] ?? '',
      description: data['description'] ?? '',
      emoji: data['emoji'] ?? '📚',
      fileName: data['fileName'] ?? '',
      isDefault: data['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toMap({required String ownerId}) {
    return {
      'ownerId': ownerId,
      'title': title,
      'ageGroup': ageGroup,
      'format': format,
      'description': description,
      'emoji': emoji,
      'fileName': fileName,
      'isDefault': isDefault,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}