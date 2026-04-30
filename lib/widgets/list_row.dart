import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/tokens.dart';
import 'press.dart';

class ListRow extends StatelessWidget {
  final IconData? icon;
  final String? avatarSeed;
  final String label;
  final String? sublabel;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconBg;

  const ListRow({
    super.key,
    this.icon,
    this.avatarSeed,
    required this.label,
    this.sublabel,
    this.trailing,
    this.onTap,
    this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    Widget leading;
    if (avatarSeed != null) {
      leading = CircleAvatar(
        radius: 20,
        backgroundColor: c.accentDim,
        child: Text(avatarSeed![0],
            style: TextStyle(color: c.accent, fontWeight: FontWeight.w700)),
      );
    } else if (icon != null) {
      leading = Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconBg ?? c.glassHi,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, size: 17, color: c.fg2),
      );
    } else {
      leading = const SizedBox.shrink();
    }

    return Press(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: c.fg, height: 1.2)),
                  if (sublabel != null) ...[
                    const SizedBox(height: 2),
                    Text(sublabel!, style: TextStyle(fontSize: 12, color: c.fg2)),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class FDivider extends StatelessWidget {
  const FDivider({super.key});
  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: context.c.divider, margin: const EdgeInsets.symmetric(horizontal: 2));
}
