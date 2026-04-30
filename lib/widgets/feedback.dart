import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/tokens.dart';

/// Shows a styled toast at the top of the screen for non-critical
/// confirmations (e.g. "Card frozen", "Reference copied").
void showFeedback(
  BuildContext context,
  String message, {
  IconData icon = Icons.check_circle_rounded,
  bool error = false,
}) {
  HapticFeedback.selectionClick();
  final c = Theme.of(context).extension<FintinoColors>()!;
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(milliseconds: 1800),
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      padding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: error ? c.negative : c.fg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 18, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: error ? Colors.white : c.bg, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message,
                  style: TextStyle(
                      color: error ? Colors.white : c.bg,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ),
          ],
        ),
      ),
    ),
  );
}
