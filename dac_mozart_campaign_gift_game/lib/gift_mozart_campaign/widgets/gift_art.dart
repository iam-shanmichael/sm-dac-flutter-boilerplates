import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../gift_game_theme.dart';

/// The closed gift: bottom + top PNGs stacked on the same canvas.
class GiftArt extends StatelessWidget {
  const GiftArt({super.key, required this.theme, this.glow = false});

  final GiftGameTheme theme;

  /// Soft white glow around the selected gift (CSS: drop-shadow(0 0 22px rgba(255,255,255,.35))).
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final art = AspectRatio(
      aspectRatio: theme.giftAspect,
      child: Stack(fit: StackFit.expand, children: [
        Image.asset(theme.asset(theme.giftBottom), fit: BoxFit.fill, gaplessPlayback: true),
        Image.asset(theme.asset(theme.giftTop), fit: BoxFit.fill, gaplessPlayback: true),
      ]),
    );
    if (!glow) return art;
    return Stack(children: [
      ImageFiltered(
        imageFilter: ui.ImageFilter.blur(sigmaX: 11, sigmaY: 11),
        child: ColorFiltered(colorFilter: const ColorFilter.mode(Color(0x59FFFFFF), BlendMode.srcIn), child: art),
      ),
      art,
    ]);
  }
}
