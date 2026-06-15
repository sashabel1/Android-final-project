import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/demo_books.dart';
import '../models/book.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No logged in user');
    }

    return user.uid;
  }

  DocumentReference<Map<String, dynamic>> get _userDocument {
    return _firestore.collection('users').doc(_uid);
  }

  CollectionReference<Map<String, dynamic>> get _booksCollection {
    return _userDocument.collection('books');
  }

  Future<void> ensureUserDataExists() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final userSnapshot = await _userDocument.get();

    if (!userSnapshot.exists) {
      await _userDocument.set({
        'uid': user.uid,
        'email': user.email,
        'name': user.displayName ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await _userDocument.set(
        {
          'email': user.email,
          'name': user.displayName ?? '',
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }

    final booksSnapshot = await _booksCollection.limit(1).get();

    if (booksSnapshot.docs.isNotEmpty) {
      return;
    }

    final batch = _firestore.batch();
    final defaultBooks = DemoBooks.defaultBooks();

    for (final book in defaultBooks) {
      final bookDocument = _booksCollection.doc();
      batch.set(bookDocument, book.toMap(ownerId: user.uid));
    }

    await batch.commit();
  }

  Stream<List<Book>> watchBooksByCategory({
    required String ageGroup,
    required String format,
  }) {
    return _booksCollection
        .where('ageGroup', isEqualTo: ageGroup)
        .where('format', isEqualTo: format)
        .snapshots()
        .map((snapshot) {
      final books = snapshot.docs.map(Book.fromDocument).toList();

      books.sort((first, second) {
        if (first.isDefault != second.isDefault) {
          return first.isDefault ? -1 : 1;
        }

        return first.title.compareTo(second.title);
      });

      return books;
    });
  }

  Future<void> addBook({
    required String title,
    required String ageGroup,
    required String format,
    required String description,
    required String fileName,
    required String emoji,
  }) async {
    final book = Book(
      id: '',
      title: title,
      ageGroup: ageGroup,
      format: format,
      description: description,
      emoji: emoji.trim().isEmpty ? '📚' : emoji.trim(),
      fileName: fileName,
      isDefault: false,
    );

    await _booksCollection.add(book.toMap(ownerId: _uid));
  }

  Future<void> deleteBook(Book book) async {
    if (book.isDefault) {
      throw Exception('Default books cannot be deleted');
    }

    await _booksCollection.doc(book.id).delete();
  }
}