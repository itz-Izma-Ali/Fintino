import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/models.dart';
import '../../widgets/bank_card.dart';
import '../../widgets/buttons.dart';
import '../../widgets/feedback.dart';
import '../../widgets/glass.dart';
import '../../widgets/list_row.dart';
import '../../widgets/money_display.dart';
import '../../widgets/press.dart';
import '../common/placeholder_screen.dart';
import '../send/send_money_screen.dart';
import '../transactions/all_transactions_screen.dart';
import '../transactions/notifs_screen.dart';
import '../transactions/txn_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _balanceKey = 0;
  bool _balanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    void push(Widget page) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

    final quick = [
      _Quick(Icons.south_rounded, 'Deposit', 'Add money', () {
        push(const PlaceholderScreen(
          title: 'Deposit',
          subtitle: 'Add money to your account',
          icon: Icons.south_rounded,
          description: 'Choose a method to top up your Signature account.',
          bullets: [
            (icon: Icons.account_balance, label: 'Bank transfer (ACH)'),
            (icon: Icons.credit_card, label: 'Debit card'),
            (icon: Icons.qr_code_2, label: 'Cash deposit at ATM'),
            (icon: Icons.bolt_rounded, label: 'Instant pay-in from linked account'),
          ],
          primaryActionLabel: 'Continue',
        ));
      }),
      _Quick(Icons.send_rounded, 'Send', 'Pay anyone', () {
        push(const SendMoneyScreen());
      }),
      _Quick(Icons.swap_horiz_rounded, 'Swap', 'Convert', () {
        push(const PlaceholderScreen(
          title: 'Swap',
          subtitle: 'Move between accounts',
          icon: Icons.swap_horiz_rounded,
          description: 'Instantly convert balances across your Fintino accounts and supported currencies — no fees.',
          bullets: [
            (icon: Icons.account_balance_wallet, label: 'Between Fintino accounts'),
            (icon: Icons.currency_exchange, label: '40+ currencies supported'),
            (icon: Icons.bolt_rounded, label: 'Instant settlement'),
          ],
          primaryActionLabel: 'Start swap',
        ));
      }),
      _Quick(Icons.qr_code_scanner_rounded, 'Pay', 'Scan QR', () {
        push(const PlaceholderScreen(
          title: 'Scan to pay',
          subtitle: 'Point at any merchant QR',
          icon: Icons.qr_code_scanner_rounded,
          description: 'Camera permission needed to scan QR codes for in-store payments.',
          bullets: [
            (icon: Icons.qr_code_2, label: 'Static and dynamic QR support'),
            (icon: Icons.shield_rounded, label: 'Confirm before each payment'),
          ],
          primaryActionLabel: 'Open camera',
        ));
      }),
    ];

    return RefreshIndicator(
      color: c.accent,
      backgroundColor: c.surface,
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 800));
        setState(() => _balanceKey++);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 140),
        children: [
          _Header(c: c),
          const SizedBox(height: 24),
          _BalanceHero(
            visible: _balanceVisible,
            countKey: _balanceKey,
            onTapValue: () => setState(() => _balanceKey++),
            onToggleVisible: () => setState(() => _balanceVisible = !_balanceVisible),
          ),
          const SizedBox(height: 20),
          // Card with peek into stack
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -10,
                  child: Transform.scale(
                    scale: 0.9,
                    child: Opacity(
                      opacity: 0.55,
                      child: BankCard(
                        last4: kCards[1].last4,
                        balance: kCards[1].balance,
                        network: kCards[1].network,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: BankCard(shimmer: true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          // Quick actions in a row of premium tiles
          Row(
            children: [
              for (final q in quick) Expanded(child: _QuickTile(q: q)),
            ],
          ),
          const SizedBox(height: 28),
          _SectionHeader(
              title: 'Recent activity',
              actionLabel: 'See all',
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AllTransactionsScreen()))),
          const SizedBox(height: 12),
          Glass(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              children: [
                for (int i = 0; i < kTxns.length; i++) ...[
                  _TxnRow(txn: kTxns[i]),
                  if (i < kTxns.length - 1) const FDivider(),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Press(
            onTap: () => showFeedback(context, 'Auto-pay scheduled for Wed', icon: Icons.event_rounded),
            child: _UpcomingTile(),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final dynamic c;
  const _Header({required this.c});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(colors: [c.accent, c.accentGold, c.accent]),
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: c.bg, shape: BoxShape.circle),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: c.accentDim, shape: BoxShape.circle),
              child: Icon(Icons.person, color: c.accent),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good morning', style: FTType.small(context).copyWith(color: c.fg2, fontSize: 12)),
            const SizedBox(height: 4),
            Text('Tino Well', style: FTType.h3(context)),
          ],
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            GlassIconButton(
              icon: Icons.notifications_outlined,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotifsScreen())),
            ),
            Positioned(
              top: 6, right: 6,
              child: Container(
                width: 9, height: 9,
                decoration: BoxDecoration(
                  color: c.accentGold,
                  shape: BoxShape.circle,
                  border: Border.all(color: c.bg, width: 2),
                  boxShadow: [BoxShadow(color: c.accentGold.withOpacity(0.6), blurRadius: 6)],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BalanceHero extends StatelessWidget {
  final bool visible;
  final int countKey;
  final VoidCallback onTapValue;
  final VoidCallback onToggleVisible;
  const _BalanceHero({
    required this.visible,
    required this.countKey,
    required this.onTapValue,
    required this.onToggleVisible,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 14, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c.glassHi, c.glass],
        ),
        borderRadius: BorderRadius.circular(FT.rLg),
        border: Border.all(color: c.border),
        boxShadow: [
          BoxShadow(color: c.accentGlow.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('TOTAL BALANCE', style: FTType.label(context).copyWith(color: c.fg2)),
              const Spacer(),
              Press(
                onTap: onToggleVisible,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.glassHi,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: c.border),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        size: 13, color: c.fg2),
                    const SizedBox(width: 4),
                    Text(visible ? 'Hide' : 'Show',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: c.fg2)),
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTapValue,
            child: AnimatedSwitcher(
              duration: FT.durNormal,
              child: visible
                  ? MoneyDisplay(
                      key: const ValueKey('shown'),
                      value: 12840.50,
                      size: 44,
                      duration: const Duration(milliseconds: 1200),
                      countKey: countKey,
                    )
                  : Padding(
                      key: const ValueKey('hidden'),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text('• • • • • •',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.w700, color: c.fg2, letterSpacing: 6)),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: c.positive.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.arrow_outward_rounded, size: 12, color: c.positive),
                  const SizedBox(width: 4),
                  Text('+3.9%',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: c.positive)),
                ]),
              ),
              const SizedBox(width: 8),
              Text('+\$482.18 this week',
                  style: FTType.small(context).copyWith(color: c.fg2, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Quick {
  final IconData icon;
  final String label;
  final String hint;
  final VoidCallback? onTap;
  const _Quick(this.icon, this.label, this.hint, this.onTap);
}

class _QuickTile extends StatelessWidget {
  final _Quick q;
  const _QuickTile({required this.q});
  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Press(
      onTap: q.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [c.glassHi, c.glass],
          ),
          borderRadius: BorderRadius.circular(FT.rMd),
          border: Border.all(color: c.border),
        ),
        child: Column(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [c.accent, c.accent.withOpacity(0.6)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: c.accentGlow, blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Icon(q.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 10),
            Text(q.label,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: c.fg)),
            const SizedBox(height: 2),
            Text(q.hint, style: TextStyle(fontSize: 10.5, color: c.fg3)),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onTap;
  const _SectionHeader({required this.title, required this.actionLabel, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(children: [
        Text(title, style: FTType.h3(context)),
        const Spacer(),
        Press(
          onTap: onTap,
          child: Row(children: [
            Text(actionLabel, style: TextStyle(color: c.accent, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(width: 2),
            Icon(Icons.arrow_forward, size: 14, color: c.accent),
          ]),
        ),
      ]),
    );
  }
}

class _TxnRow extends StatelessWidget {
  final Txn txn;
  const _TxnRow({required this.txn});
  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final pos = txn.amount > 0;
    return Press(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TxnDetailScreen(txn: txn))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: pos
                      ? [c.positive.withOpacity(0.32), c.positive.withOpacity(0.12)]
                      : [c.accentDim, c.accent.withOpacity(0.05)],
                ),
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
                  Text(txn.merchant, style: FTType.small(context).copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 3),
                  Text('${txn.category} · ${txn.time}', style: TextStyle(fontSize: 11.5, color: c.fg2)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${pos ? '+' : '−'}\$${txn.amount.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: pos ? c.positive : c.fg,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 2),
                Text('USD', style: TextStyle(fontSize: 10, color: c.fg3, letterSpacing: 0.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UpcomingTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c.accent.withOpacity(0.18), c.accentGold.withOpacity(0.10)],
        ),
        border: Border.all(color: c.accent.withOpacity(0.32)),
        borderRadius: BorderRadius.circular(FT.rLg),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: c.accentGold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: c.accentGold.withOpacity(0.5)),
            ),
            child: Icon(Icons.event_rounded, color: c.accentGold, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upcoming this week', style: FTType.label(context).copyWith(color: c.fg2)),
                const SizedBox(height: 4),
                Text('Rent · Pawan Kumar',
                    style: FTType.small(context).copyWith(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text('Auto-pay on Wed · \$1,600.00',
                    style: TextStyle(fontSize: 12, color: c.fg2)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: c.fg2),
        ],
      ),
    );
  }
}
