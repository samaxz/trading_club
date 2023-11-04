import 'dart:async';

import 'package:trading_club/data/models/candle_model.dart';
import 'package:trading_club/logic/services/forex_api_service.dart';
import 'package:trading_club/ui/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trading_club/ui/widgets/simulator/simulator_window.dart';

class ForexApiNotifier extends StateNotifier<AsyncValue<List<Candle>>> {
  final Ref ref;

  ForexApiNotifier(this.ref) : super(const AsyncLoading());

  Timer? periodicTimer;

  Future<void> _loadDataImmediately(String outputSize) async {
    final pair = ref.read(selectedPairSP);
    final timer = ref.read(selectedTimerBidSP);
    late final String interval;

    if (timer.inHours == 0) {
      interval = '${timer.inMinutes}min';
      // log('1-a');
    } else {
      interval = '${timer.inHours}h';
      // log('1-b');
    }

    final result = await AsyncValue.guard(
      () => ref.read(forexApiP).getCandles(
            pair,
            interval: interval,
            outputSize: outputSize,
          ),
    );

    state = result;

    // log('getCandles() got called: ${DateTime.now()} as loadImmediately');
  }

  Future<void> _loadDataPeriodically(String outputSize) async {
    final timer = ref.read(selectedTimerBidSP);

    periodicTimer?.cancel();

    periodicTimer = Timer.periodic(
      timer,
      (_) async {
        final pair = ref.read(selectedPairSP);
        late final String interval;

        if (timer.inHours == 0) {
          interval = '${timer.inMinutes}min';
          // log('2-a');
        } else {
          interval = '${timer.inHours}h';
          // log('2-b');
        }

        final result = await AsyncValue.guard(
          () => ref.read(forexApiP).getCandles(
                pair,
                interval: interval,
                outputSize: outputSize,
              ),
        );

        state = result;

        // log('getCandles() got called: ${DateTime.now()} as loadPeriodically');
      },
    );
  }

  Future<void> getCandles({String outputSize = '22'}) async {
    await _loadDataImmediately(outputSize);

    await _loadDataPeriodically(outputSize);
  }
}

final forexApiNP = StateNotifierProvider<ForexApiNotifier, AsyncValue<List<Candle>>>(
  (ref) => ForexApiNotifier(ref),
);
