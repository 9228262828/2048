import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFEDC22E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  '2048',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '2048 Puzzle',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildInfoCard(
              context,
              title: 'How to Play',
              content:
                  'Swipe in any direction to slide all tiles on the board. '
                  'When two tiles with the same number collide, they merge into one tile '
                  'with their combined value. Your goal is to create a tile with the number 2048!\n\n'
                  'Tip: Keep your highest tile in a corner and build rows from there.',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Features',
              content:
                  '• Smooth swipe controls\n'
                  '• Persistent high score across sessions\n'
                  '• Dark / Light mode\n'
                  '• Win detection with option to keep going\n'
                  '• Game statistics (moves, merges)',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              title: 'Credits',
              content:
                  'The 2048 game concept was originally created by Gabriele Cirulli '
                  'and released under the MIT License.\n\n'
                  'This Flutter implementation is built with ❤️ using the Flutter SDK by Google.',
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              icon: const Icon(Icons.privacy_tip_outlined),
              label: const Text('Privacy Policy'),
              onPressed: () => Navigator.pushNamed(context, '/privacy'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.description_outlined),
              label: const Text('Terms of Service'),
              onPressed: () => Navigator.pushNamed(context, '/terms'),
            ),
            const SizedBox(height: 32),
            Text(
              '© 2026 2048 Puzzle. All rights reserved.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required String content}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
