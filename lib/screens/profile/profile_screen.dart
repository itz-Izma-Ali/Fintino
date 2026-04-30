import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../widgets/glass.dart';
import '../../widgets/list_row.dart';
import '../../widgets/toggle_switch.dart';
import '../../widgets/top_bar.dart';
import '../common/placeholder_screen.dart';
import 'personal_details_screen.dart';
import 'security_screen.dart';
import 'notif_settings_screen.dart';
import 'language_screen.dart';
import 'help_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final state = context.watch<AppState>();
    final items = [
      _Item(Icons.person_outline_rounded, 'Personal details', 'Name, contact, address', () => _push(context, const PersonalDetailsScreen())),
      _Item(Icons.shield_outlined, 'Security & privacy', 'PIN, biometrics, devices', () => _push(context, const SecurityScreen())),
      _Item(Icons.notifications_outlined, 'Notifications', 'Push, email, alerts', () => _push(context, const NotifSettingsScreen())),
      _Item(Icons.credit_card, 'Cards & payments', 'Manage cards & limits', () => _push(context, const PlaceholderScreen(
        title: 'Cards & payments',
        subtitle: '4 cards · 2 payment methods',
        icon: Icons.credit_card,
        description: 'Manage your physical, virtual, and external cards plus saved payment methods.',
        bullets: [
          (icon: Icons.credit_card, label: '4 active cards'),
          (icon: Icons.account_balance, label: 'Linked bank: Chase ••0192'),
          (icon: Icons.qr_code_2, label: 'Apple Pay & Google Pay enabled'),
          (icon: Icons.history, label: 'View transaction history'),
        ],
        primaryActionLabel: 'Manage methods',
      ))),
      _Item(Icons.language_rounded, 'Language', 'English', () => _push(context, const LanguageScreen())),
      _Item(Icons.help_outline, 'Help center', 'Get support', () => _push(context, const HelpScreen())),
    ];

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 140),
      children: [
        const FintinoTopBar(title: 'Profile'),
        // Identity card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [c.glassHi, c.glass],
              ),
              borderRadius: BorderRadius.circular(FT.rLg),
              border: Border.all(color: c.border),
              boxShadow: [
                BoxShadow(color: c.accentGlow.withOpacity(0.4), blurRadius: 32, offset: const Offset(0, 12)),
              ],
            ),
            child: Column(
              children: [
                // Gradient ring avatar
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(colors: [c.accent, c.accentGold, c.positive, c.accent]),
                    boxShadow: [BoxShadow(color: c.accentGlow, blurRadius: 24)],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(color: c.bg, shape: BoxShape.circle),
                    child: Container(
                      width: 86, height: 86,
                      decoration: BoxDecoration(color: c.accentDim, shape: BoxShape.circle),
                      child: Icon(Icons.person, size: 56, color: c.accent),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text('Tino Well', style: FTType.h2(context)),
                const SizedBox(height: 4),
                Text('tino@aperture.bank', style: FTType.small(context).copyWith(color: c.fg2)),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Chip(icon: Icons.workspace_premium_rounded, label: 'Premium', accent: true),
                    const SizedBox(width: 8),
                    _Chip(icon: Icons.verified_rounded, label: 'Verified'),
                  ],
                ),
                const SizedBox(height: 18),
                // Stats row
                Row(
                  children: [
                    _StatPill(label: 'Member', value: '2y 3mo'),
                    _StatDivider(),
                    _StatPill(label: 'Cards', value: '4'),
                    _StatDivider(),
                    _StatPill(label: 'Score', value: '821'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Glass(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: state.isDark
                          ? [const Color(0xFF1C2B3A), c.accent]
                          : [c.accentGold, c.accent],
                    ),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(state.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Appearance',
                          style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: c.fg)),
                      const SizedBox(height: 2),
                      Text(state.isDark ? 'Dark mode' : 'Light mode',
                          style: TextStyle(fontSize: 12, color: c.fg2)),
                    ],
                  ),
                ),
                FintinoToggle(on: state.isDark, onChanged: (_) => state.toggleTheme()),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Glass(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  _SettingRow(item: items[i]),
                  if (i < items.length - 1) const FDivider(),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text('Fintino · v1.0.0',
              style: TextStyle(fontSize: 11, color: c.fg3, letterSpacing: 0.4)),
        ),
      ],
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class _Item {
  final IconData icon;
  final String label;
  final String sub;
  final VoidCallback onTap;
  _Item(this.icon, this.label, this.sub, this.onTap);
}

class _SettingRow extends StatelessWidget {
  final _Item item;
  const _SettingRow({required this.item});
  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: c.glassHi,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: c.border),
            ),
            child: Icon(item.icon, color: c.fg2, size: 17),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label,
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: c.fg)),
                const SizedBox(height: 2),
                Text(item.sub, style: TextStyle(fontSize: 12, color: c.fg2)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 18, color: c.fg3),
        ]),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool accent;
  const _Chip({required this.icon, required this.label, this.accent = false});
  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: accent
            ? LinearGradient(colors: [c.accent.withOpacity(0.32), c.accentGold.withOpacity(0.22)])
            : null,
        color: accent ? null : c.glassHi,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent ? c.accentGold.withOpacity(0.6) : c.border),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: accent ? c.accentGold : c.fg2),
        const SizedBox(width: 6),
        Text(label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: accent ? c.accentGold : c.fg)),
      ]),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  const _StatPill({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: c.fg,
                fontFeatures: const [FontFeature.tabularFigures()],
              )),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: c.fg3,
              )),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 28, color: context.c.divider);
}
