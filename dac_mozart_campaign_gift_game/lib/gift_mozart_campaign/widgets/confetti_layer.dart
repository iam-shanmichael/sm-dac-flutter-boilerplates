import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// One pop of icon confetti (coins, vouchers...) fired from a point, then falling away.
/// Physics match the web prototype frame-for-frame at 60 fps.
class ConfettiController extends ChangeNotifier {
  Offset? _origin;
  double _spread = 0;
  int _shot = 0;

  /// Fire a burst from [origin] (in the confetti layer's coordinates). [spread] = gift width.
  void pop(Offset origin, double spread) {
    _origin = origin;
    _spread = spread;
    _shot++;
    notifyListeners();
  }

  void clear() {
    _origin = null;
    _shot++;
    notifyListeners();
  }
}

class ConfettiLayer extends StatefulWidget {
  const ConfettiLayer({super.key, required this.controller, required this.images, required this.onDone});

  final ConfettiController controller;

  /// Asset paths of the confetti icons.
  final List<String> images;
  final VoidCallback onDone;

  static const int popCount = 120; // icons in the pop
  static const double iconMin = 34, iconMax = 66; // on-screen size
  static const int life = 120; // frames each icon lives (~2 s)

  @override
  State<ConfettiLayer> createState() => _ConfettiLayerState();
}

class _Piece {
  _Piece(this.img, this.x, this.y, this.vx, this.vy, this.size, this.rot, this.vr, this.flip, this.vflip, this.life);
  final ui.Image? img;
  double x, y, vx, vy, rot, flip;
  final double size, vr, vflip;
  int life;
}

class _ConfettiLayerState extends State<ConfettiLayer> with SingleTickerProviderStateMixin {
  final _rnd = math.Random();
  final List<ui.Image> _sprites = [];
  List<_Piece> _pieces = [];
  late final Ticker _ticker = createTicker(_tick);
  Duration _last = Duration.zero;
  double _acc = 0;
  int _shotSeen = 0;

  @override
  void initState() {
    super.initState();
    _loadSprites();
    widget.controller.addListener(_onController);
  }

  Future<void> _loadSprites() async {
    for (final path in widget.images) {
      final data = await rootBundle.load(path);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      _sprites.add(frame.image);
    }
  }

  void _onController() {
    final c = widget.controller;
    if (c._shot == _shotSeen) return;
    _shotSeen = c._shot;
    if (c._origin == null) {
      _ticker.stop();
      setState(() => _pieces = []);
      return;
    }
    final o = c._origin!;
    _pieces = List.generate(ConfettiLayer.popCount, (i) {
      final a = -math.pi / 2 + (_rnd.nextDouble() - .5) * 3.2; // wide upward fan
      final sp = 6 + _rnd.nextDouble() * 12;
      return _Piece(
        _sprites.isEmpty ? null : _sprites[i % _sprites.length],
        o.dx + (_rnd.nextDouble() - .5) * c._spread * .3,
        o.dy,
        math.cos(a) * sp,
        math.sin(a) * sp,
        ConfettiLayer.iconMin + _rnd.nextDouble() * (ConfettiLayer.iconMax - ConfettiLayer.iconMin),
        (_rnd.nextDouble() - .5) * 1.2,
        (_rnd.nextDouble() - .5) * .18,
        _rnd.nextDouble() * math.pi * 2,
        .08 + _rnd.nextDouble() * .12,
        -_rnd.nextInt(8), // tiny stagger so it reads as a pop
      );
    });
    _last = Duration.zero;
    _acc = 0;
    if (!_ticker.isActive) _ticker.start();
  }

  void _tick(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    _acc += math.min(dt, 0.1);
    final h = context.size?.height ?? 1000;
    var alive = 0;
    while (_acc >= 1 / 60) {
      _acc -= 1 / 60;
      alive = 0;
      for (final p in _pieces) {
        p.life++;
        if (p.life < 0) {
          alive++;
          continue;
        }
        if (p.life > ConfettiLayer.life || p.y > h + 80) continue;
        alive++;
        p.vy = p.vy * .985 + .30; // floaty: air drag + light gravity
        p.vx *= .98;
        p.x += p.vx;
        p.y += p.vy;
        p.rot += p.vr;
        p.flip += p.vflip;
      }
      if (alive == 0) {
        _ticker.stop();
        _pieces = [];
        widget.onDone();
        break;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onController);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      IgnorePointer(child: CustomPaint(painter: _ConfettiPainter(_pieces), size: Size.infinite));
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces);
  final List<_Piece> pieces;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pieces) {
      if (p.life < 0 || p.life > ConfettiLayer.life || p.img == null) continue;
      final grow = math.min(1.0, p.life / 8);
      final scale = grow < 1 ? .3 + grow * .95 : 1.0; // pop in with a slight overshoot
      final fade = math.min(1.0, (ConfettiLayer.life - p.life) / 20);
      final img = p.img!;
      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.rot);
      canvas.scale(scale * (.35 + .65 * math.cos(p.flip).abs()), scale); // 3D-ish flip
      final paint = Paint()
        ..filterQuality = FilterQuality.medium
        ..color = Color.fromRGBO(0, 0, 0, fade);
      canvas.drawImageRect(
        img,
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
        Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => true;
}
