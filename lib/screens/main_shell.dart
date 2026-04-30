import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/state/app_state.dart';
import '../widgets/aurora_background.dart';
import '../widgets/tab_bar.dart';
import 'home/home_screen.dart';
import 'wallet/wallet_screen.dart';
import 'stats/stats_screen.dart';
import 'profile/profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    const screens = [HomeScreen(), WalletScreen(), StatsScreen(), ProfileScreen()];
    return Scaffold(
      extendBody: true,
      body: AuroraBackground(
        child: SafeArea(
          bottom: false,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOut,
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween(begin: const Offset(0, 0.02), end: Offset.zero).animate(anim),
                child: child,
              ),
            ),
            child: KeyedSubtree(
              key: ValueKey(state.tabIndex),
              child: screens[state.tabIndex],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: const Padding(
          padding: EdgeInsets.only(bottom: 12, top: 4),
          child: FintinoTabBar(),
        ),
      ),
    );
  }
}
