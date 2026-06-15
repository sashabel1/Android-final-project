import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_service.dart';
import '../theme/app_theme.dart';
import '../widgets/book_card.dart';

class BooksScreen extends StatelessWidget {
  final String format;
  final String ageGroup;

  const BooksScreen({
    super.key,
    required this.format,
    required this.ageGroup,
  });

  Future<void> _openAddBookDialog(BuildContext context) async {
    final wasAdded = await showDialog<bool>(
      context: context,
      builder: (_) => AddBookDialog(
        format: format,
        ageGroup: ageGroup,
      ),
    );

    if (wasAdded == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book added successfully!'),
        ),
      );
    }
  }

  void _showDownloadDemo(BuildContext context, Book book) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Demo download: ${book.fileName}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookService = BookService();

    return Scaffold(
      appBar: AppBar(
        title: Text('$format | Ages $ageGroup'),
        actions: [
          IconButton(
            onPressed: () => _openAddBookDialog(context),
            icon: const Icon(Icons.upload_file),
            tooltip: 'Upload book',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddBookDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Upload Book'),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.cream,
                AppTheme.green,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: StreamBuilder<List<Book>>(
            stream: bookService.watchBooksByCategory(
              ageGroup: ageGroup,
              format: format,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Failed to load books:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final books = snapshot.data ?? [];

              if (books.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'No books yet 📚',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _openAddBookDialog(context),
                          icon: const Icon(Icons.add),
                          label: const Text('Add first book'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    'Books for Ages $ageGroup',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$format books',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 18),
                  ...books.map(
                        (book) => BookCard(
                      book: book,
                      onDownload: () => _showDownloadDemo(context, book),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class AddBookDialog extends StatefulWidget {
  final String format;
  final String ageGroup;

  const AddBookDialog({
    super.key,
    required this.format,
    required this.ageGroup,
  });

  @override
  State<AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<AddBookDialog> {
  final BookService _bookService = BookService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _fileName;
  bool _isSaving = false;

  void _chooseDemoFile() {
    final extension = widget.format == 'PDF' ? 'pdf' : 'docx';

    final title = _titleController.text.trim().isEmpty
        ? 'new_book'
        : _titleController.text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    setState(() {
      _fileName = '$title.$extension';
    });
  }

  Future<void> _saveBook() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      _showMessage('Please fill in the book title and description');
      return;
    }

    if (_fileName == null) {
      _showMessage('Please choose a demo file');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _bookService.addBook(
        title: title,
        ageGroup: widget.ageGroup,
        format: widget.format,
        description: description,
        fileName: _fileName!,
      );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      _showMessage('Failed to add book: $error');
    }

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.cream,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      title: Text(
        'Upload ${widget.format} Book',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ages ${widget.ageGroup}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkText,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Book title',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Book description',
                prefixIcon: Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _chooseDemoFile,
              icon: const Icon(Icons.attach_file),
              label: const Text('Choose file demo'),
            ),
            const SizedBox(height: 8),
            Text(
              _fileName == null
                  ? 'No demo file selected'
                  : 'Selected: $_fileName',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveBook,
          child: _isSaving
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Add Book'),
        ),
      ],
    );
  }
}