# Mozart gift game (Flutter)

A Flutter port of the gift-opening prototype (`../Mozart Game Option`), using the Mastercard skin.
It's the same game: swipe through 5 identical gifts, tap **Open this gift**, swipe up on the lid
(or tap it 3×), and coins and vouchers pop out. **Your app shows the prize.**

## Run the demo
This folder has the Dart code and assets only. Generate the platform folders once, then run:
```
flutter create .
flutter run
```
(`flutter create .` adds android/ios/web folders and keeps the existing `lib/` and `pubspec.yaml`.)

The demo has a **+1 ticket (demo)** chip and a **Play again (demo)** button so you can test the empty-ticket state.

## Add it to SMAC&SHOP
1. Copy `lib/gift_game/` into the app and `assets/gift_game/` into its assets.
2. Add the assets folder to the app's `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/gift_game/
   ```
3. Show it full screen (e.g. as a route from the Play tab):
   ```dart
   final gameKey = GlobalKey<GiftGameState>();

   GiftGame(
     key: gameKey,
     tickets: ticketBalance,                 // from your backend / state; 0 disables "Open this gift"
     onBack: () => Navigator.pop(context),
     onOpened: (giftIndex) {
       // The lid just came off: spend the ticket and fetch the prize from the server.
     },
     onCelebrationEnd: (giftIndex) {
       // The confetti has settled (~2 s later): show your prize screen.
       // When the user comes back: gameKey.currentState?.reset();
     },
   )
   ```

### How tickets work
* The app is the source of truth: pass the current balance in `tickets` and rebuild when it changes.
* The badge shows `1 Ticket`, `3 Tickets`, … and `No tickets left` at 0, faded. At 0 the button is disabled and gifts can't be opened.
* On open, the game lowers its own count by 1 straight away so the UI never lags. The next `tickets` value you pass in replaces it.
* The prize is never decided in the game. Pick it on the server.

## Files
| Path | What it is |
|---|---|
| `lib/gift_game/gift_game.dart` | The `GiftGame` widget: flow, swipe-to-open, rays, flash, haptics |
| `lib/gift_game/gift_game_theme.dart` | Colours, asset names, gift count, confetti point, button and hint text |
| `lib/gift_game/widgets/gift_carousel.dart` | Swipeable gift row (centre gift bobs and glows) |
| `lib/gift_game/widgets/ticket_badge.dart` | Gold notched ticket with pop and glint |
| `lib/gift_game/widgets/confetti_layer.dart` | Coin and voucher pop (same physics as the web version) |
| `lib/gift_game/widgets/gift_art.dart` | Gift = bottom PNG + top PNG stacked |
| `lib/main.dart` | Demo app only |
| `assets/gift_game/` | 7 PNGs: background, rays, gift top/bottom, 3 confetti icons |

No packages beyond Flutter itself.
