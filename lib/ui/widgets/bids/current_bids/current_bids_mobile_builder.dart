import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trading_club/logic/notifiers/current_bids_notifier.dart';
import 'package:trading_club/ui/widgets/bids/current_bids/current_bid_tile.dart';
import 'package:trading_club/ui/widgets/empty_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentBidsMobileBuilder extends ConsumerWidget {
  const CurrentBidsMobileBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBids = ref.watch(currentBidsNP).reversed.toList();

    if (currentBids.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: EmptyHistory(
            includeSizedBox: false,
          ),
        ),
      );
    }

    return SliverList.builder(
      itemCount: currentBids.length,
      itemBuilder: (context, index) {
        final bid = currentBids[index];

        return Padding(
          padding: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
            bottom: bid == currentBids.last ? 35.h : 11.h,
          ),
          child: CurrentBidTile(bid),
        );
      },
    );
  }
}
