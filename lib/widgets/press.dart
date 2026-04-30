import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/tokens.dart';

/// Press-down interaction with scale + opacity + light haptic feedback.
class Press extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final bool haptics;
  const Press({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.96,
    this.haptics = true,
  });

  @override
  State<Press> createState() => _PressState();
}

class _PressState extends State<Press> {
  bool _down = false;

  void _onTap() {
    if (widget.onTap == null) return;
    if (widget.haptics) HapticFeedback.lightImpact();
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: widget.onTap == null ? null : (_) => setState(() => _down = false),
      onTap: _onTap,
      child: AnimatedScale(
        scale: _down ? widget.scale : 1,
        duration: FT.durFast,
        curve: FT.easeOut,
        child: AnimatedOpacity(
          opacity: _down ? 0.85 : 1,
          duration: FT.durFast,
          child: widget.child,
        ),
      ),
    );
  }
}
