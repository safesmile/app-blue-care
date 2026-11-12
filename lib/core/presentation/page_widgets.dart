import 'package:flutter/material.dart';

class PageFrame extends StatelessWidget {
  const PageFrame({super.key, required this.children, this.headerGap = 8});
  final List<Widget> children;
  final double headerGap;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    'assets/images/logo_${dark ? 'dark' : 'light'}.png',
                    width: 241,
                    height: 80,
                    fit: BoxFit.contain,
                    semanticLabel: 'Blue Care',
                  ),
                ),
                SizedBox(height: headerGap),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoNote extends StatelessWidget {
  const InfoNote(
    this.text, {
    super.key,
    this.icon = Icons.verified_user_outlined,
  });
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final teal = dark ? const Color(0xFF46DDD4) : const Color(0xFF00858C);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF123B40) : const Color(0xFFE2F8F3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: teal, size: 23),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                letterSpacing: 0,
                color: teal,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.children,
    this.navy = false,
    this.height,
  });
  final List<Widget> children;
  final bool navy;
  final double? height;
  @override
  Widget build(BuildContext context) => Container(
    constraints: BoxConstraints(minHeight: height ?? 0),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: navy
          ? const Color(0xFF0D2E78)
          : Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF142439)
          : const Color(0xFFEAF2FF),
      borderRadius: BorderRadius.circular(24),
    ),
    child: DefaultTextStyle.merge(
      style: TextStyle(
        letterSpacing: 0,
        color: navy ? Colors.white : Theme.of(context).colorScheme.onSurface,
        height: 1.45,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    ),
  );
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(text, style: Theme.of(context).textTheme.headlineMedium),
  );
}

class PageBody extends StatelessWidget {
  const PageBody(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.bodyMedium);
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
    this.text,
    this.onPressed, {
    super.key,
    this.busy = false,
  });
  final String text;
  final VoidCallback? onPressed;
  final bool busy;
  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: busy ? null : onPressed,
    child: busy
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(text, textAlign: TextAlign.center),
  );
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(this.text, this.onPressed, {super.key});
  final String text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => OutlinedButton(
    onPressed: onPressed,
    child: Text(text, textAlign: TextAlign.center),
  );
}

class LinkButton extends StatelessWidget {
  const LinkButton(this.text, this.onPressed, {super.key});
  final String text;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => Center(
    child: TextButton(
      onPressed: onPressed,
      child: Text(text, textAlign: TextAlign.center),
    ),
  );
}

class FeatureTitle extends StatelessWidget {
  const FeatureTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      letterSpacing: 0,
      fontSize: 26,
      fontWeight: FontWeight.w700,
      height: 1.35,
    ),
  );
}

class SuccessIcon extends StatelessWidget {
  const SuccessIcon(this.icon, {super.key, this.blue = false});
  final IconData icon;
  final bool blue;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 136,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: blue
            ? (dark ? const Color(0xFF142439) : const Color(0xFFEAF2FF))
            : (dark ? const Color(0xFF123B40) : const Color(0xFFE2F8F3)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        icon,
        size: 60,
        color: blue
            ? Theme.of(context).colorScheme.primary
            : const Color(0xFF00858C),
      ),
    );
  }
}
