import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/bank_card.dart';
import '../../widgets/buttons.dart';
import '../auth/sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  static const _pages = [
    _Page('01', 'Money that\nmoves like light.', 'Open your first card in 30 seconds. No paperwork, no branch visit.'),
    _Page('02', 'Total control,\nanywhere.', 'Freeze cards, set limits, view statements — all from one tap.'),
    _Page('03', 'Built for\nyour life.', 'Smart insights, instant transfers, zero surprises on your statement.'),
  ];

  @override
  Widget build(BuildContext context) {
    final p = _pages[_step];
    final c = context.c;
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              children: [
                Row(
                  children: [
                    _ApertureLogo(color: c.accent),
                    const SizedBox(width: 10),
                    Text('FINTINO',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 2.4, color: c.fg)),
                    const Spacer(),
                    GestureDetector(
                      onTap: _goSignIn,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: c.glassHi,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: c.border),
                        ),
                        child: Text('Skip',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c.fg)),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 320, height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(colors: [c.accentGlow, c.accentGlow.withOpacity(0)]),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(70, 60),
                          child: Transform.rotate(
                            angle: 0.18,
                            child: const Opacity(
                              opacity: 0.7,
                              child: BankCard(last4: '2840', balance: '\$38,210.00', scale: 0.7, network: 'MASTERCARD'),
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(-50, -30),
                          child: Transform.rotate(angle: -0.11, child: const BankCard(scale: 0.88, shimmer: true)),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: FT.durSlow,
                  transitionBuilder: (child, a) => FadeTransition(
                    opacity: a,
                    child: SlideTransition(
                        position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(a),
                        child: child),
                  ),
                  child: Column(
                    key: ValueKey(_step),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(p.n, style: FTType.label(context).copyWith(color: c.accent)),
                        const SizedBox(width: 6),
                        Text('· ${_pages.length}', style: FTType.label(context)),
                      ]),
                      const SizedBox(height: 14),
                      Text(p.title, style: FTType.h1(context)),
                      const SizedBox(height: 12),
                      Text(p.sub, style: FTType.body(context)),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Row(
                            children: List.generate(_pages.length, (i) {
                              return GestureDetector(
                                onTap: () => setState(() => _step = i),
                                child: AnimatedContainer(
                                  duration: FT.durNormal,
                                  margin: const EdgeInsets.only(right: 8),
                                  width: i == _step ? 28 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    gradient: i == _step
                                        ? LinearGradient(colors: [c.accent, c.accentGold])
                                        : null,
                                    color: i == _step ? null : c.fg3,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const Spacer(),
                          Btn(
                            label: _step < _pages.length - 1 ? 'Continue' : 'Get started',
                            icon: Icons.arrow_forward_rounded,
                            onTap: () {
                              if (_step < _pages.length - 1) {
                                setState(() => _step++);
                              } else {
                                _goSignIn();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _goSignIn() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignInScreen()));
  }
}

class _Page {
  final String n;
  final String title;
  final String sub;
  const _Page(this.n, this.title, this.sub);
}

class _ApertureLogo extends StatelessWidget {
  final Color color;
  const _ApertureLogo({required this.color});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: CustomPaint(painter: _LogoPainter(color)),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color color;
  _LogoPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2 - 1.5, p);
    final path = Path()
      ..moveTo(8, 20.5)
      ..lineTo(14, 7)
      ..lineTo(20, 20.5)
      ..moveTo(10.5, 16)
      ..lineTo(17.5, 16);
    canvas.drawPath(path, p..strokeWidth = 1.8);
  }

  @override
  bool shouldRepaint(_LogoPainter old) => old.color != color;
}
