import 'package:flutter/material.dart';

/// Fintino "Warm Slate" design tokens — mirrored from tokens.css.
class FT {
  // Brand
  static const primary = Color(0xFF1C2B3A);
  static const primaryGreen = Color(0xFF2E7D52);
  static const secondaryGreen = Color(0xFF4CAF7A);
  static const accentGold = Color(0xFFC9A84C);

  // Spacing
  static const sp2xs = 2.0;
  static const spXs = 4.0;
  static const spSm = 8.0;
  static const spMd = 12.0;
  static const spLg = 16.0;
  static const spXl = 20.0;
  static const spXxl = 24.0;
  static const spXxxl = 32.0;
  static const sp4xl = 40.0;
  static const sp5xl = 48.0;

  // Radius
  static const rSm = 12.0;
  static const rMd = 16.0;
  static const rLg = 24.0;
  static const rXl = 32.0;
  static const rPill = 999.0;

  // Durations
  static const durFast = Duration(milliseconds: 140);
  static const durNormal = Duration(milliseconds: 220);
  static const durSlow = Duration(milliseconds: 300);
  static const durSlower = Duration(milliseconds: 600);

  // Easing
  static const easeOut = Cubic(0.2, 0.8, 0.2, 1);
  static const easeSp = Cubic(0.34, 1.56, 0.64, 1);
  static const easeIn = Cubic(0.4, 0, 0.6, 1);
}

/// Theme-resolved color palette. Held in a [FintinoColors] inherited
/// via Theme.extension so all widgets get the right values for dark/light.
@immutable
class FintinoColors extends ThemeExtension<FintinoColors> {
  final Color bg;
  final Color surface;
  final Color glass;
  final Color glassHi;
  final Color border;

  final Color accent;
  final Color accentDim;
  final Color accentGlow;
  final Color accentGold;

  final Color fg;
  final Color fg2;
  final Color fg3;

  final Color positive;
  final Color negative;
  final Color warning;
  final Color divider;

  final List<Color> cardGradient;
  final List<Color> auroraGradient;

  const FintinoColors({
    required this.bg,
    required this.surface,
    required this.glass,
    required this.glassHi,
    required this.border,
    required this.accent,
    required this.accentDim,
    required this.accentGlow,
    required this.accentGold,
    required this.fg,
    required this.fg2,
    required this.fg3,
    required this.positive,
    required this.negative,
    required this.warning,
    required this.divider,
    required this.cardGradient,
    required this.auroraGradient,
  });

  static const dark = FintinoColors(
    bg: Color(0xFF1C2B3A),
    surface: Color(0xFF253649),
    glass: Color(0x144CAF7A),
    glassHi: Color(0x1F4CAF7A),
    border: Color(0x244CAF7A),
    accent: Color(0xFF2E7D52),
    accentDim: Color(0x242E7D52),
    accentGlow: Color(0x3D2E7D52),
    accentGold: Color(0xFFC9A84C),
    fg: Color(0xFFF7FAF8),
    fg2: Color(0x9EF7FAF8),
    fg3: Color(0x52F7FAF8),
    positive: Color(0xFF4CAF7A),
    negative: Color(0xFFE84C3D),
    warning: Color(0xFFC9A84C),
    divider: Color(0x1A4CAF7A),
    cardGradient: [Color(0xFF2E7D52), Color(0xFF1C2B3A), Color(0xFF203142)],
    auroraGradient: [Color(0x1F2E7D52), Color(0x001C2B3A)],
  );

  // Light theme — warm cream/ivory base, solid white card surfaces, deep
  // forest accent. Designed to feel airy yet premium without relying on
  // backdrop blur (which washes out on bright backgrounds).
  static const light = FintinoColors(
    bg: Color(0xFFF4F1EA),         // warm ivory / off-white
    surface: Color(0xFFFFFFFF),    // pure white card surface
    glass: Color(0xFFFFFFFF),      // solid white, no transparency
    glassHi: Color(0xFFFAF7F1),    // slightly tinted highlight
    border: Color(0x141C2B3A),     // soft slate border
    accent: Color(0xFF1F6B45),     // deeper forest green (better contrast)
    accentDim: Color(0x141F6B45),  // 8% accent wash
    accentGlow: Color(0x331F6B45), // 20% — for shadow glow under cards
    accentGold: Color(0xFFB8923D), // deeper gold for legibility on cream
    fg: Color(0xFF1A1F2C),         // warm slate
    fg2: Color(0xA61A1F2C),        // 65%
    fg3: Color(0x661A1F2C),        // 40%
    positive: Color(0xFF1F6B45),
    negative: Color(0xFFD93B2C),
    warning: Color(0xFFB8923D),
    divider: Color(0x0F1A1F2C),    // 6% slate
    // Premium dark card gradient even on light theme — same striking feel
    // as Apple Wallet / Revolut, but with softer edges that pair with cream bg.
    cardGradient: [Color(0xFF1F6B45), Color(0xFF14233A), Color(0xFF1A2E47)],
    auroraGradient: [Color(0x141F6B45), Color(0x00F4F1EA)],
  );

  @override
  FintinoColors copyWith() => this;

  @override
  FintinoColors lerp(ThemeExtension<FintinoColors>? other, double t) {
    if (other is! FintinoColors) return this;
    return FintinoColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      glass: Color.lerp(glass, other.glass, t)!,
      glassHi: Color.lerp(glassHi, other.glassHi, t)!,
      border: Color.lerp(border, other.border, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentDim: Color.lerp(accentDim, other.accentDim, t)!,
      accentGlow: Color.lerp(accentGlow, other.accentGlow, t)!,
      accentGold: Color.lerp(accentGold, other.accentGold, t)!,
      fg: Color.lerp(fg, other.fg, t)!,
      fg2: Color.lerp(fg2, other.fg2, t)!,
      fg3: Color.lerp(fg3, other.fg3, t)!,
      positive: Color.lerp(positive, other.positive, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      cardGradient: cardGradient,
      auroraGradient: auroraGradient,
    );
  }
}

extension FintinoColorsX on BuildContext {
  FintinoColors get c => Theme.of(this).extension<FintinoColors>()!;
}
