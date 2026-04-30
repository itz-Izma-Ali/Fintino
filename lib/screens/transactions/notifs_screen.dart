import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/buttons.dart';
import '../../widgets/feedback.dart';
import '../../widgets/glass.dart';
import '../../widgets/list_row.dart';
import '../../widgets/press.dart';
import '../../widgets/top_bar.dart';

class NotifsScreen extends StatefulWidget {
  const NotifsScreen({super.key});
  @override
  State<NotifsScreen> createState() => _NotifsScreenState();
}

class _NotifsScreenState extends State<NotifsScreen> {
  static const _items = [
    (Icons.south_rounded, 'Payment received', 'Alec Koder sent \$100.00', 'now'),
    (Icons.credit_card, 'Card activated', 'Savings ••2840 is ready', '1h'),
    (Icons.trending_up, 'Weekly summary', 'You spent \$1,228 this week', '3h'),
    (Icons.shield_outlined, 'New sign-in', 'iPhone 15 · San Francisco', 'yesterday'),
    (Icons.send, 'Transfer sent', '\$1,600 to Pawan Kumar', 'Wed'),
    (Icons.card_giftcard, 'Cashback earned', '+\$24.50 this week', 'Tue'),
  ];

  late Set<int> _read = {};

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              FintinoTopBar(
                title: 'Notifications',
                subtitle: '${_items.length - _read.length} unread',
                trailing: GlassIconButton(
                  icon: Icons.done_all_rounded,
                  onTap: () {
                    setState(() => _read = Set.from(List.generate(_items.length, (i) => i)));
                    showFeedback(context, 'All marked as read', icon: Icons.done_all_rounded);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Glass(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Column(
                    children: [
                      for (int i = 0; i < _items.length; i++) ...[
                        Press(
                          onTap: () {
                            setState(() => _read.add(i));
                            showFeedback(context, _items[i].$2, icon: _items[i].$1);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 40, height: 40,
                                      decoration: BoxDecoration(
                                          color: c.accentDim,
                                          borderRadius: BorderRadius.circular(12)),
                                      child: Icon(_items[i].$1, color: c.accent, size: 18),
                                    ),
                                    if (!_read.contains(i))
                                      Positioned(
                                        top: -2, right: -2,
                                        child: Container(
                                          width: 10, height: 10,
                                          decoration: BoxDecoration(
                                            color: c.accentGold,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: c.bg, width: 2),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_items[i].$2,
                                          style: FTType.small(context).copyWith(
                                            fontWeight: _read.contains(i)
                                                ? FontWeight.w500
                                                : FontWeight.w700,
                                          )),
                                      const SizedBox(height: 4),
                                      Text(_items[i].$3,
                                          style: TextStyle(fontSize: 12, color: c.fg2)),
                                    ],
                                  ),
                                ),
                                Text(_items[i].$4,
                                    style: TextStyle(fontSize: 12, color: c.fg3)),
                              ],
                            ),
                          ),
                        ),
                        if (i < _items.length - 1) const FDivider(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
