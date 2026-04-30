import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/feedback.dart';
import '../../widgets/glass.dart';
import '../../widgets/list_row.dart';
import '../../widgets/toggle_switch.dart';
import '../../widgets/top_bar.dart';

class NotifSettingsScreen extends StatefulWidget {
  const NotifSettingsScreen({super.key});
  @override
  State<NotifSettingsScreen> createState() => _NotifSettingsScreenState();
}

class _NotifSettingsScreenState extends State<NotifSettingsScreen> {
  bool push = true, email = true, txn = true, sec = true;

  void _toggle(String label, bool v, void Function(bool) set) {
    setState(() => set(v));
    showFeedback(context, '$label ${v ? 'on' : 'off'}',
        icon: v ? Icons.notifications_active : Icons.notifications_off_outlined);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              const FintinoTopBar(title: 'Notifications'),
              _section(context, 'Channels', [
                ListRow(icon: Icons.smartphone, label: 'Push notifications',
                    trailing: FintinoToggle(on: push, onChanged: (v) => _toggle('Push', v, (x) => push = x))),
                const FDivider(),
                ListRow(icon: Icons.mail_outline, label: 'Email notifications',
                    trailing: FintinoToggle(on: email, onChanged: (v) => _toggle('Email', v, (x) => email = x))),
              ]),
              _section(context, 'Notifications', [
                ListRow(icon: Icons.send, label: 'Transactions', sublabel: 'Sent, received, pending',
                    trailing: FintinoToggle(on: txn, onChanged: (v) => _toggle('Transactions', v, (x) => txn = x))),
                const FDivider(),
                ListRow(icon: Icons.shield_outlined, label: 'Security & alerts', sublabel: 'Login attempts, changes',
                    trailing: FintinoToggle(on: sec, onChanged: (v) => _toggle('Security alerts', v, (x) => sec = x))),
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
