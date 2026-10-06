import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'gift_game_theme.dart';
import 'widgets/confetti_layer.dart';
import 'widgets/gift_art.dart';
import 'widgets/gift_carousel.dart';
import 'widgets/ticket_badge.dart';

export 'gift_game_theme.dart';

enum GiftPhase { select, focus, opened }

class GiftGame extends StatefulWidget {
  const GiftGame({
    super.key,
    required this.tickets,
    this.theme = const GiftGameTheme(),
    this.onOpened,
    this.onCelebrationEnd,
    this.onBack,
    this.showDemoReplay = false,
  });

  final int tickets;
  final GiftGameTheme theme;
  final ValueChanged<int>? onOpened;
  final ValueChanged<int>? onCelebrationEnd;

  final VoidCallback? onBack;
  final bool showDemoReplay;

  @override
  State<GiftGame> createState() => GiftGameState();
}

class GiftGameState extends State<GiftGame> with TickerProviderStateMixin {
  GiftGameTheme get t => widget.theme;

  GiftPhase _phase = GiftPhase.select;
  late int _active = (t.giftCount - 1) ~/ 2;
  late int _tickets = widget.tickets;

  double _lift = 0;
  double _liftFrom = 0;
  bool _flying = false;
  bool _charging = false;
  int _taps = 0;
  bool _hintHidden = false;
  bool _raysOn = false;

  final _confetti = ConfettiController();
  final _stackKey = GlobalKey();

