import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/bank_card.dart';
import '../../widgets/buttons.dart';
import '../../widgets/feedback.dart';
import '../../widgets/glass.dart';
import '../../widgets/list_row.dart';
import '../../widgets/money_display.dart';
import '../../widgets/press.dart';
import '../../widgets/top_bar.dart';
import '../common/placeholder_screen.dart';
import '../send/send_money_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _idx = 0;
  double _dragX = 0;
  bool _dragging = false;
  final Set<int> _frozen = {};

  void _push(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final cur = kCards[_idx];
    final isFrozen = _frozen.contains(_idx);
    final actions = [
      (
        Icons.send_rounded, 'Transfer', c.accent,
        () => _push(const SendMoneyScreen()),
      ),
      (
        isFrozen ? Icons.lock_open_rounded : Icons.ac_unit_rounded,
        isFrozen ? 'Unfreeze' : 'Freeze',
        isFrozen ? c.warning : c.fg2,
        () {
          setState(() {
            if (isFrozen) {
              _frozen.remove(_idx);
            } else {
              _frozen.add(_idx);
            }
          });
          showFeedback(
            context,
            isFrozen
                ? '${cur.label} ••${cur.last4} unfrozen'
                : '${cur.label} ••${cur.last4} frozen',
            icon: isFrozen ? Icons.lock_open_rounded : Icons.ac_unit_rounded,
          );
        },
      ),
      (
        Icons.tune_rounded, 'Limits', c.accentGold,
        () => _push(PlaceholderScreen(
              title: 'Card limits',
              subtitle: '${cur.label} ••${cur.last4}',
              icon: Icons.tune_rounded,
              description: 'Set per-card spending limits and category caps.',
              bullets: const [
                (icon: Icons.attach_money, label: 'Daily spending limit'),
                (icon: Icons.calendar_month, label: 'Monthly spending limit'),
                (icon: Icons.shopping_basket, label: 'Per-category caps'),
                (icon: Icons.location_on_outlined, label: 'Country / region rules'),
              ],
              primaryActionLabel: 'Save changes',
            )),
      ),
      (
        Icons.bar_chart_rounded, 'Insights', c.positive,
        () => context.read<AppState>().setTab(2),
      ),
    ];

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 140),
      children: [
        FintinoTopBar(
          title: 'Wallet',
          subtitle: '${kCards.length} cards · swipe to browse',
          trailing: GlassIconButton(
            icon: Icons.add,
            accent: true,
            onTap: () => _push(const PlaceholderScreen(
              title: 'Add a card',
              subtitle: 'Order or import',
              icon: Icons.add_card_rounded,
              description: 'Order a new physical card, mint a virtual card, or add an existing card from another bank.',
              bullets: [
                (icon: Icons.credit_card, label: 'Order new physical card'),
                (icon: Icons.bolt_rounded, label: 'Mint instant virtual card'),
                (icon: Icons.account_balance, label: 'Add card from another bank'),
              ],
              primaryActionLabel: 'Continue',
            )),
          ),
        ),
        // Card stack
        SizedBox(
          height: 245,
          child: GestureDetector(
            onHorizontalDragStart: (_) => setState(() => _dragging = true),
            onHorizontalDragUpdate: (d) => setState(() => _dragX += d.delta.dx),
            onHorizontalDragEnd: (_) {
              setState(() {
                if (_dragX < -55 && _idx < kCards.length - 1) _idx++;
                else if (_dragX > 55 && _idx > 0) _idx--;
                _dragging = false;
                _dragX = 0;
              });
            },
            child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              // Order children so the active card (off=0) is added LAST and
              // therefore rendered on TOP. Cards farther in |off| go first
              // (rendered behind).
              children: (List.generate(kCards.length, (i) => i)
                    ..sort((a, b) =>
                        (b - _idx).abs().compareTo((a - _idx).abs())))
                  .map(_stackCard)
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Page dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(kCards.length, (i) {
            return GestureDetector(
              onTap: () => setState(() => _idx = i),
              child: AnimatedContainer(
                duration: FT.durNormal,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: i == _idx ? 22 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _idx ? c.accent : c.fg3,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Balance row
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [c.glassHi, c.glass],
                  ),
                  borderRadius: BorderRadius.circular(FT.rLg),
                  border: Border.all(color: c.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${cur.label.toUpperCase()} · •${cur.last4}',
                              style: FTType.label(context).copyWith(color: c.fg2)),
                          const SizedBox(height: 6),
                          MoneyDisplay(
                            value: cur.balanceNum,
                            size: 30,
                            duration: const Duration(milliseconds: 600),
                            countKey: _idx,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [c.positive.withOpacity(0.32), c.positive.withOpacity(0.12)],
                        ),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: c.positive.withOpacity(0.4)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            color: c.positive, shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: c.positive, blurRadius: 6)],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('Active',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700, color: c.positive)),
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Action grid (4 in row)
              Row(
                children: [
                  for (final a in actions)
                    Expanded(
                      child: Press(
                        onTap: a.$4,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: c.glassHi,
                            borderRadius: BorderRadius.circular(FT.rMd),
                            border: Border.all(color: c.border),
                          ),
                          child: Column(children: [
                            Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: a.$3.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: a.$3.withOpacity(0.4)),
                              ),
                              child: Icon(a.$1, color: a.$3, size: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(a.$2,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600, color: c.fg)),
                          ]),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Spending progress card
              Glass(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text('Monthly spending', style: FTType.h3(context).copyWith(fontSize: 15)),
                      const Spacer(),
                      Text('42%', style: FTType.label(context).copyWith(color: c.accent)),
                    ]),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: TweenAnimationBuilder<double>(
                        key: ValueKey(_idx),
                        tween: Tween(begin: 0, end: 0.42),
                        duration: const Duration(milliseconds: 900),
                        curve: FT.easeOut,
                        builder: (_, v, __) => Stack(children: [
                          Container(height: 8, color: c.fg.withOpacity(0.07)),
                          FractionallySizedBox(
                            widthFactor: v,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [c.accent, c.accentGold]),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      _kv(context, 'Spent', '\$4,218'),
                      const SizedBox(width: 16),
                      _kv(context, 'Limit', '\$10,000'),
                      const SizedBox(width: 16),
                      _kv(context, 'Renews', 'Nov 01'),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _kv(BuildContext context, String k, String v) {
    final c = context.c;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(k, style: TextStyle(fontSize: 11, color: c.fg3, letterSpacing: 1.0, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(v,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: c.fg,
                fontFeatures: const [FontFeature.tabularFigures()],
              )),
        ],
      ),
    );
  }

  Widget _stackCard(int i) {
    final off = i - _idx;
    final isTop = off == 0;
    // Cards already swiped past or too far back: don't render at all so
    // their content can never bleed through the active card.
    if (off < 0 || off > 3) return const SizedBox.shrink();
    final dx = isTop ? _dragX : 0.0;
    final scale = 1 - off.abs() * 0.06;
    const opacity = 1.0;
    return AnimatedPositioned(
      duration: _dragging && isTop ? Duration.zero : const Duration(milliseconds: 380),
      curve: FT.easeOut,
      top: off * 16.0,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: !isTop,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 380),
          opacity: opacity,
          child: Center(
            child: Transform.translate(
              offset: Offset(dx, 0),
              child: Transform.rotate(
                angle: dx / 700,
                child: Transform.scale(
                  scale: scale,
                  child: BankCard(
                    last4: kCards[i].last4,
                    holder: kCards[i].holder,
                    balance: kCards[i].balance,
                    network: kCards[i].network,
                    shimmer: isTop,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
