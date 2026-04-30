import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/buttons.dart';
import '../../widgets/feedback.dart';
import '../../widgets/glass.dart';
import '../../widgets/list_row.dart';
import '../../widgets/top_bar.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});
  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  bool _edit = false;
  static const _fields = [
    (Icons.person, 'First name', 'Tino'),
    (Icons.person, 'Last name', 'Well'),
    (Icons.mail_outline, 'Email', 'tino@aperture.bank'),
    (Icons.phone, 'Phone', '+1 (555) 123-4567'),
    (Icons.calendar_today, 'Date of birth', 'January 15, 1992'),
    (Icons.location_on_outlined, 'Address', '123 Mission St, SF CA 94103'),
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
              FintinoTopBar(
                title: 'Personal details',
                trailing: GlassIconButton(
                  icon: _edit ? Icons.check : Icons.edit_outlined,
                  onTap: () {
                    if (_edit) {
                      showFeedback(context, 'Profile changes saved',
                          icon: Icons.check_circle_rounded);
                    }
                    setState(() => _edit = !_edit);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Glass(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      for (int i = 0; i < _fields.length; i++) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 38, height: 38,
                                decoration: BoxDecoration(color: c.glassHi, borderRadius: BorderRadius.circular(11)),
                                child: Icon(_fields[i].$1, size: 17, color: c.fg2),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_fields[i].$2, style: FTType.label(context)),
                                    const SizedBox(height: 4),
                                    if (_edit)
                                      TextFormField(
                                        initialValue: _fields[i].$3,
                                        style: TextStyle(fontSize: 15, color: c.fg),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: const EdgeInsets.symmetric(vertical: 6),
                                          border: UnderlineInputBorder(borderSide: BorderSide(color: c.accent)),
                                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: c.accent)),
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: c.accent)),
                                        ),
                                      )
                                    else
                                      Text(_fields[i].$3, style: FTType.small(context)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (i < _fields.length - 1) const FDivider(),
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
