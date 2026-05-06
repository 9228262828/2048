import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: _TermsContent(),
      ),
    );
  }
}

class _TermsContent extends StatelessWidget {
  const _TermsContent();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Terms of Service', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Last updated: May 2026', style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
        const SizedBox(height: 20),

        _section(
          context,
          '1. Acceptance of Terms',
          'By downloading, installing, or using the 2048 Puzzle application ("the App"), '
          'you agree to be bound by these Terms of Service ("Terms"). If you do not agree '
          'to these Terms, please do not use the App.',
        ),

        _section(
          context,
          '2. License to Use',
          'We grant you a limited, non-exclusive, non-transferable, revocable license to '
          'use the App for your personal, non-commercial entertainment purposes on Android '
          'devices that you own or control, subject to these Terms.',
        ),

        _section(
          context,
          '3. Restrictions',
          'You agree not to:\n\n'
          '• Reverse engineer, decompile, or disassemble any portion of the App\n'
          '• Modify, adapt, or create derivative works based on the App\n'
          '• Use the App for any unlawful purpose or in violation of any regulations\n'
          '• Attempt to gain unauthorized access to any part of the App or its systems\n'
          '• Remove or alter any proprietary notices or labels on the App',
        ),

        _section(
          context,
          '4. Intellectual Property',
          'The App, including its concept, design, code, graphics, and content, is owned '
          'by us and is protected by applicable intellectual property laws. The 2048 game '
          'concept was originally created by Gabriele Cirulli and is used under the MIT '
          'License. All other elements of the App are our original work.',
        ),

        _section(
          context,
          '5. Game Content',
          '2048 Puzzle is a single-player puzzle game. The goal is to slide numbered tiles '
          'on a 4×4 grid to combine them and create a tile with the number 2048. High scores '
          'and game statistics are stored locally on your device and are not shared with us '
          'or any third party.',
        ),

        _section(
          context,
          '6. Disclaimer of Warranties',
          'THE APP IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, '
          'EITHER EXPRESS OR IMPLIED. WE DISCLAIM ALL WARRANTIES, INCLUDING BUT NOT LIMITED '
          'TO IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND '
          'NON-INFRINGEMENT.\n\n'
          'We do not warrant that the App will be uninterrupted, error-free, or free of '
          'viruses or other harmful components.',
        ),

        _section(
          context,
          '7. Limitation of Liability',
          'TO THE FULLEST EXTENT PERMITTED BY APPLICABLE LAW, WE SHALL NOT BE LIABLE FOR '
          'ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, INCLUDING '
          'BUT NOT LIMITED TO LOSS OF DATA, LOSS OF PROFITS, OR LOSS OF GOODWILL, ARISING '
          'OUT OF OR RELATED TO YOUR USE OF THE APP.',
        ),

        _section(
          context,
          '8. Changes to the App',
          'We reserve the right to modify, suspend, or discontinue the App (or any part of '
          'it) at any time, with or without notice. We shall not be liable to you or any '
          'third party for any such modification, suspension, or discontinuation.',
        ),

        _section(
          context,
          '9. Updates to Terms',
          'We may revise these Terms at any time. The most current version will always be '
          'available within the App. By continuing to use the App after changes take effect, '
          'you agree to be bound by the revised Terms.',
        ),

        _section(
          context,
          '10. Governing Law',
          'These Terms shall be governed by and construed in accordance with applicable laws. '
          'Any disputes arising under these Terms shall be subject to the exclusive jurisdiction '
          'of the appropriate courts.',
        ),

        _section(
          context,
          '11. Contact',
          'If you have any questions about these Terms of Service, please contact us through '
          'the App\'s store listing page or support channel.',
        ),

        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 12),
        Center(
          child: Text(
            '© 2026 2048 Puzzle. All rights reserved.',
            style: textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _section(BuildContext context, String title, String body) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(body, style: textTheme.bodyMedium?.copyWith(height: 1.6)),
        ],
      ),
    );
  }
}
