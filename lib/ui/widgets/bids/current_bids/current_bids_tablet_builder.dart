import 'package:trading_club/logic/notifiers/current_bids_notifier.dart';
import 'package:trading_club/ui/widgets/bids/current_bids/current_bid_tile.dart';
import 'package:trading_club/ui/widgets/empty_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentBidsTabletBuilder extends ConsumerWidget {
  const CurrentBidsTabletBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBids = ref.watch(currentBidsNP).reversed.toList();

    if (currentBids.isEmpty) {
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
        itemCount: currentBids.length,
        itemBuilder: (context, index) {
          final bid = currentBids[index];

          return CurrentBidTile(bid);
        },
      ),
    );
  }
}
