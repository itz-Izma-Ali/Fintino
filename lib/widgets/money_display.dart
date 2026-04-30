import 'package:flutter/material.dart';
import '../core/theme/tokens.dart';

class MoneyDisplay extends StatefulWidget {
  final double value;
  final double size;
  final double? smallSize;
  final Duration duration;
  final Object countKey;
  const MoneyDisplay({
    super.key,
    required this.value,
    this.size = 44,
    this.smallSize,
    this.duration = const Duration(milliseconds: 1300),
    this.countKey = 0,
  });

  @override
  State<MoneyDisplay> createState() => _MoneyDisplayState();
}

class _MoneyDisplayState extends State<MoneyDisplay> with SingleTickerProviderStateMixin {
  late AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: widget.duration)..forward();
  }

  @override
  void didUpdateWidget(covariant MoneyDisplay old) {
    super.didUpdateWidget(old);
    if (old.countKey != widget.countKey || old.value != widget.value) {
      _ac.duration = widget.duration;
      _ac
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  String _format(double v) {
    final neg = widget.value < 0;
    final abs = v.abs();
    final parts = abs.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
    return '${neg ? '−' : ''}\$$intPart.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final ss = widget.smallSize ?? widget.size * 0.58;
    return AnimatedBuilder(
      animation: _ac,
      builder: (_, __) {
        final eased = 1 - (1 - _ac.value) * (1 - _ac.value) * (1 - _ac.value);
        final v = widget.value * eased;
        final str = _format(v);
        final dotIdx = str.lastIndexOf('.');
        final intStr = str.substring(0, dotIdx);
        final decStr = str.substring(dotIdx);
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: intStr,
                style: TextStyle(
                  fontSize: widget.size,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -widget.size * 0.03,
                  color: c.fg,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              TextSpan(
                text: decStr,
                style: TextStyle(
                  fontSize: ss,
                  fontWeight: FontWeight.w700,
                  color: c.fg2,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
