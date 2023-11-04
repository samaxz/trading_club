import 'package:trading_club/logic/notifiers/news_notifier.dart';
import 'package:trading_club/ui/widgets/news_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsScreenTabletBuilder extends ConsumerWidget {
  const NewsScreenTabletBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsNP);

    return news.when(
      data: (news) => CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 7.h),
          ),
          SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.1,
            ),
            itemCount: news.length,
            itemBuilder: (context, index) => NewsTile(
              news: news[index],
            ),
          ),
        ],
      ),
      error: (error, stackTrace) => Center(
        child: TextButton(
          onPressed: () => ref.read(newsNP.notifier).loadNews(),
          child: const Text('try again'),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
