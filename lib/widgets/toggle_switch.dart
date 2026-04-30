import 'package:flutter/material.dart';
import '../core/theme/tokens.dart';

class FintinoToggle extends StatelessWidget {
  final bool on;
  final ValueChanged<bool> onChanged;
  const FintinoToggle({super.key, required this.on, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return GestureDetector(
      onTap: () => onChanged(!on),
      child: AnimatedContainer(
        duration: FT.durNormal,
        curve: FT.easeOut,
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: on ? c.accent : c.glassHi,
          borderRadius: BorderRadius.circular(999),
          boxShadow: on
              ? [BoxShadow(color: c.accentGlow, blurRadius: 14)]
              : const [],
        ),
        child: AnimatedAlign(
          alignment: on ? Alignment.centerRight : Alignment.centerLeft,
          duration: FT.durNormal,
          curve: FT.easeSp,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: c.fg,
              shape: BoxShape.circle,
              boxShadow: const [BoxShadow(color: Color(0x4D000000), blurRadius: 6, offset: Offset(0, 2))],
            ),
          ),
        ),
      ),
    );
  }
}
