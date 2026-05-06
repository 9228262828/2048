import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: _PrivacyPolicyContent(),
      ),
    );
  }
}

class _PrivacyPolicyContent extends StatelessWidget {
  const _PrivacyPolicyContent();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Privacy Policy', style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('Last updated: May 2026', style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
        const SizedBox(height: 20),

        _section(
          context,
          '1. Introduction',
          'Welcome to 2048 Puzzle ("the App"). This Privacy Policy explains how we collect, '
          'use, and protect information when you use our application. By using 2048 Puzzle, '
          'you agree to the practices described in this policy.',
        ),

        _section(
          context,
          '2. Information We Collect',
          'We collect minimal information necessary to provide you with the best game experience:\n\n'
          '• Game Data: Your score, high score, number of games played, and game preferences '
          '(such as dark/light mode and sound settings) are stored locally on your device '
          'using Android shared preferences. This data never leaves your device.\n\n'
          '• No Personal Information: We do not collect your name, email address, phone number, '
          'location, or any other personally identifiable information.\n\n'
          '• No Account Required: The App does not require you to create an account or log in.',
        ),

        _section(
          context,
          '3. How We Use Information',
          'The data stored on your device is used solely to:\n\n'
          '• Save and restore your game progress\n'
          '• Track your high score across sessions\n'
          '• Remember your display preferences\n\n'
          'We do not use your data for advertising, analytics, or any commercial purpose.',
        ),

        _section(
          context,
          '4. Data Sharing',
          'We do not sell, trade, rent, or otherwise share any of your data with third parties. '
          'All game data remains on your device at all times. We have no ability to access '
          'the data stored on your device.',
        ),

        _section(
          context,
          '5. Third-Party Services',
          'The App uses the following open-source libraries:\n\n'
          '• Flutter SDK (Google) — UI framework\n'
          '• shared_preferences — local data storage\n\n'
          'These libraries do not independently collect personal data when used in offline mode. '
          'Please review Flutter\'s and Google\'s respective privacy policies for more information.',
        ),

        _section(
          context,
          '6. Permissions',
          'The App requests no special device permissions. It does not access your camera, '
          'microphone, contacts, location, or any other sensitive device feature.',
        ),

        _section(
          context,
          '7. Children\'s Privacy',
          'The App is suitable for all ages, including children under 13. We do not knowingly '
          'collect any personal information from children. Since no personal data is collected '
          'at all, the App complies with the Children\'s Online Privacy Protection Act (COPPA) '
          'and similar regulations.',
        ),

        _section(
          context,
          '8. Data Security',
          'All data is stored locally on your device using Android\'s built-in secure storage '
          'mechanisms. We implement reasonable technical measures to protect the integrity of '
          'locally stored data.',
        ),

        _section(
          context,
          '9. Your Rights',
          'You have full control over your data:\n\n'
          '• Delete: Uninstalling the App from your device removes all locally stored game data.\n'
          '• Reset: You can restart the game at any time, which resets your current session score.\n'
          '• Access: All data is stored locally; you can inspect it via Android app settings.',
        ),

        _section(
          context,
          '10. Changes to This Policy',
          'We may update this Privacy Policy from time to time. Any changes will be reflected '
          'with an updated date at the top of this page. Continued use of the App after changes '
          'constitutes acceptance of the updated policy.',
        ),

        _section(
          context,
          '11. Contact Us',
          'If you have any questions or concerns about this Privacy Policy, please contact us '
          'through the app\'s store listing page. You can also read the latest version of this '
          'policy online at: https://9228262828.github.io/2048/privacy.html',
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
