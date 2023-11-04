import 'package:trading_club/data/models/news_model.dart';
import 'package:trading_club/logic/services/news_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsNotifier extends StateNotifier<AsyncValue<List<News>>> {
  final Ref ref;

  NewsNotifier(this.ref) : super(const AsyncLoading());

  Future<void> loadNews() async {
    state = const AsyncLoading();

    final result = await AsyncValue.guard(
      () => ref.read(newsServiceP).getNews(),
    );

    state = result;
  }
}

final newsNP = StateNotifierProvider<NewsNotifier, AsyncValue<List<News>>>(
  (ref) => NewsNotifier(ref),
);
