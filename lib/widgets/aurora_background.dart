import 'package:flutter/material.dart';
import '../core/theme/tokens.dart';

/// Adaptive aurora — atmospheric on dark, soft warm wash on light.
class AuroraBackground extends StatelessWidget {
  final Widget child;
  final Alignment primaryGlow;
  final Alignment secondaryGlow;
  const AuroraBackground({
    super.key,
    required this.child,
    this.primaryGlow = const Alignment(0.9, 0.95),
    this.secondaryGlow = const Alignment(-0.85, -0.9),
  });

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Positioned.fill(child: ColoredBox(color: c.bg)),
        // Primary glow — strong on dark, very soft on light
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: primaryGlow,
                radius: isDark ? 0.95 : 1.1,
                colors: [
                  c.accent.withOpacity(isDark ? 0.18 : 0.06),
                  c.accent.withOpacity(0),
                ],
                stops: const [0, 1],
              ),
            ),
          ),
        ),
        // Secondary gold glow
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: secondaryGlow,
                radius: isDark ? 0.85 : 1.0,
                colors: [
                  c.accentGold.withOpacity(isDark ? 0.08 : 0.10),
                  c.accentGold.withOpacity(0),
                ],
                stops: const [0, 1],
              ),
            ),
          ),
        ),
        // Top vignette — only on dark for hero focus
        if (isDark)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: const Alignment(0, -0.2),
                  colors: [Colors.black.withOpacity(0.18), Colors.transparent],
                ),
              ),
            ),
          ),
        Positioned.fill(child: child),
      ],
    );
  }
}
