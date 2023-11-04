import 'dart:async';

import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/current_bids_notifier.dart';
import 'package:trading_club/logic/notifiers/finished_bids_notifier.dart';
import 'package:trading_club/logic/notifiers/forex_api_notifier.dart';
import 'package:trading_club/logic/notifiers/progress_notifier.dart';
import 'package:trading_club/logic/notifiers/user_info_notifier.dart';
import 'package:trading_club/ui/widgets/simulator/simulator_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

final selectedCurrenciesSP = StateProvider(
  (ref) => {
    Helper.usdEur: false,
    Helper.usdJpy: false,
    Helper.usdRub: false,
    Helper.eurRub: false,
    Helper.usdChf: false,
    Helper.usdCad: false,
  },
);

final madeBidSP = StateProvider(
  (ref) => {
    Helper.usdEur: false,
    Helper.usdJpy: false,
    Helper.usdRub: false,
    Helper.eurRub: false,
    Helper.usdChf: false,
    Helper.usdCad: false,
  },
);

// TODO delete this, as this is used locally on the simulator screen
final disableBidSP = StateProvider(
  (ref) => {
    Helper.usdEur: false,
    Helper.usdJpy: false,
    Helper.usdRub: false,
    Helper.eurRub: false,
    Helper.usdChf: false,
    Helper.usdCad: false,
  },
);

// TODO remove this
final showAlertDialogSP = StateProvider(
  (ref) => {
    Helper.usdEur: false,
    Helper.usdJpy: false,
    Helper.usdRub: false,
    Helper.eurRub: false,
    Helper.usdChf: false,
    Helper.usdCad: false,
  },
);

class TimerNotifier extends StateNotifier<Duration> {
  final Ref ref;

  TimerNotifier(this.ref) : super(ref.read(selectedTimerBidSP));

  Timer? countdownTimer;

  void setTimer(Duration newDuration) => state = newDuration;

  void startCountdown({
    required String selectedPair,
    required CurrentBid currentBid,
  }) {
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        state = state - const Duration(seconds: 1);

        if (state <= const Duration()) {
          final newOpenPrice = double.parse(ref.read(forexApiNP).value!.first.open);

          _stopCountdown(
            selectedPair: selectedPair,
            currentBid: currentBid,
            newOpenPrice: newOpenPrice,
          );
        }
      },
    );
  }

  void _stopCountdown({
    required String selectedPair,
    required CurrentBid currentBid,
    required double newOpenPrice,
  }) {
    countdownTimer?.cancel();

    state = ref.read(selectedTimerBidSP);

    ref.read(madeBidSP.notifier).update(
          (state) => {...state, selectedPair: false},
        );

    late final bool won;

    // TODO refactor this
    if (currentBid.up) {
      if (newOpenPrice > currentBid.openPrice!) {
        won = true;
      } else {
        won = false;
      }
    } else {
      if (newOpenPrice < currentBid.openPrice!) {
        won = true;
      } else {
        won = false;
      }
    }

    // log(currentBid.up ? 'up' : 'down');
    // log('bid open price = ${currentBid.openPrice}');
    // log('new open price = $newOpenPrice');
    // log('double.parse(ref.read(forexApiNP).value!.last.open) = ${double.parse(ref.read(forexApiNP).value!.last.open)}');

    late final double returns;
    if (won) {
      // TODO change these values
      returns = currentBid.bid + math.Random().nextDouble() * 1000;
    } else {
      returns = currentBid.bid + math.Random().nextDouble() * -1000;
    }

    final finishedBid = FinishedBid(
      pair: currentBid.pair,
      won: won,
      invested: currentBid.bid,
      returns: returns,
      timeFinished: DateTime.now(),
    );

    ref.read(currentBidsNP.notifier).removeBid(currentBid);

    ref.read(showAlertDialogSP.notifier).update(
          (state) => {...state, selectedPair: true},
        );

    ref.read(finishedBidsNP.notifier).saveBid(finishedBid);

    final updatedProgress = ref.read(progressNP);

    void earnAchievement(int points, int index) {
      updatedProgress.points += points;
      updatedProgress.time[index] = DateTime.now();
      // log('yay! user has earned an achievement');
      // log('points: $points, time: ${DateTime.now()}');
      // log('new earnings are: ${updatedProgress.points} and ${updatedProgress.time[index]}');
    }

    updatedProgress.deals += 1;
    if (won) {
      updatedProgress.successfulDeals += 1;
      updatedProgress.points += 100;
    } else {
      if (updatedProgress.points >= 100) {
        updatedProgress.points -= 100;
      }
    }

    if (finishedBid.invested > updatedProgress.maxBid) {
      updatedProgress.maxBid = finishedBid.invested;

      if (updatedProgress.maxBid >= 100 && !updatedProgress.verifyGiven[100]!) {
        updatedProgress.verifyGiven[100] = true;
        earnAchievement(5000, 0);
      }

      if (updatedProgress.maxBid >= 200 && !updatedProgress.verifyGiven[200]!) {
        updatedProgress.verifyGiven[200] = true;
        earnAchievement(7000, 1);
      }

      if (updatedProgress.maxBid >= 500 && !updatedProgress.verifyGiven[500]!) {
        updatedProgress.verifyGiven[500] = true;
        earnAchievement(10000, 8);
      }

      if (updatedProgress.maxBid >= 1000 && !updatedProgress.verifyGiven[1000]!) {
        updatedProgress.verifyGiven[1000] = true;
        earnAchievement(15000, 9);
      }
    }

    // log('finished bid is: ${finishedBid.invested}');
    // log('current max bid is: ${updatedProgress.maxBid}');

    if (updatedProgress.successfulDeals == 10) {
      earnAchievement(5000, 2);
    }

    if (updatedProgress.deals == 20) {
      earnAchievement(7000, 3);
    }

    if (updatedProgress.deals == 40) {
      earnAchievement(10000, 4);
    }

    if (updatedProgress.deals == 100) {
      earnAchievement(15000, 5);
    }

    if (updatedProgress.successfulDeals == 20) {
      earnAchievement(10000, 6);
    }

    if (updatedProgress.successfulDeals == 80) {
      earnAchievement(15000, 7);
    }

    updatedProgress.level = (updatedProgress.points ~/ 4000) + 1;
    // log('updated progress is: $updatedProgress');

    ref.read(progressNP.notifier).updateProgress(updatedProgress);

    ref
        .read(userInfoSharedPrefsNP.notifier)
        .setBalance(ref.read(userInfoSharedPrefsNP).balance + returns);

    // TODO trigger a change in provider's state to show a function
    // inside ref.listen
    // ref.read(showAlertDialogSP.notifier).update(
    //       (state) => {...state, selectedPair: true},
    //     );
  }

  // in case user presses x on the simulator screen
  void cancelBid() {
    countdownTimer?.cancel();

    state = ref.read(selectedTimerBidSP);
  }
}

final timerNP = StateNotifierProvider.family<TimerNotifier, Duration, String>(
  (ref, id) => TimerNotifier(ref),
);
