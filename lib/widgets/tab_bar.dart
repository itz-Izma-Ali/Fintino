import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/state/app_state.dart';
import '../core/theme/tokens.dart';
import 'press.dart';

class FintinoTabBar extends StatelessWidget {
  const FintinoTabBar({super.key});

  static const _items = [
    _TabItem('Home', Icons.home_rounded, Icons.home_outlined),
    _TabItem('Wallet', Icons.credit_card, Icons.credit_card_outlined),
    _TabItem('Stats', Icons.bar_chart_rounded, Icons.bar_chart_outlined),
    _TabItem('Profile', Icons.person_rounded, Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final state = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final container = Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? c.glass : c.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: c.border),
        boxShadow: isDark
            ? [BoxShadow(color: Colors.black.withOpacity(0.32), blurRadius: 24, offset: const Offset(0, 10))]
            : [
                BoxShadow(
                  color: const Color(0xFF1A1F2C).withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: const Color(0xFF1A1F2C).withOpacity(0.10),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
              ],
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final on = state.tabIndex == i;
          final it = _items[i];
          return Expanded(
            child: Press(
              onTap: () => state.setTab(i),
              child: AnimatedContainer(
                duration: FT.durNormal,
                curve: FT.easeOut,
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: on ? c.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: on
                      ? [BoxShadow(color: c.accentGlow, blurRadius: 18, offset: const Offset(0, 5))]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: FT.durFast,
                      transitionBuilder: (child, anim) =>
                          ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        on ? it.iconActive : it.iconInactive,
                        key: ValueKey(on),
                        size: 21,
                        color: on ? Colors.white : c.fg2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    AnimatedDefaultTextStyle(
                      duration: FT.durNormal,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                        letterSpacing: 0.2,
                        color: on ? Colors.white : c.fg3,
                      ),
                      child: Text(it.label),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: isDark
            ? BackdropFilter(filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26), child: container)
            : container,
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData iconActive;
  final IconData iconInactive;
  const _TabItem(this.label, this.iconActive, this.iconInactive);
}
