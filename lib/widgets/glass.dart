import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/theme/tokens.dart';

/// Adaptive container — frosted blur on dark themes, solid card with subtle
/// shadow on light themes. Same API.
class Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  final bool hi;
  final VoidCallback? onTap;
  final BoxConstraints? constraints;

  const Glass({
    super.key,
    required this.child,
    this.padding,
    this.radius = FT.rMd,
    this.hi = false,
    this.onTap,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radiusObj = BorderRadius.circular(radius);

    final container = Container(
      padding: padding,
      constraints: constraints,
      decoration: BoxDecoration(
        color: hi ? c.glassHi : c.glass,
        borderRadius: radiusObj,
        border: Border.all(color: c.border, width: 1),
        boxShadow: isDark
            ? const [
                BoxShadow(color: Color(0x38000000), blurRadius: 28, offset: Offset(0, 6)),
              ]
            : [
                // Soft, paper-like elevation on light theme
                BoxShadow(
                  color: const Color(0xFF1A1F2C).withOpacity(0.04),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
                BoxShadow(
                  color: const Color(0xFF1A1F2C).withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: child,
    );

    final box = isDark
        ? ClipRRect(
            borderRadius: radiusObj,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: container,
            ),
          )
        : container;

    if (onTap == null) return box;
    return Material(
      color: Colors.transparent,
      child: InkWell(borderRadius: radiusObj, onTap: onTap, child: box),
    );
  }
}
