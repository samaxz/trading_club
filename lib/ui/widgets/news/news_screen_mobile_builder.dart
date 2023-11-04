import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trading_club/logic/notifiers/news_notifier.dart';
import 'package:trading_club/ui/widgets/news_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsScreenMobileBuilder extends ConsumerWidget {
  const NewsScreenMobileBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsNP);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: news.when(
        data: (data) => data.length,
        error: (error, stackTrace) => 1,
        loading: () => 1,
      ),
      itemBuilder: (context, index) => news.when(
        data: (data) => NewsTile(
          news: data[index],
        ),
        error: (error, stackTrace) => Center(
          child: TextButton(
            onPressed: () => ref.read(newsNP.notifier).loadNews(),
            child: const Text('try again'),
          ),
        ),
        loading: () => Padding(
          padding: EdgeInsets.only(top: 300.h),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
