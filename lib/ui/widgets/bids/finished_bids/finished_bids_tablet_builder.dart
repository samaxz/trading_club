import 'package:trading_club/logic/notifiers/finished_bids_notifier.dart';
import 'package:trading_club/ui/widgets/bids/finished_bids/finished_bid_tile.dart';
import 'package:trading_club/ui/widgets/empty_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinishedBidsTabletBuilder extends ConsumerWidget {
  const FinishedBidsTabletBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finishedBids = ref.watch(finishedBidsNP).reversed.toList();

    if (finishedBids.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyHistory(),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 3.2,
        ),
        itemCount: finishedBids.length,
        itemBuilder: (context, index) {
          final bid = finishedBids[index];

          return FinishedBidTile(bid);
        },
      ),
    );
  }
}
