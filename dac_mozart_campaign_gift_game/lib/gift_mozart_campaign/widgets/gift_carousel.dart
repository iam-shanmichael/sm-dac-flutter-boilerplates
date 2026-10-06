import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../gift_game_theme.dart';
import 'gift_art.dart';

/// Swipeable row of identical gifts. The centre gift is full size and bobs; neighbours shrink,
/// tilt and fade, and peek in from the sides.
///
/// A transparent PageView handles swiping/snapping; the gifts themselves are drawn in a Stack
/// so the centre one can always sit on top of its neighbours.
class GiftCarousel extends StatefulWidget {
  const GiftCarousel({
    super.key,
    required this.theme,
    required this.initialIndex,
    required this.onActiveChanged,
    required this.onTapActive,
  });

  final GiftGameTheme theme;
  final int initialIndex;
  final ValueChanged<int> onActiveChanged;
  final VoidCallback onTapActive;

  static const double viewportFraction = .64;

  @override
  State<GiftCarousel> createState() => _GiftCarouselState();
}

class _GiftCarouselState extends State<GiftCarousel> with SingleTickerProviderStateMixin {
  late final PageController _pc =
      PageController(viewportFraction: GiftCarousel.viewportFraction, initialPage: widget.initialIndex);
  late final AnimationController _bob =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
  late final Animation<double> _bobT = CurvedAnimation(parent: _bob, curve: Curves.easeInOut);
  late int _active = widget.initialIndex;

  @override
  void dispose() {
    _pc.dispose();
    _bob.dispose();
    super.dispose();
  }

  double get _page =>
      _pc.hasClients && _pc.position.haveDimensions ? (_pc.page ?? _active.toDouble()) : widget.initialIndex.toDouble();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final width = c.maxWidth;
      final itemW = width * GiftCarousel.viewportFraction;
      final itemH = itemW / widget.theme.giftAspect;
      final count = widget.theme.giftCount;

      return SizedBox(
        height: itemH,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pc, _bobT]),
          builder: (context, _) {
            final page = _page;
            final order = List<int>.generate(count, (i) => i)
              ..sort((a, b) => (b - page).abs().compareTo((a - page).abs())); // far first, nearest last
            return Stack(clipBehavior: Clip.none, children: [
              for (final i in order) _item(i, page, width, itemW, itemH),
              Positioned.fill(
                child: PageView.builder(
                  controller: _pc,
                  itemCount: count,
                  onPageChanged: (i) {
                    setState(() => _active = i);
                    widget.onActiveChanged(i);
                  },
                  itemBuilder: (context, i) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (i == _active) {
                        widget.onTapActive();
                      } else {
                        _pc.animateToPage(i, duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
                      }
                    },
                  ),
                ),
              ),
            ]);
          },
        ),
      );
    });
  }

  Widget _item(int i, double page, double width, double itemW, double itemH) {
    final d = i - page; // -1..1 = one gift away
    final ad = math.min(d.abs(), 1.5);
    final isActive = i == _active;
    final left = width / 2 - itemW / 2 + d * itemW - d * .24 * itemW;
    final bob = isActive ? _bobT.value : 0.0;

    return Positioned(
      left: left,
      top: 0,
      width: itemW,
      height: itemH,
      child: IgnorePointer(
        child: Opacity(
          opacity: 1 - ad * .45, // ad <= 1.5, so this stays above 0.3
          child: Transform(
            alignment: const Alignment(0, .4), // CSS transform-origin: 50% 70%
            transform: Matrix4.diagonal3Values(1 - ad * .24, 1 - ad * .24, 1.0)
              ..multiply(Matrix4.rotationZ(d * 4 * math.pi / 180)),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.translationValues(0.0, -10 * bob, 0.0)
                ..multiply(Matrix4.rotationZ(-1.5 * math.pi / 180 * bob)),
              child: GiftArt(theme: widget.theme, glow: isActive),
            ),
          ),
        ),
      ),
    );
  }
}