  late final AnimationController _lid = AnimationController(vsync: this);
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );
  late final AnimationController _jitter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
  );
  late final AnimationController _flash = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final AnimationController _rays = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );
  late final AnimationController _nudge = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..repeat(reverse: true);

  @override
  void didUpdateWidget(covariant GiftGame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tickets != oldWidget.tickets) {
      setState(() => _tickets = math.max(0, widget.tickets));
    }
  }

  @override
  void dispose() {
    for (final c in [_lid, _shake, _jitter, _flash, _rays, _nudge]) {
      c.dispose();
    }
    _confetti.dispose();
    super.dispose();
  }

  void _choose() {
    if (_phase != GiftPhase.select || _tickets <= 0) return;
    _resetStage();
    setState(() => _phase = GiftPhase.focus);
  }

  void _cancel() {
    if (_phase == GiftPhase.focus) setState(() => _phase = GiftPhase.select);
  }

  void reset() {
    _confetti.clear();
    setState(() {
      _phase = GiftPhase.select;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(_resetStage);
    });
  }

  void _resetStage() {
    _lid.stop();
    _lid.value = 0;
    _lift = 0;
    _liftFrom = 0;
    _flying = false;
    _charging = false;
    _taps = 0;
    _hintHidden = false;
    _raysOn = false;
    _rays.stop();
    _jitter.stop();
  }

  void _open() {
    if (_phase != GiftPhase.focus) return;
    final index = _active;
    setState(() {
      _phase = GiftPhase.opened;
      _tickets = math.max(
        0,
        _tickets - 1,
      ); // optimistic; the app confirms via `tickets`
      _hintHidden = true;
      _raysOn = true;
      _charging = false;
      _flying = true;
      _liftFrom = _lift;
    });
    _jitter.stop();
    _rays.repeat();
    _lid.duration = const Duration(milliseconds: 700);
    _lid.forward(from: 0);
    _flash.forward(from: 0);
    HapticFeedback.heavyImpact();
    widget.onOpened?.call(index);

    // fire confetti from the gift's opening
    final box = _giftRect(context);
    if (box != null) {
      _confetti.pop(
        Offset(box.center.dx, box.top + box.height * t.openPoint),
        box.width,
      );
    }
  }

  void _celebrationDone() {
    widget.onCelebrationEnd?.call(_active);
  }

  double _threshold(Rect gift) => gift.height * .16;

  void _dragStart(DragStartDetails d) {
    if (_phase != GiftPhase.focus || _flying) return;
    if (_lid.isAnimating) {
      _lid.stop();
      _lid.value = 1;
    }
  }

  void _dragUpdate(DragUpdateDetails d) {
    if (_phase != GiftPhase.focus) return;
    final gift = _giftRect(context);
    if (gift == null) return;
    setState(() {
      _lift = math.min(0.0, _lift + d.delta.dy);
      final charging = _lift * .75 < -_threshold(gift) * .5 * .75;
      if (charging != _charging) {
        _charging = charging;
        if (charging) {
          _jitter.repeat();
        } else {
          _jitter.stop();
        }
      }
    });
  }

  void _dragEnd(DragEndDetails d) {
    if (_phase != GiftPhase.focus) return;
    final gift = _giftRect(context);
    _jitter.stop();
    _charging = false;
    if (gift != null && _lift < -_threshold(gift)) return _open();
    _liftFrom = _lift;
    _lift = 0;
    _lid.duration = const Duration(milliseconds: 350);
    _lid.forward(from: 0);
    setState(() {});
  }

  void _tap() {
    if (_phase != GiftPhase.focus) return;
    _taps++;
    _shake.forward(from: 0);
    HapticFeedback.lightImpact();
    if (_taps >= 3) Timer(const Duration(milliseconds: 300), _open);
  }

  Rect? _giftRect(BuildContext context) {
    final size =
        (_stackKey.currentContext?.findRenderObject() as RenderBox?)?.size;
    if (size == null) return null;
    return _giftRectFor(size);
  }

  /// Gift on the open stage: 82% of the width, centred, nudged down slightly (CSS margin-top: 4vh).
  Rect _giftRectFor(Size s) {
    final w = s.width * .82;
    final h = w / t.giftAspect;
    return Rect.fromLTWH(
      (s.width - w) / 2,
      (s.height - h) / 2 + s.height * .02,
      w,
      h,
    );
  }

  // build

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final open = _phase != GiftPhase.select;

    return LayoutBuilder(
      builder: (context, c) {
        final size = Size(c.maxWidth, c.maxHeight);
        return Stack(
          key: _stackKey,
          children: [
            // background
            Positioned.fill(
              child: ClipRect(
                child: AnimatedScale(
                  scale: open ? 1.06 : 1,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.ease,
                  child: Image.asset(t.asset(t.background), fit: BoxFit.cover),
                ),
              ),
            ),

            _selectScreen(pad, size),
            _openScreen(pad, size),

            Positioned(
              top: pad.top + 14,
              left: 16,
              child: AnimatedOpacity(
                opacity: _phase == GiftPhase.opened ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: _phase == GiftPhase.opened,
                  child: _backButton(),
                ),
              ),
            ),

            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _flash,
                  builder: (context, _) {
                    final v = _flash.value;
                    if (v == 0 || v == 1) return const SizedBox.shrink();
                    final o = v < .15
                        ? .95 * v / .15
                        : .95 * (1 - Curves.easeOut.transform((v - .15) / .85));
                    return ColoredBox(color: Color.fromRGBO(255, 255, 255, o));
                  },
                ),
              ),
            ),

            Positioned.fill(
              child: ConfettiLayer(
                controller: _confetti,
                images: [for (final f in t.confetti) t.asset(f)],
                onDone: _celebrationDone,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _backButton() {
    return ClipOval(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Material(
          color: t.chipColor,
          child: InkWell(
            onTap: () =>
                _phase == GiftPhase.focus ? _cancel() : widget.onBack?.call(),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Icon(
                Icons.chevron_left_rounded,
                color: t.textColor,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // select screen

  Widget _selectScreen(EdgeInsets pad, Size size) {
    final visible = _phase == GiftPhase.select;
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !visible,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 350),
          child: AnimatedScale(
            scale: visible ? 1 : .94,
            duration: const Duration(milliseconds: 350),
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: pad.top + 60),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // the ticket overlaps the empty space above the gift art
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: TicketBadge.height - 10,
                                ),
                                child: GiftCarousel(
                                  theme: t,
                                  initialIndex: _active,
                                  onActiveChanged: (i) =>
                                      setState(() => _active = i),
                                  onTapActive: _choose,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: IgnorePointer(
                                  child: Center(
                                    child: TicketBadge(
                                      count: _tickets,
                                      theme: t,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _dots(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < t.giftCount; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == _active ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == _active ? Colors.white : const Color(0x66FFFFFF),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
      ],
    );
  }

  // open screen

  Widget _openScreen(EdgeInsets pad, Size size) {
    final visible = _phase != GiftPhase.select;
    final gift = _giftRectFor(size);
    final raysSize = size.width * 1.7;

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !visible,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: const Duration(milliseconds: 350),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _tap,
            onVerticalDragStart: _dragStart,
            onVerticalDragUpdate: _dragUpdate,
            onVerticalDragEnd: _dragEnd,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: (size.width - raysSize) / 2,
                  top: size.height / 2 - raysSize / 2,
                  width: raysSize,
                  height: raysSize,
                  child: AnimatedOpacity(
                    opacity: _raysOn ? .9 : 0,
                    duration: const Duration(milliseconds: 500),
                    child: AnimatedScale(
                      scale: _raysOn ? 1 : .4,
                      duration: const Duration(milliseconds: 700),
                      curve: const Cubic(.2, 1.4, .4, 1),
                      child: RotationTransition(
                        turns: _rays,
                        child: Image.asset(t.asset(t.rays)),
                      ),
                    ),
                  ),
                ),

                // the gift
                Positioned.fromRect(
                  rect: gift,
                  child: AnimatedOpacity(
                    opacity: visible ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedScale(
                      scale: visible ? 1 : .7,
                      duration: const Duration(milliseconds: 500),
                      curve: const Cubic(.2, 1.4, .4, 1),
                      child: AnimatedBuilder(
                        animation: Listenable.merge([_shake, _jitter, _lid]),
                        builder: (context, _) => Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.translationValues(
                            _charging
                                ? math.sin(_jitter.value * math.pi * 2) * 2
                                : 0.0,
                            0.0,
                            0.0,
                          )..multiply(
                              Matrix4.rotationZ(_shakeAngle(_shake.value)),
                            ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                t.asset(t.giftBottom),
                                fit: BoxFit.fill,
                                gaplessPlayback: true,
                              ),
                              _lidLayer(gift),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: pad.bottom + 56,
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: _hintHidden ? 0 : 1,
                      duration: const Duration(milliseconds: 300),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _nudge,
                            builder: (context, child) => Transform.translate(
                              offset: Offset(
                                0,
                                -8 * Curves.easeInOut.transform(_nudge.value),
                              ),
                              child: child,
                            ),
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              color: t.textColor,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            t.openHint,
                            style: TextStyle(
                              color: t.textColor,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              shadows: const [
                                Shadow(
                                  color: Color(0x4D000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// CSS keyframes: 20% -6deg, 40% 5deg, 60% -3deg, 80% 2deg.
  double _shakeAngle(double v) {
    if (v == 0 || v == 1) return 0;
    const keys = [0.0, -6.0, 5.0, -3.0, 2.0, 0.0];
    final x = v * 5;
    final i = math.min(4, math.max(0, x.floor()));
    final f = Curves.easeInOut.transform(x - i);
    return (keys[i] + (keys[i + 1] - keys[i]) * f) * math.pi / 180;
  }

  Widget _lidLayer(Rect gift) {
    final top = Image.asset(
      t.asset(t.giftTop),
      fit: BoxFit.fill,
      gaplessPlayback: true,
    );
    double ty, rotDeg;
    double tx = 0.0, opacity = 1.0;
    if (_flying) {
      // fly up and away from wherever the finger left it
      final f = const Cubic(.2, .7, .3, 1).transform(_lid.value);
      ty = _lerp(_liftFrom * .75, -1.2 * gift.height, f);
      tx = .3 * gift.width * f;
      rotDeg = _lerp(-_liftFrom * .75 * .03, 28, f);
      opacity = 1 - Curves.ease.transform(_lid.value);
    } else if (_lid.isAnimating) {
      // snap back with overshoot
      final f = const Cubic(.2, 1.6, .4, 1).transform(_lid.value);
      final lift = _liftFrom * .75 * (1 - f);
      ty = lift;
      rotDeg = -lift * .03;
    } else {
      ty = _lift * .75;
      rotDeg = -ty * .03;
    }
    return Opacity(
      opacity: math.min(1.0, math.max(0.0, opacity)),
      child: Transform(
        alignment: t.topPivot,
        transform: Matrix4.translationValues(tx, ty, 0.0)
          ..multiply(Matrix4.rotationZ(rotDeg * math.pi / 180)),
        child: top,
      ),
    );
  }

  static double _lerp(double a, double b, double f) => a + (b - a) * f;
}

// keeps GiftArt exported for hosts that want to show the gift elsewhere (e.g. a Play-tab tile)
typedef GiftGameArt = GiftArt;
