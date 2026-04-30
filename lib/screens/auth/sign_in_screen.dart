import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/tokens.dart';
import '../../widgets/aurora_background.dart';
import '../../widgets/buttons.dart';
import '../../widgets/feedback.dart';
import '../../widgets/glass.dart';
import '../../widgets/press.dart';
import '../../widgets/top_bar.dart';
import '../main_shell.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  void _enter(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainShell()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const FintinoTopBar(title: 'Sign in.', subtitle: 'Welcome back, Tino'),
              const SizedBox(height: 12),
              Glass(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('EMAIL', style: FTType.label(context)),
                    const SizedBox(height: 8),
                    _Field(initial: 'tino@aperture.bank'),
                    const SizedBox(height: 24),
                    Text('PASSWORD', style: FTType.label(context)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _Field(initial: '••••••••••', obscure: true)),
                        Icon(Icons.visibility_off_outlined, size: 17, color: c.fg3),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Press(
                        onTap: () => showFeedback(context, 'Reset link sent to tino@aperture.bank',
                            icon: Icons.mark_email_read_outlined),
                        child: Text('Forgot password?',
                            style: FTType.small(context).copyWith(color: c.accent)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Btn(label: 'Sign in', full: true, onTap: () => _enter(context)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: Container(height: 1, color: c.divider)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('OR', style: FTType.label(context)),
                ),
                Expanded(child: Container(height: 1, color: c.divider)),
              ]),
              const SizedBox(height: 16),
              Press(
                onTap: () => _enter(context),
                child: Glass(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Icon(Icons.fingerprint, color: c.accent),
                    const SizedBox(width: 12),
                    Text('Face ID / Touch ID', style: FTType.small(context)),
                  ]),
                ),
              ),
              const SizedBox(height: 12),
              Press(
                onTap: () => _enter(context),
                child: Glass(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    Icon(Icons.key_rounded, color: c.fg2),
                    const SizedBox(width: 12),
                    Text('Use Passkey', style: FTType.small(context)),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String initial;
  final bool obscure;
  const _Field({required this.initial, this.obscure = false});
  @override
  Widget build(BuildContext context) {
    final c = context.c;
    return TextFormField(
      initialValue: initial,
      obscureText: obscure,
      readOnly: true,
      style: TextStyle(fontSize: 16, color: c.fg),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
        border: UnderlineInputBorder(borderSide: BorderSide(color: c.divider)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: c.divider)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: c.accent)),
      ),
    );
  }
}
