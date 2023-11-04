import 'dart:developer';

import 'package:trading_club/data/models/news_model.dart';
import 'package:trading_club/env/env.dart';
import 'package:trading_club/logic/services/forex_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsService {
  final Dio dio;

  const NewsService(this.dio);

  Future<List<News>> getNews() async {
    try {
      final params = {
        'category': 'forex',
        'token': Env.newsApiKey,
      };
      final uri = Uri.https(
        Env.newsApiUrl,
        Env.newsApiEndpoint,
        params,
      );
      final request = await dio.getUri(uri);
      final response = request.data as Map<String, dynamic>;
      final newsRaw = List<Map<String, dynamic>>.from(response['results']);
      final newsModels = newsRaw.map((newsRaw) => News.fromJson(newsRaw)).toList();

      return newsModels;
    } on DioException catch (e, st) {
      log(
        'dio exception has been thrown when calling getNews()',
        error: e,
        stackTrace: st,
      );

      rethrow;
    }
  }
}

final newsServiceP = Provider(
  (ref) => NewsService(
    ref.read(dioP),
  ),
);
