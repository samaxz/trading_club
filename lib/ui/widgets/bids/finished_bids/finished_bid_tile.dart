import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/finished_bids_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FinishedBidTile extends ConsumerWidget {
  final FinishedBid finishedBid;

  const FinishedBidTile(this.finishedBid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Helper.greyTile,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 4.h),
            // padding: EdgeInsets.zero,
            child: Row(
              children: [
                Image.asset(
                  finishedBid.won ? Helper.bidUp : Helper.bidDown,
                  height: 27.h,
                  width: 27.w,
                ),
                SizedBox(width: 10.w),
                Text(
                  finishedBid.pair,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.10,
                  ),
                ),
                const Spacer(),
                Text(
                  finishedBid.returns > 0
                      ? '+\$${finishedBid.returns.toStringAsFixed(2)}'
                      : '-\$${finishedBid.returns.abs().toStringAsFixed(2)}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color:
                        finishedBid.returns > 0 ? const Color(0xFF2EBB2E) : const Color(0xFFCA3131),
                    fontSize: 15.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.10,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 8.h,
            color: Helper.grey,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 11.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Invested: ',
                    style: TextStyle(
                      color: const Color(0xFF7A7A7A),
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.10,
                    ),
                    children: [
                      TextSpan(
                        text: '\$${finishedBid.invested.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
