import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../gift_game_theme.dart';

class TicketBadge extends StatefulWidget {
  const TicketBadge({super.key, required this.count, required this.theme});

  final int count;
  final GiftGameTheme theme;
  static const double height = 57;

  @override
  State<TicketBadge> createState() => _TicketBadgeState();
}

class _TicketBadgeState extends State<TicketBadge>
    with TickerProviderStateMixin {
  late final AnimationController _pop = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2600))
    ..repeat();
  late final AnimationController _glint = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 3200))
    ..repeat();

  @override
  void dispose() {
    _pop.dispose();
    _glint.dispose();
    super.dispose();
  }

  double _popAmount(double t) {
    if (t < .8) return 0;
    if (t < .88) return Curves.easeInOut.transform((t - .8) / .08);
    return 1 - Curves.easeInOut.transform((t - .88) / .12);
  }

  @override
  Widget build(BuildContext context) {
    final empty = widget.count <= 0;
    final label = empty
        ? 'No tickets left'
        : '${widget.count} Ticket${widget.count > 1 ? 's' : ''}';
    const shape = _TicketShape(notchRadius: 12, radius: 14);

    final badge = Container(
      height: TicketBadge.height,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        shape: shape,
        gradient: widget.theme.ticketGradient,
        shadows: const [
          BoxShadow(
              color: Color(0x59000000), blurRadius: 14, offset: Offset(0, 6))
        ],
      ),
      child: Text(
        label,
        maxLines: 1,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
          letterSpacing: .3,
          height: 1.1,
          color: widget.theme.ticketTextColor,
          shadows: const [
            Shadow(color: Color(0x8CFFFFFF), offset: Offset(0, 1))
          ],
        ),
      ),
    );

    if (empty) return Opacity(opacity: .55, child: badge);

    return AnimatedBuilder(
      animation: Listenable.merge([_pop, _glint]),
      child: badge,
      builder: (context, child) {
        final p = _popAmount(_pop.value);
        // glint: parked off-screen until 55%, sweeps across by 85%
        final g = _glint.value < .55
            ? 0.0
            : _glint.value > .85
                ? 1.0
                : Curves.easeInOut.transform((_glint.value - .55) / .3);
        return Transform.rotate(
          angle: -2 * math.pi / 180 * p,
          child: Transform.scale(
            scale: 1 + .08 * p,
            child: Stack(
              children: [
                child!,
                Positioned.fill(
                  child: ClipPath(
                    clipper: const ShapeBorderClipper(shape: shape),
                    child: LayoutBuilder(
                      builder: (context, c) {
                        final w = c.maxWidth;
                        return Stack(children: [
                          Positioned(
                            left: (-0.6 + 1.9 * g) * w,
                            top: 0,
                            bottom: 0,
                            width: w * .45,
                            child: Transform(
                              transform: Matrix4.skewX(-0.36),
                              alignment: Alignment.center,
                              child: const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color(0x00FFFFFF),
                                    Color(0xD9FFFFFF),
                                    Color(0x00FFFFFF)
                                  ]),
                                ),
                              ),
                            ),
                          ),
                        ]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Rounded rectangle with a half-circle notch cut out of the middle of each side.
class _TicketShape extends ShapeBorder {
  const _TicketShape({required this.notchRadius, required this.radius});

  final double notchRadius;
  final double radius;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final body = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));
    final notches = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(rect.left, rect.center.dy), radius: notchRadius))
      ..addOval(Rect.fromCircle(
          center: Offset(rect.right, rect.center.dy), radius: notchRadius));
    return Path.combine(PathOperation.difference, body, notches);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      getOuterPath(rect, textDirection: textDirection);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) =>
      _TicketShape(notchRadius: notchRadius * t, radius: radius * t);
}
