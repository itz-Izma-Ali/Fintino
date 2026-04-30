import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../data/models/models.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/buttons.dart';
import '../../widgets/feedback.dart';
import '../../widgets/glass.dart';
import '../../widgets/list_row.dart';
import '../../widgets/top_bar.dart';
import '../send/send_money_screen.dart';

class TxnDetailScreen extends StatelessWidget {
  final Txn txn;
  const TxnDetailScreen({super.key, required this.txn});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final neg = txn.amount < 0;
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              FintinoTopBar(title: txn.merchant, subtitle: txn.category),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Glass(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('${neg ? '−' : '+'}\$${txn.amount.abs().toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w700,
                            color: neg ? c.fg : c.positive,
                            letterSpacing: -1.44,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          )),
                      const SizedBox(height: 8),
                      Text(txn.time, style: FTType.small(context)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Glass(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      _r(context, 'Merchant', txn.merchant),
                      const FDivider(),
                      _r(context, 'Category', txn.category),
                      const FDivider(),
                      _r(context, 'Card', txn.card),
                      const FDivider(),
                      _r(context, 'Note', txn.note),
                      const FDivider(),
                      _r(context, 'Status', 'Completed'),
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
                      label: 'Copy ref',
                      icon: Icons.copy_rounded,
                      ghost: true,
                      onTap: () async {
                        final ref = 'APR-${txn.merchant.hashCode.abs().toRadixString(36).toUpperCase().substring(0, 6)}';
                        await Clipboard.setData(ClipboardData(text: ref));
                        if (context.mounted) {
                          showFeedback(context, 'Reference $ref copied', icon: Icons.copy_rounded);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Btn(
                      label: 'Repeat',
                      icon: Icons.repeat,
                      ghost: true,
                      onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SendMoneyScreen())),
                    ),
                    const SizedBox(width: 8),
                    Btn(
                      label: 'Dispute',
                      icon: Icons.flag,
                      ghost: true,
                      danger: true,
                      onTap: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => _confirmDispute(context),
                        );
                        if (ok == true && context.mounted) {
                          showFeedback(context, 'Dispute opened · we\'ll email you',
                              icon: Icons.flag_rounded);
                        }
                      },
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

  Widget _confirmDispute(BuildContext context) {
    final c = context.c;
    return AlertDialog(
      backgroundColor: c.surface,
      surfaceTintColor: c.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Dispute this transaction?', style: FTType.h3(context)),
      content: Text(
        'We\'ll review "${txn.merchant}" for \$${txn.amount.abs().toStringAsFixed(2)}. You may be asked for documentation.',
        style: FTType.small(context).copyWith(color: c.fg2),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel', style: TextStyle(color: c.fg2, fontWeight: FontWeight.w600)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Open dispute',
              style: TextStyle(color: c.negative, fontWeight: FontWeight.w700)),
        ),
      ],
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
