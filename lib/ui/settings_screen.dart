import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set up quick capture')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _Step(
            icon: Icons.lock_outline,
            title: 'Lock Screen',
            body: 'Long-press the Lock Screen, tap Customize > Lock Screen, tap a control slot at the '
                'bottom and pick Red Panda > Text note or Voice note.',
          ),
          _Step(
            icon: Icons.tune,
            title: 'Control Center',
            body: 'Open Control Center, tap +, Add a Control, search "Red Panda".',
          ),
          _Step(
            icon: Icons.radio_button_checked,
            title: 'Action Button',
            body: 'Settings > Action Button > Controls, then choose Red Panda > Text note or Voice note.',
          ),
          _Step(
            icon: Icons.record_voice_over_outlined,
            title: 'Siri',
            body: 'Say "Note with Red Panda" or "Voice note with Red Panda".',
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(leading: Icon(icon), title: Text(title), subtitle: Text(body)),
      );
}
