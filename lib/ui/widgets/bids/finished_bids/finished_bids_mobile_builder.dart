import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trading_club/logic/notifiers/finished_bids_notifier.dart';
import 'package:trading_club/ui/widgets/bids/finished_bids/finished_bid_tile.dart';
import 'package:trading_club/ui/widgets/empty_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinishedBidsMobileBuilder extends ConsumerWidget {
  const FinishedBidsMobileBuilder({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finishedBids = ref.watch(finishedBidsNP).reversed.toList();

    if (finishedBids.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: EmptyHistory(
            includeSizedBox: false,
          ),
        ),
      );
    }

    return SliverList.builder(
      itemCount: finishedBids.length,
      itemBuilder: (context, index) {
        final bid = finishedBids[index];

        return Padding(
          padding: EdgeInsets.only(
            left: 15.w,
            right: 15.w,
            bottom: bid == finishedBids.last ? 35.h : 11.h,
          ),
          child: FinishedBidTile(bid),
        );
      },
    );
  }
}
