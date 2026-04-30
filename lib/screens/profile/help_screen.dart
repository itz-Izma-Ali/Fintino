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
import '../common/placeholder_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _topics = [
    (Icons.credit_card, 'Cards & accounts', 'Manage, freeze, or close cards'),
    (Icons.send, 'Sending money', 'Send & request funds from friends'),
    (Icons.shield_outlined, 'Security', 'Keep your account safe & secure'),
    (Icons.notifications_outlined, 'Notifications', 'Manage alerts & preferences'),
    (Icons.description_outlined, 'Statements', 'View & download statements'),
    (Icons.help_outline, 'Contact support', 'Chat with our support team'),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 40),
            children: [
              const FintinoTopBar(title: 'Help center', subtitle: 'How can we help?'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Glass(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      for (int i = 0; i < _topics.length; i++) ...[
                        Press(
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PlaceholderScreen(
                                    title: _topics[i].$2,
                                    subtitle: _topics[i].$3,
                                    icon: _topics[i].$1,
                                    description: 'Browse FAQs about ${_topics[i].$2.toLowerCase()} or chat with support.',
                                    bullets: const [
                                      (icon: Icons.menu_book_outlined, label: 'Read related articles'),
                                      (icon: Icons.chat_bubble_outline, label: 'Live chat with an agent'),
                                      (icon: Icons.email_outlined, label: 'Email support@fintino.bank'),
                                    ],
                                    primaryActionLabel: 'Start a chat',
                                  ))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(color: c.accentDim, borderRadius: BorderRadius.circular(12)),
                                child: Icon(_topics[i].$1, color: c.accent, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_topics[i].$2, style: FTType.small(context)),
                                    const SizedBox(height: 4),
                                    Text(_topics[i].$3, style: TextStyle(fontSize: 12, color: c.fg2)),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward, size: 16, color: c.fg3),
                            ]),
                          ),
                        ),
                        if (i < _topics.length - 1) const FDivider(),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Btn(
                  label: 'Email support',
                  icon: Icons.mail_outline,
                  ghost: true,
                  full: true,
                  onTap: () => showFeedback(context, 'Drafting email to support@fintino.bank',
                      icon: Icons.mail_outline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
