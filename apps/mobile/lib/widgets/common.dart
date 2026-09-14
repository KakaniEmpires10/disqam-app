import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

void openPage(BuildContext context, Widget page) =>
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.headerAction,
    this.controller,
    this.isHome = false,
    this.showTitle = true,
    this.eyebrow,
    this.bottom,
  });
  final String title;
  final String? subtitle, eyebrow;
  final List<Widget> children;
  final Widget? headerAction, bottom;
  final ScrollController? controller;
  final bool isHome, showTitle;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (isHome)
                    const BrandLockup()
                  else
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                      label: const Text('Kembali'),
                    ),
                  ?headerAction,
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (showTitle) ...[
                        if (eyebrow != null) ...[
                          Eyebrow(eyebrow!),
                          const SizedBox(height: 10),
                        ],
                        Semantics(
                          header: true,
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        const SizedBox(height: 28),
                      ],
                      ...children,
                    ],
                  ),
                ),
              ),
            ),
          ),
          ?bottom,
        ],
      ),
    ),
  );
}

class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/mark.webp',
          width: 36,
          height: 36,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        ),
        const SizedBox(width: 6),
        const Flexible(
          child: Text(
            'DISQAM',
            style: TextStyle(
              fontSize: 21,
              letterSpacing: 1.3,
              fontWeight: FontWeight.w800,
              color: DisqamColors.navy,
            ),
          ),
        ),
      ],
    ),
  );
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.light = false});
  final String text;
  final bool light;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 16,
      height: 1.3,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.1,
      color: light ? const Color(0xFFB5E5E9) : DisqamColors.primary,
    ),
  );
}

class NightSurface extends StatelessWidget {
  const NightSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.moon = true,
    this.motifSize = 230,
  });
  final Widget child;
  final EdgeInsets padding;
  final bool moon;
  final double motifSize;
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [DisqamColors.navy, Color(0xFF123E57)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -motifSize * .21,
            top: -motifSize * .2,
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: SizedBox(
                  width: motifSize,
                  height: motifSize,
                  child: CustomPaint(painter: NightPainter(moon: moon)),
                ),
              ),
            ),
          ),
          Padding(
            padding: padding,
            child: DefaultTextStyle.merge(
              style: const TextStyle(color: Colors.white),
              child: child,
            ),
          ),
        ],
      ),
    ),
  );
}

/// Vector motif derived from DISQAM's crescent, not a simulated sleep chart.
class NightPainter extends CustomPainter {
  const NightPainter({this.moon = true});
  final bool moon;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .56, size.height * .48);
    final line = Paint()
      ..color = const Color(0xFF82D1D8).withValues(alpha: .18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final radius in [60.0, 88.0, 116.0]) {
      canvas.drawCircle(center, radius, line);
    }
    if (moon) {
      final base = Path()..addOval(Rect.fromCircle(center: center, radius: 32));
      final cut = Path()
        ..addOval(
          Rect.fromCircle(center: center.translate(15, -9), radius: 29),
        );
      canvas.drawPath(
        Path.combine(PathOperation.difference, base, cut),
        Paint()..color = const Color(0xFFF3BC58),
      );
    }
    for (final point in [
      const Offset(.25, .26),
      const Offset(.73, .72),
      const Offset(.25, .81),
    ]) {
      final p = Offset(size.width * point.dx, size.height * point.dy);
      canvas.drawCircle(p, 2.5, Paint()..color = const Color(0xFFB5E5E9));
    }
    canvas.drawArc(
      Rect.fromCenter(center: center, width: 176, height: 176),
      .25,
      math.pi / 2,
      false,
      Paint()
        ..color = const Color(0xFF82D1D8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(NightPainter oldDelegate) => oldDelegate.moon != moon;
}

class InfoBox extends StatelessWidget {
  const InfoBox(this.text, {super.key, this.warm = false, this.label});
  final String text;
  final bool warm;
  final String? label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
    decoration: BoxDecoration(
      color: warm ? DisqamColors.accentSoft : DisqamColors.surfaceAlt,
      border: Border(
        left: BorderSide(
          width: 3,
          color: warm ? const Color(0xFFDFA337) : DisqamColors.primary,
        ),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
        ],
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: DisqamColors.text),
        ),
      ],
    ),
  );
}

/// Compact open navigation row. Primary features have their own compositions.
class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.asset,
    this.icon,
    this.number,
    this.submenu = false,
  });
  final String title, subtitle;
  final VoidCallback onTap;
  final String? asset, number;
  final IconData? icon;
  final bool submenu;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: submenu ? const EdgeInsets.only(top: 14) : EdgeInsets.zero,
        padding: submenu
            ? const EdgeInsets.all(16)
            : const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: submenu ? Colors.white : null,
          borderRadius: submenu ? BorderRadius.circular(12) : null,
          border: submenu
              ? const Border(
                  left: BorderSide(color: DisqamColors.primary, width: 3),
                )
              : const Border(bottom: BorderSide(color: DisqamColors.border)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (asset != null) ...[
              Image.asset(
                asset!,
                width: 50,
                height: 50,
                excludeFromSemantics: true,
              ),
              const SizedBox(width: 16),
            ] else if (number != null || icon != null) ...[
              SizedBox(
                width: number == null
                    ? 32
                    : MediaQuery.textScalerOf(context).scale(28),
                child: number != null
                    ? Text(
                        number!,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: DisqamColors.primary,
                        ),
                      )
                    : Icon(icon, color: DisqamColors.primary),
              ),
              const SizedBox(width: 14),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 20,
              color: DisqamColors.primary,
            ),
          ],
        ),
      ),
    ),
  );
}

class PointText extends StatelessWidget {
  const PointText(this.text, {super.key, this.number});
  final String text;
  final int? number;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (number != null)
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 14),
            decoration: const BoxDecoration(
              color: DisqamColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: const TextStyle(
                fontSize: 16,
                color: DisqamColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.only(top: 9, right: 14),
            child: Icon(Icons.circle, size: 6, color: DisqamColors.primary),
          ),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    ),
  );
}
