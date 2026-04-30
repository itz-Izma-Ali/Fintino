import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/tokens.dart';

class DonutSlice {
  final double value;
  final Color color;
  final String label;
  const DonutSlice({required this.value, required this.color, required this.label});
}

/// Animated donut/ring chart with center label.
class DonutChart extends StatefulWidget {
  final List<DonutSlice> slices;
  final double size;
  final double strokeWidth;
  final String centerLabel;
  final String centerSub;
  const DonutChart({
    super.key,
    required this.slices,
    required this.centerLabel,
    required this.centerSub,
    this.size = 180,
    this.strokeWidth = 22,
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> with SingleTickerProviderStateMixin {
  late final AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ac,
        builder: (_, __) {
          final t = Curves.easeOutCubic.transform(_ac.value);
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(widget.size),
                painter: _DonutPainter(widget.slices, widget.strokeWidth, t, c.glassHi),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.centerSub,
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: c.fg3)),
                  const SizedBox(height: 4),
                  Text(widget.centerLabel,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: c.fg,
                        letterSpacing: -0.6,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      )),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<DonutSlice> slices;
  final double stroke;
  final double progress;
  final Color trackColor;
  _DonutPainter(this.slices, this.stroke, this.progress, this.trackColor);

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2 - stroke / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: r);

    // Track
    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = trackColor
        ..strokeWidth = stroke
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    final total = slices.fold<double>(0, (s, e) => s + e.value);
    double start = -math.pi / 2;
    final gap = 0.04;
    for (final s in slices) {
      final sweep = (s.value / total) * (math.pi * 2 - gap * slices.length) * progress;
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = s.color
          ..strokeWidth = stroke
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
      start += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.progress != progress || old.slices != slices;
}
