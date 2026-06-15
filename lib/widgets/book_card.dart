import 'package:flutter/material.dart';

import '../models/book.dart';
import '../theme/app_theme.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onDownload;

  const BookCard({
    super.key,
    required this.book,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final sourceLabel = book.isDefault ? 'Default book' : 'Uploaded by you';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            book.emoji,
            style: const TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            book.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              Chip(
                label: Text('${book.format} | Ages ${book.ageGroup}'),
                backgroundColor: AppTheme.yellow,
              ),
              Chip(
                label: Text(sourceLabel),
                backgroundColor: AppTheme.green,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'File: ${book.fileName}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onDownload,
              icon: const Icon(Icons.download),
              label: const Text('Download'),
            ),
          ),
        ],
      ),
    );
  }
}