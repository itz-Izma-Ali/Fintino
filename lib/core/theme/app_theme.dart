import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tokens.dart';

class AppTheme {
  static ThemeData _build(FintinoColors c, Brightness brightness) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);
    final txt = GoogleFonts.dmSansTextTheme(base.textTheme).apply(
      bodyColor: c.fg,
      displayColor: c.fg,
    );
    return base.copyWith(
      brightness: brightness,
      scaffoldBackgroundColor: c.bg,
      canvasColor: c.bg,
      colorScheme: base.colorScheme.copyWith(
        primary: c.accent,
        secondary: c.accentGold,
        surface: c.surface,
        error: c.negative,
      ),
      textTheme: txt,
      splashFactory: InkSparkle.splashFactory,
      extensions: [c],
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: _SlideFadeTransitions(),
        TargetPlatform.iOS: _SlideFadeTransitions(),
        TargetPlatform.linux: _SlideFadeTransitions(),
        TargetPlatform.macOS: _SlideFadeTransitions(),
        TargetPlatform.windows: _SlideFadeTransitions(),
      }),
    );
  }

  static ThemeData dark() => _build(FintinoColors.dark, Brightness.dark);
  static ThemeData light() => _build(FintinoColors.light, Brightness.light);
}

class _SlideFadeTransitions extends PageTransitionsBuilder {
  const _SlideFadeTransitions();
  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context,
      Animation<double> animation, Animation<double> secondary, Widget child) {
    final curved = CurvedAnimation(parent: animation, curve: FT.easeOut);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(begin: const Offset(0.06, 0), end: Offset.zero).animate(curved),
        child: child,
      ),
    );
  }
}

/// Type-style helpers, mirrored from tokens.css typography utilities.
class FTType {
  static TextStyle label(BuildContext ctx) => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.32,
        color: ctx.c.fg3,
      );
  static TextStyle body(BuildContext ctx) => TextStyle(
        fontSize: 15,
        height: 1.5,
        color: ctx.c.fg2,
      );
  static TextStyle small(BuildContext ctx) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: ctx.c.fg,
      );
  static TextStyle h3(BuildContext ctx) => TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.255,
        color: ctx.c.fg,
        height: 1.1,
      );
  static TextStyle h2(BuildContext ctx) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.36,
        color: ctx.c.fg,
        height: 1.1,
      );
  static TextStyle h1(BuildContext ctx) => TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        color: ctx.c.fg,
        height: 1.1,
      );
}
