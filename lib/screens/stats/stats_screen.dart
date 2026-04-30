import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/buttons.dart';
import '../../widgets/donut_chart.dart';
import '../../widgets/feedback.dart';
import '../../widgets/glass.dart';
import '../../widgets/list_row.dart';
import '../../widgets/money_display.dart';
import '../../widgets/top_bar.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});
  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _metric = 'out';
  int _selDay = 2;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 80), () {
        if (mounted) setState(() => _ready = true);
      });
    });
  }

  void _setMetric(String m) {
    setState(() {
      _metric = m;
      _ready = false;
    });
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    final maxV = kBars.fold<double>(0, (m, b) => [m, b.out, b.inAmt].reduce((a, b) => a > b ? a : b));

    final palette = [c.accent, c.accentGold, c.positive, c.fg2, c.fg3];
    final slices = [
      for (int i = 0; i < kCategories.length; i++)
        DonutSlice(value: kCategories[i].value, color: palette[i % palette.length], label: kCategories[i].name),
    ];

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 140),
      children: [
        FintinoTopBar(
          title: 'Insights',
          subtitle: 'This week · Oct 18–24',
          trailing: GlassIconButton(
            icon: Icons.calendar_today_rounded,
            accent: true,
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(now.year - 2),
                lastDate: now,
                initialDateRange: DateTimeRange(
                  start: now.subtract(const Duration(days: 6)),
                  end: now,
                ),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: Theme.of(ctx).colorScheme.copyWith(primary: c.accent),
                  ),
                  child: child!,
                ),
              );
              if (picked != null && context.mounted) {
                showFeedback(context,
                    'Range updated · ${picked.duration.inDays + 1} days', icon: Icons.event_rounded);
              }
            },
          ),
        ),
        // Bar-chart card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [c.glassHi, c.glass],
              ),
              borderRadius: BorderRadius.circular(FT.rLg),
              border: Border.all(color: c.border),
              boxShadow: [
                BoxShadow(color: c.accentGlow.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 10)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: _MetricBtn(label: 'Spent', value: 1228.40, active: _metric == 'out', onTap: () => _setMetric('out'), countKey: _metric)),
                  const SizedBox(width: 12),
                  Expanded(child: _MetricBtn(label: 'Earned', value: 1820.00, active: _metric == 'in', onTap: () => _setMetric('in'), countKey: _metric)),
                ]),
                const SizedBox(height: 22),
                SizedBox(
                  height: 150,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(kBars.length, (i) {
                      final b = kBars[i];
                      final v = _metric == 'out' ? b.out : b.inAmt;
                      final tgt = (v / maxV * 116).clamp(8, 116).toDouble();
                      final on = i == _selDay;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selDay = i),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 600 + i * 50),
                                      curve: FT.easeOut,
                                      width: double.infinity,
                                      height: _ready ? tgt : 8,
                                      decoration: BoxDecoration(
                                        gradient: on
                                            ? LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [c.accent, c.accent.withOpacity(0.55)],
                                              )
                                            : null,
                                        color: on ? null : c.fg.withOpacity(0.07),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: on
                                            ? [BoxShadow(color: c.accentGlow, blurRadius: 14)]
                                            : null,
                                      ),
                                    ),
                                    if (on)
                                      Positioned(
                                        top: -32,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: c.fg,
                                            borderRadius: BorderRadius.circular(7),
                                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8)],
                                          ),
                                          child: Text('\$${v.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: c.bg,
                                                fontFeatures: const [FontFeature.tabularFigures()],
                                              )),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(b.d,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: on ? c.accent : c.fg3,
                                      fontWeight: on ? FontWeight.w700 : FontWeight.w400,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: c.glassHi,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: c.border),
                  ),
                  child: Row(children: [
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(color: c.accent, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(kBars[_selDay].date, style: FTType.small(context)),
                          const SizedBox(height: 4),
                          Row(children: [
                            if (kBars[_selDay].inAmt > 0)
                              Text('+\$${kBars[_selDay].inAmt.toStringAsFixed(0)} ',
                                  style: FTType.small(context).copyWith(color: c.positive)),
                            if (kBars[_selDay].out > 0)
                              Text('−\$${kBars[_selDay].out.toStringAsFixed(0)}', style: FTType.small(context)),
                          ]),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, size: 16, color: c.fg3),
                  ]),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 16, 12),
          child: Row(children: [
            Text('Top categories', style: FTType.h3(context)),
            const Spacer(),
            Text('Oct', style: FTType.label(context)),
          ]),
        ),
        // Donut + legend card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Glass(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                DonutChart(
                  slices: slices,
                  size: 200,
                  strokeWidth: 24,
                  centerSub: 'TOTAL',
                  centerLabel: '\$1,228',
                ),
                const SizedBox(height: 16),
                for (int i = 0; i < kCategories.length; i++) ...[
                  _legendRow(context, kCategories[i], palette[i % palette.length], i),
                  if (i < kCategories.length - 1)
                    Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: const FDivider()),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _legendRow(BuildContext context, CategoryStat cat, Color clr, int i) {
    final c = context.c;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Container(
          width: 10, height: 10,
          decoration: BoxDecoration(
            color: clr,
            borderRadius: BorderRadius.circular(3),
            boxShadow: [BoxShadow(color: clr.withOpacity(0.5), blurRadius: 6)],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(cat.name, style: FTType.small(context).copyWith(fontWeight: FontWeight.w600)),
        ),
        Text('${cat.pct}%', style: TextStyle(fontSize: 12, color: c.fg2)),
        const SizedBox(width: 12),
        SizedBox(
          width: 64,
          child: Text('\$${cat.value.toStringAsFixed(0)}',
              textAlign: TextAlign.right,
              style: FTType.small(context).copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
        ),
      ]),
    );
  }
}

class _MetricBtn extends StatelessWidget {
  final String label;
  final double value;
  final bool active;
  final VoidCallback onTap;
  final Object countKey;
  const _MetricBtn({required this.label, required this.value, required this.active, required this.onTap, required this.countKey});

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: FT.durNormal,
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        decoration: BoxDecoration(
          color: active ? c.accentDim : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: active ? c.accent.withOpacity(0.5) : c.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 6, height: 6,
                decoration: BoxDecoration(
                  color: active ? c.accent : c.fg3,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(label, style: FTType.label(context).copyWith(color: active ? c.accent : c.fg3)),
            ]),
            const SizedBox(height: 8),
            MoneyDisplay(value: value, size: 24, duration: const Duration(milliseconds: 700), countKey: countKey),
          ],
        ),
      ),
    );
  }
}
