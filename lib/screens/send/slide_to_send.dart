import 'package:flutter/material.dart';
import '../../core/theme/tokens.dart';

class SlideToSend extends StatefulWidget {
  final String amount;
  final String recipient;
  final VoidCallback onSuccess;
  const SlideToSend({super.key, required this.amount, required this.recipient, required this.onSuccess});

  @override
  State<SlideToSend> createState() => _SlideToSendState();
}

class _SlideToSendState extends State<SlideToSend> {
  double _x = 0;
  bool _drag = false;
  bool _sent = false;
  static const _trackHeight = 62.0;
  static const _knob = 54.0;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return LayoutBuilder(builder: (_, cons) {
      final maxX = cons.maxWidth - _knob - 8;
      final pct = maxX > 0 ? (_x / maxX).clamp(0, 1) : 0;
      return GestureDetector(
        onHorizontalDragStart: _sent ? null : (_) => setState(() => _drag = true),
        onHorizontalDragUpdate: _sent ? null : (d) {
          setState(() => _x = (_x + d.delta.dx).clamp(0, maxX));
        },
        onHorizontalDragEnd: _sent ? null : (_) {
          setState(() => _drag = false);
          if (_x > maxX * 0.82) {
            setState(() {
              _x = maxX;
              _sent = true;
            });
            Future.delayed(const Duration(milliseconds: 600), widget.onSuccess);
          } else {
            setState(() => _x = 0);
          }
        },
        child: SizedBox(
          height: _trackHeight,
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: _sent ? c.positive : c.accent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [BoxShadow(color: c.accentGlow, blurRadius: 20, offset: const Offset(0, 4))],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: AnimatedContainer(
                  duration: _drag ? Duration.zero : const Duration(milliseconds: 300),
                  width: cons.maxWidth * pct,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0x1FFFFFFF), Color(0x0AFFFFFF)]),
                  ),
                ),
              ),
              Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _sent ? 0 : (1 - pct * 0.7).toDouble(),
                  child: Text(
                    'Slide to send \$${widget.amount.isEmpty ? '0' : widget.amount} to ${widget.recipient}',
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (_sent)
                const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text('Sent!',
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              AnimatedPositioned(
                duration: _drag ? Duration.zero : const Duration(milliseconds: 300),
                curve: FT.easeOut,
                left: 4 + _x,
                top: 4,
                child: Container(
                  width: _knob,
                  height: _knob,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Color(0x38000000), blurRadius: 14, offset: Offset(0, 4))],
                  ),
                  child: Icon(_sent ? Icons.check : Icons.arrow_forward, color: c.accent, size: 22),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
