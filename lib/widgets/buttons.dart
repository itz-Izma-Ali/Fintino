import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/tokens.dart';
import 'press.dart';

/// Pill-shaped primary button (solid / ghost / danger).
class Btn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool ghost;
  final bool danger;
  final bool full;

  const Btn({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.ghost = false,
    this.danger = false,
    this.full = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = danger ? c.negative : c.accent;
    final fgColor = ghost ? c.fg : Colors.white;

    final inner = Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
      decoration: ghost
          ? BoxDecoration(
              color: isDark ? c.glass : c.surface,
              borderRadius: BorderRadius.circular(FT.rPill),
              border: Border.all(color: c.border),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: const Color(0xFF1A1F2C).withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            )
          : BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(FT.rPill),
              boxShadow: [
                BoxShadow(color: c.accentGlow, blurRadius: 20, offset: const Offset(0, 4)),
                if (!isDark)
                  BoxShadow(color: bg.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
      child: Row(
        mainAxisSize: full ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 17, color: fgColor),
            const SizedBox(width: 8),
          ],
          Text(label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.16,
                color: fgColor,
              )),
        ],
      ),
    );

    final wrapped = ghost && isDark
        ? ClipRRect(
            borderRadius: BorderRadius.circular(FT.rPill),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: inner,
            ),
          )
        : inner;

    return Press(onTap: onTap, child: full ? SizedBox(width: double.infinity, child: wrapped) : wrapped);
  }
}

/// Round 40x40 icon button — frosted on dark, solid on light.
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool accent;
  final double size;
  const GlassIconButton({super.key, required this.icon, this.onTap, this.accent = false, this.size = 40});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final container = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: accent ? c.accentDim : (isDark ? c.glass : c.surface),
        shape: BoxShape.circle,
        border: Border.all(color: accent ? c.accent : c.border),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF1A1F2C).withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Icon(icon, size: 18, color: accent ? c.accent : c.fg),
    );
    return Press(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: isDark
            ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16), child: container)
            : container,
      ),
    );
  }
}
