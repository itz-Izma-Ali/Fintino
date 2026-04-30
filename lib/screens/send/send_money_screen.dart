import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../data/mock/mock_data.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/glass.dart';
import '../../widgets/press.dart';
import '../../widgets/top_bar.dart';
import 'receipt_screen.dart';
import 'slide_to_send.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});
  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  int _sel = 0;
  String _amount = '450';

  void _key(String k) {
    setState(() {
      if (k == '⌫') {
        _amount = _amount.length > 1 ? _amount.substring(0, _amount.length - 1) : '0';
      } else if (k == '.') {
        return;
      } else {
        if (_amount == '0') {
          _amount = k;
        } else if (_amount.length < 8) {
          _amount = _amount + k;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 30),
            children: [
              const FintinoTopBar(title: 'Send money', subtitle: 'Select contact & amount'),
              SizedBox(
                height: 96,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: kContacts.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final on = i == _sel;
                    return Press(
                      onTap: () => setState(() => _sel = i),
                      child: SizedBox(
                        width: 62,
                        child: Column(
                          children: [
                            AnimatedContainer(
                              duration: FT.durNormal,
                              curve: FT.easeSp,
                              width: 54, height: 54,
                              decoration: BoxDecoration(
                                color: c.glassHi,
                                shape: BoxShape.circle,
                                border: Border.all(color: on ? c.accent : Colors.transparent, width: 2),
                                boxShadow: on ? [BoxShadow(color: c.accentGlow, blurRadius: 16)] : null,
                              ),
                              child: Center(
                                child: Text(kContacts[i].name[0],
                                    style: TextStyle(color: c.accent, fontWeight: FontWeight.w700, fontSize: 18)),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(kContacts[i].name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: on ? c.fg : c.fg2,
                                  fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Glass(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                  child: Column(
                    children: [
                      Text('AMOUNT · USD', style: FTType.label(context)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('\$',
                              style: TextStyle(fontSize: 52, fontWeight: FontWeight.w700, color: c.fg2, letterSpacing: -1.56)),
                          Text(_amount.isEmpty ? '0' : _amount,
                              style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w700,
                                  color: c.fg,
                                  letterSpacing: -1.56,
                                  fontFeatures: const [FontFeature.tabularFigures()])),
                          Text('.00',
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: c.fg3, letterSpacing: -0.56)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('Available · \$12,840.50', style: FTType.small(context)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Glass(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.4,
                    children: [
                      for (final k in ['1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '0', '⌫'])
                        Press(
                          onTap: () => _key(k),
                          child: Center(
                            child: Text(k,
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: c.fg)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SlideToSend(
                  amount: _amount,
                  recipient: kContacts[_sel].name,
                  onSuccess: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => ReceiptScreen(amount: _amount, recipient: kContacts[_sel].name),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
