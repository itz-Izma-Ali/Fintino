import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/tokens.dart';

class BankCard extends StatefulWidget {
  final String last4;
  final String holder;
  final String balance;
  final String network;
  final double scale;
  final bool shimmer;

  const BankCard({
    super.key,
    this.last4 = '5025',
    this.holder = 'TINO WELL',
    this.balance = '\$12,840.50',
    this.network = 'VISA',
    this.scale = 1,
    this.shimmer = false,
  });

  @override
  State<BankCard> createState() => _BankCardState();
}

class _BankCardState extends State<BankCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 5200))
      ..repeat();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final s = widget.scale;
    final w = 320.0 * s;
    final h = 200.0 * s;
    final r = 22.0 * s;
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF14233A).withOpacity(0.32),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: c.accent.withOpacity(0.32),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Base gradient — must fill the entire card so stacked cards
            // behind it don't bleed through.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(-0.4, -1),
                    end: const Alignment(0.6, 1),
                    colors: c.cardGradient,
                  ),
                ),
              ),
            ),
            // Guilloché pattern overlay (always light on dark card)
            Positioned.fill(
              child: CustomPaint(painter: _GuillochePainter(Colors.white.withOpacity(0.05))),
            ),
            // Top-left green glow
            Positioned(
              top: -40,
              left: -30,
              child: Container(
                width: 220, height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [Color(0x4D2E7D52), Color(0x002E7D52)]),
                ),
              ),
            ),
            // Bottom-right gold accent
            Positioned(
              bottom: -60,
              right: -40,
              child: Container(
                width: 180, height: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [Color(0x33E6C97A), Color(0x00E6C97A)]),
                ),
              ),
            ),
            // Glossy top sheen
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: const Alignment(0, -0.4),
                    colors: [Colors.white.withOpacity(0.10), Colors.transparent],
                  ),
                ),
              ),
            ),
            // Shimmer
            if (widget.shimmer)
              AnimatedBuilder(
                animation: _ac,
                builder: (_, __) {
                  final t = _ac.value;
                  return Positioned.fill(
                    child: Transform.translate(
                      offset: Offset(w * (-1.3 + t * 2.6), 0),
                      child: Transform.rotate(
                        angle: -0.32,
                        child: Container(
                          width: w * 0.5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0),
                                Colors.white.withOpacity(0.18),
                                Colors.white.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            // Content — card is always dark, so text is always light
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22 * s, vertical: 20 * s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                width: 6 * s, height: 6 * s,
                                decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF7A), shape: BoxShape.circle),
                              ),
                              SizedBox(width: 6 * s),
                              Text('FINTINO BANK',
                                  style: TextStyle(
                                    fontSize: 10 * s,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.6,
                                    color: Colors.white.withOpacity(0.72),
                                  )),
                            ]),
                            SizedBox(height: 6 * s),
                            Text(widget.balance,
                                style: TextStyle(
                                  fontSize: 28 * s,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.84,
                                  color: const Color(0xFFE6C97A),
                                  fontFeatures: const [FontFeature.tabularFigures()],
                                  shadows: const [
                                    Shadow(color: Color(0x66000000), blurRadius: 8, offset: Offset(0, 2)),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      _Chip(scale: s, accent: const Color(0xFFE6C97A)),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8 * s),
                    child: Icon(Icons.wifi_rounded,
                        size: 16 * s, color: Colors.white.withOpacity(0.55)),
                  ),
                  // Card number — pure white + subtle shadow for legibility
                  // against the gradient (especially on the gold-balance cards).
                  Row(
                    children: [
                      Text('•••• •••• •••• ',
                          style: TextStyle(
                            fontSize: 14 * s,
                            letterSpacing: 3.2,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(0.55),
                            fontFeatures: const [FontFeature.tabularFigures()],
                          )),
                      Text(widget.last4,
                          style: TextStyle(
                            fontSize: 16 * s,
                            letterSpacing: 2.4,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFeatures: const [FontFeature.tabularFigures()],
                            shadows: const [
                              Shadow(color: Color(0x66000000), blurRadius: 6, offset: Offset(0, 1)),
                            ],
                          )),
                    ],
                  ),
                  SizedBox(height: 10 * s),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CARDHOLDER',
                                style: TextStyle(
                                  fontSize: 8 * s,
                                  letterSpacing: 1.4,
                                  color: Colors.white.withOpacity(0.45),
                                  fontWeight: FontWeight.w700,
                                )),
                            SizedBox(height: 3 * s),
                            Text(widget.holder,
                                style: TextStyle(
                                  fontSize: 12 * s,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                      _NetworkLogo(network: widget.network, scale: s, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            // Subtle inner border (light)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(r),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final double scale;
  final Color accent;
  const _Chip({required this.scale, required this.accent});

  @override
  Widget build(BuildContext context) {
    final w = 44.0 * scale;
    final h = 32.0 * scale;
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [accent, accent.withOpacity(0.5), accent.withOpacity(0.85)],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: CustomPaint(painter: _ChipPainter()),
    );
  }
}

class _ChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.black.withOpacity(0.32)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;
    // Inner rect
    final inset = size.shortestSide * 0.18;
    final rect = Rect.fromLTRB(inset, inset * 0.9, size.width - inset, size.height - inset * 0.9);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2)), p);
    // Vertical lines
    final mid = size.width / 2;
    canvas.drawLine(Offset(mid, 0), Offset(mid, size.height), p);
    // Horizontal lines
    final my = size.height / 2;
    canvas.drawLine(Offset(0, my * 0.6), Offset(size.width, my * 0.6), p);
    canvas.drawLine(Offset(0, my * 1.4), Offset(size.width, my * 1.4), p);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _NetworkLogo extends StatelessWidget {
  final String network;
  final double scale;
  final Color color;
  const _NetworkLogo({required this.network, required this.scale, required this.color});

  @override
  Widget build(BuildContext context) {
    switch (network) {
      case 'MASTERCARD':
        return SizedBox(
          width: 44 * scale, height: 26 * scale,
          child: Stack(
            children: [
              Positioned(left: 0, top: 0, bottom: 0, child: _circle(const Color(0xFFEB001B))),
              Positioned(right: 0, top: 0, bottom: 0, child: _circle(const Color(0xFFF79E1B).withOpacity(0.92))),
            ],
          ),
        );
      case 'AMEX':
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 5 * scale),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2671B9), Color(0xFF0E4D8C)],
            ),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 1)),
            ],
          ),
          child: Text('AMEX',
              style: TextStyle(
                fontSize: 11 * scale,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.8,
              )),
        );
      case 'VIRTUAL':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4 * scale),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 0.8),
              ),
              child: Icon(Icons.bolt_rounded, size: 12 * scale, color: Colors.white),
            ),
            SizedBox(width: 5 * scale),
            Text('VIRTUAL',
                style: TextStyle(
                  fontSize: 11 * scale,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.4,
                )),
          ],
        );
      // VISA & default
    }
    return Text(network,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          fontSize: 18 * scale,
          color: color,
          letterSpacing: 0.6,
        ));
  }

  Widget _circle(Color clr) => Container(
        width: 26 * scale, height: 26 * scale,
        decoration: BoxDecoration(color: clr, shape: BoxShape.circle),
      );
}

/// Decorative concentric arcs for premium card feel.
class _GuillochePainter extends CustomPainter {
  final Color color;
  _GuillochePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final cx = size.width * 0.85;
    final cy = size.height * 0.45;
    for (int i = 1; i <= 7; i++) {
      canvas.drawCircle(Offset(cx, cy), 30.0 + i * 22, p);
    }
    // Diagonal lines
    final p2 = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = 0.6;
    for (double x = -size.height; x < size.width; x += 16) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), p2);
    }
  }

  @override
  bool shouldRepaint(_GuillochePainter old) => old.color != color;
}

// keep math reference (avoid unused import warning if user trims later)
const _kMathPi = math.pi;
