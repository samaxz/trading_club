import 'dart:developer';

import 'package:trading_club/data/models/candle_model.dart';
import 'package:trading_club/env/env.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForexApiService {
  final Dio dio;

  const ForexApiService(this.dio);

  Future<List<Candle>> getCandles(
    String pair, {
    String interval = '15min',
    String outputSize = '22',
  }) async {
    try {
      final params = {
        'symbol': pair,
        'interval': interval,
        'outputsize': outputSize,
        'apikey': Env.forexApiKey,
      };
      final uri = Uri.https(
        Env.forexApiUrl,
        Env.forexApiEndpoint,
        params,
      );
      final request = await dio.getUri(uri);
      final response = request.data as Map<String, dynamic>;
      final candles = List.from(response['values'])
          .map(
            (candleRaw) => Candle.fromJson(candleRaw),
          )
          .toList();

      return candles;
    } on DioException catch (e, st) {
      log(
        '''dio exception has been thrown when calling getCandles(
         String $pair, {
         String interval = $interval,
         String outputSize = '$outputSize',
         }
        )''',
        error: e,
        stackTrace: st,
      );

      rethrow;
    }
  }
}

final forexApiP = Provider(
  (ref) => ForexApiService(
    ref.read(dioP),
  ),
);

final dioP = Provider(
  (ref) => Dio(),
);
