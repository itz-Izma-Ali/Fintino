import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/buttons.dart';
import '../../widgets/feedback.dart';
import '../../widgets/glass.dart';
import '../../widgets/list_row.dart';
import '../../widgets/money_display.dart';
import '../../widgets/top_bar.dart';
import '../main_shell.dart';

class ReceiptScreen extends StatelessWidget {
  final String amount;
  final String recipient;
  const ReceiptScreen({super.key, this.amount = '450', this.recipient = 'Mike'});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final amt = double.tryParse(amount) ?? 0;
    final ref = 'APR-${Random().nextInt(0xFFFFFF).toRadixString(36).toUpperCase().padLeft(6, '0')}';
    final today = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${months[today.month - 1]} ${today.day}';

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              const FintinoTopBar(title: 'Receipt'),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: c.positive,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: c.accentGlow, blurRadius: 32, offset: const Offset(0, 10))],
                  ),
                  child: Icon(Icons.check, size: 36, color: c.fg),
                ),
              ),
              const SizedBox(height: 24),
              Center(child: Text('SENT SUCCESSFULLY', style: FTType.label(context))),
              const SizedBox(height: 12),
              Center(child: MoneyDisplay(value: amt, size: 48, duration: const Duration(milliseconds: 900))),
              const SizedBox(height: 12),
              Center(child: Text('to $recipient · $dateStr', style: FTType.small(context))),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Glass(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      _r(context, 'From', 'Signature ••5025'),
                      const FDivider(),
                      _r(context, 'To', recipient),
                      const FDivider(),
                      _r(context, 'Amount', '\$${amt.toStringAsFixed(2)}'),
                      const FDivider(),
                      _r(context, 'Fee', '\$0.00'),
                      const FDivider(),
                      _r(context, 'Reference', ref),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Btn(
                      label: 'PDF',
                      icon: Icons.download,
                      ghost: true,
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: ref));
                        if (context.mounted) {
                          showFeedback(context, 'Receipt PDF saved to Files',
                              icon: Icons.download_done_rounded);
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Btn(
                        label: 'Back to Home',
                        icon: Icons.home_rounded,
                        full: true,
                        onTap: () => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const MainShell()),
                          (_) => false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _r(BuildContext context, String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(children: [
        Text(k, style: FTType.small(context)),
        const Spacer(),
        Text(v, style: FTType.small(context)),
      ]),
    );
  }
}
