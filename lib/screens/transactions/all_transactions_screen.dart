import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/models.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/glass.dart';
import '../../widgets/list_row.dart';
import '../../widgets/press.dart';
import '../../widgets/top_bar.dart';
import 'txn_detail_screen.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});
  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final filtered = _filter == 'in'
        ? kTxns.where((t) => t.amount > 0).toList()
        : _filter == 'out'
            ? kTxns.where((t) => t.amount < 0).toList()
            : kTxns;

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: Column(
            children: [
              const FintinoTopBar(title: 'Transactions', subtitle: 'October 2026'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    for (final f in [('all', 'All'), ('in', 'Income'), ('out', 'Expenses')])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Press(
                          onTap: () => setState(() => _filter = f.$1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: _filter == f.$1 ? c.accent : c.glassHi,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: _filter == f.$1 ? c.accent : c.border),
                            ),
                            child: Text(f.$2,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _filter == f.$1 ? Colors.white : c.fg2,
                                )),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                  children: [
                    Glass(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Column(
                        children: [
                          for (int i = 0; i < filtered.length; i++) ...[
                            _row(context, filtered[i]),
                            if (i < filtered.length - 1) const FDivider(),
                          ],
                          if (filtered.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 28),
                              child: Center(
                                child: Text('No transactions',
                                    style: FTType.small(context).copyWith(color: c.fg2)),
                              ),
                            ),
                        ],
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

  Widget _row(BuildContext context, Txn txn) {
    final c = context.c;
    final pos = txn.amount > 0;
    return Press(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => TxnDetailScreen(txn: txn))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: (pos ? c.positive : c.accent).withOpacity(0.16),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: (pos ? c.positive : c.accent).withOpacity(0.22)),
            ),
            child: Icon(txn.icon, color: pos ? c.positive : c.accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(txn.merchant,
                    style: FTType.small(context).copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 3),
                Text('${txn.category} · ${txn.time}', style: TextStyle(fontSize: 12, color: c.fg2)),
              ],
            ),
          ),
          Text('${pos ? '+' : '−'}\$${txn.amount.abs().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: pos ? c.positive : c.fg,
                fontFeatures: const [FontFeature.tabularFigures()],
              )),
        ]),
      ),
    );
  }
}
