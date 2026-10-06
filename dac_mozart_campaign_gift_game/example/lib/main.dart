import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dac_mozart_campaign_gift_game/mozart_campaign_gift.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: GiftGame());
  }
}

class GiftGame extends StatefulWidget {
  const GiftGame({super.key});

  @override
  State<GiftGame> createState() => _GiftGameState();
}

class _GiftGameState extends State<GiftGame> {
  final _game = GlobalKey<DacMozartCampaignGiftGameState>();

  int _tickets = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161210),
      body: Stack(children: [
        DacMozartCampaignGiftGame(
          key: _game,
          tickets: _tickets,
          showDemoReplay: true,
          onBack: () => Navigator.maybePop(context),
          onOpened: (giftIndex) {
            setState(() => _tickets = math.max(0, _tickets - 1));
          },
          onCelebrationEnd: (giftIndex) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Prize screen goes here (gift #${giftIndex + 1})')),
            );
          },
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top + 14,
          right: 16,
          child: ActionChip(
            label: const Text('+1 ticket (demo)'),
            onPressed: () => setState(() => _tickets++),
          ),
        ),
      ]),
    );
  }
}
