import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/glass.dart';
import '../../widgets/list_row.dart';
import '../../widgets/press.dart';
import '../../widgets/top_bar.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _lang = 'en';
  static const _langs = [
    ('en', 'English', '🇺🇸'),
    ('es', 'Español', '🇪🇸'),
    ('fr', 'Français', '🇫🇷'),
    ('de', 'Deutsch', '🇩🇪'),
    ('ja', '日本語', '🇯🇵'),
    ('zh', '中文', '🇨🇳'),
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
              const FintinoTopBar(title: 'Language', subtitle: 'Choose your preferred language'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Glass(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      for (int i = 0; i < _langs.length; i++) ...[
                        Press(
                          onTap: () => setState(() => _lang = _langs[i].$1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(children: [
                              Container(
                                width: 42, height: 42,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: c.glassHi, borderRadius: BorderRadius.circular(50)),
                                child: Text(_langs[i].$3, style: const TextStyle(fontSize: 24)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(_langs[i].$2, style: FTType.small(context))),
                              if (_lang == _langs[i].$1)
                                Icon(Icons.check, size: 16, color: c.accent),
                            ]),
                          ),
                        ),
                        if (i < _langs.length - 1) const FDivider(),
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
