import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/feedback.dart';
import '../../widgets/glass.dart';
import '../../widgets/list_row.dart';
import '../../widgets/toggle_switch.dart';
import '../../widgets/top_bar.dart';
import '../common/placeholder_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});
  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _bio = true;
  bool _pin = true;
  bool _alerts = true;

  void _onBio(bool v) {
    setState(() => _bio = v);
    showFeedback(context, v ? 'Biometric login enabled' : 'Biometric login disabled',
        icon: Icons.fingerprint);
  }

  void _onPin(bool v) {
    setState(() => _pin = v);
    showFeedback(context, v ? 'PIN protection on' : 'PIN protection off',
        icon: Icons.shield_outlined);
  }

  void _onAlerts(bool v) {
    setState(() => _alerts = v);
    showFeedback(context, v ? 'Unusual-activity alerts on' : 'Unusual-activity alerts off',
        icon: Icons.notifications_active_outlined);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;

    void push(Widget page) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              const FintinoTopBar(title: 'Security & privacy'),
              _section(context, 'Authentication', [
                ListRow(icon: Icons.fingerprint, label: 'Biometric login',
                    trailing: FintinoToggle(on: _bio, onChanged: _onBio)),
                const FDivider(),
                ListRow(icon: Icons.shield_outlined, label: 'PIN protection',
                    trailing: FintinoToggle(on: _pin, onChanged: _onPin)),
              ]),
              _section(context, 'Security alerts', [
                ListRow(icon: Icons.notifications_active_outlined, label: 'Unusual activity',
                    trailing: FintinoToggle(on: _alerts, onChanged: _onAlerts)),
              ]),
              _section(context, 'Account', [
                ListRow(
                  icon: Icons.key_outlined,
                  label: 'Change password',
                  sublabel: 'Updated 3 days ago',
                  onTap: () => push(const PlaceholderScreen(
                    title: 'Change password',
                    icon: Icons.key_rounded,
                    description: 'For your security, enter your current password followed by a new one.',
                    bullets: [
                      (icon: Icons.lock_outline, label: 'Min 12 chars · 1 number · 1 symbol'),
                      (icon: Icons.shield_rounded, label: 'You\'ll be signed out everywhere'),
                    ],
                    primaryActionLabel: 'Continue',
                  )),
                  trailing: Icon(Icons.chevron_right, size: 16, color: c.fg3),
                ),
                const FDivider(),
                ListRow(
                  icon: Icons.lock_outline,
                  label: 'Linked devices',
                  sublabel: '2 devices',
                  onTap: () => push(const PlaceholderScreen(
                    title: 'Linked devices',
                    subtitle: '2 active sessions',
                    icon: Icons.devices_rounded,
                    description: 'These devices are signed in to your Fintino account. Revoke any you no longer use.',
                    bullets: [
                      (icon: Icons.smartphone, label: 'iPhone 15 · San Francisco · this device'),
                      (icon: Icons.laptop_mac, label: 'MacBook Pro · last active 2h ago'),
                    ],
                    primaryActionLabel: 'Sign out all other devices',
                  )),
                  trailing: Icon(Icons.chevron_right, size: 16, color: c.fg3),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 12),
            child: Text(title, style: FTType.label(context)),
          ),
          Glass(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(children: items),
          ),
        ],
      ),
    );
  }
}
