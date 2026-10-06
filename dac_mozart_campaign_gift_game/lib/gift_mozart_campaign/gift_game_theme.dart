import 'package:flutter/material.dart';

class GiftGameTheme {
  const GiftGameTheme({
    this.assetPath = 'assets/gift_game/',
    this.background = 'background.png',
    this.rays = 'rays.png',
    this.giftTop = 'gift_top.png',
    this.giftBottom = 'gift_bottom.png',
    this.giftCanvas = const Size(720, 900),
    this.openPoint = 0.45,
    this.topPivot = const Alignment(0, -0.2),
    this.confetti = const [
      'confetti_coin.png',
      'confetti_voucher.png',
      'confetti_voucher_red.png'
    ],
    this.giftCount = 5,
    this.openHint = 'Swipe up to open',
    this.buttonLabel = 'Open this gift',
    this.textColor = Colors.white,
    this.buttonColor = Colors.white,
    this.buttonTextColor = const Color(0xFF141413),
    this.chipColor = const Color(0x24FFFFFF),
    this.ticketGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFFFF3B0),
        Color(0xFFFFD54A),
        Color(0xFFF5B000),
        Color(0xFFC98A00)
      ],
      stops: [0, .35, .65, 1],
    ),
    this.ticketTextColor = const Color(0xFF5A3300),
  });

  final String assetPath;
  final String background;
  final String rays;

  final String giftTop;
  final String giftBottom;
  final Size giftCanvas;

  final double openPoint;

  final Alignment topPivot;

  final List<String> confetti;
  final int giftCount;

  final String openHint;
  final String buttonLabel;
  final Color textColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color chipColor;
  final Gradient ticketGradient;
  final Color ticketTextColor;

  String asset(String file) => '$assetPath$file';
  double get giftAspect => giftCanvas.width / giftCanvas.height;
}
