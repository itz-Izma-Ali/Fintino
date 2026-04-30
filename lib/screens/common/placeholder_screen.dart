import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/buttons.dart';
import '../../widgets/glass.dart';
import '../../widgets/top_bar.dart';

/// Generic stub screen used for routes that don't yet have a full
/// implementation but should still feel like real destinations.
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String description;
  final String? primaryActionLabel;
  final VoidCallback? onPrimary;
  final List<({IconData icon, String label})> bullets;

  const PlaceholderScreen({
    super.key,
    required this.title,
    this.subtitle = '',
    this.icon = Icons.construction_rounded,
    this.description = '',
    this.primaryActionLabel,
    this.onPrimary,
    this.bullets = const [],
  });

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              FintinoTopBar(title: title, subtitle: subtitle.isEmpty ? null : subtitle),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 96, height: 96,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [c.accent, c.accent.withOpacity(0.55)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: c.accentGlow, blurRadius: 28, offset: const Offset(0, 10))],
                  ),
                  child: Icon(icon, size: 44, color: Colors.white),
                ),
              ),
              const SizedBox(height: 28),
              if (description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(description,
                      textAlign: TextAlign.center, style: FTType.body(context)),
                ),
              if (bullets.isNotEmpty) ...[
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Glass(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        for (final b in bullets)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                    color: c.accentDim, borderRadius: BorderRadius.circular(10)),
                                child: Icon(b.icon, color: c.accent, size: 17),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(b.label, style: FTType.small(context))),
                            ]),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
              if (primaryActionLabel != null) ...[
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Btn(label: primaryActionLabel!, full: true, onTap: onPrimary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
