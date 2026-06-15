import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/category_card.dart';
import 'books_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openBooksScreen({
    required BuildContext context,
    required String format,
    required String ageGroup,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BooksScreen(
          format: format,
          ageGroup: ageGroup,
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await AuthService().logout();
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'format': 'WORD',
        'age': '0-4',
        'color': AppTheme.blue,
        'icon': Icons.description,
      },
      {
        'format': 'PDF',
        'age': '0-4',
        'color': AppTheme.pink,
        'icon': Icons.picture_as_pdf,
      },
      {
        'format': 'WORD',
        'age': '4-8',
        'color': AppTheme.green,
        'icon': Icons.description,
      },
      {
        'format': 'PDF',
        'age': '4-8',
        'color': AppTheme.purple,
        'icon': Icons.picture_as_pdf,
      },
      {
        'format': 'WORD',
        'age': '8-12',
        'color': AppTheme.yellow,
        'icon': Icons.description,
      },
      {
        'format': 'PDF',
        'age': '8-12',
        'color': Colors.orange,
        'icon': Icons.picture_as_pdf,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Children Books'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.cream,
                AppTheme.blue,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  'Choose your child’s age:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pick a file type and age group',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 17),
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return CategoryCard(
                        format: category['format'] as String,
                        ageGroup: category['age'] as String,
                        color: category['color'] as Color,
                        icon: category['icon'] as IconData,
                        onTap: () {
                          _openBooksScreen(
                            context: context,
                            format: category['format'] as String,
                            ageGroup: category['age'] as String,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}