import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/current_bids_notifier.dart';
import 'package:trading_club/logic/notifiers/timer_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CurrentBidTile extends ConsumerWidget {
  final CurrentBid currentBid;

  const CurrentBidTile(this.currentBid, {super.key});

  String formatRemainingTime(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Helper.greyTile,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 4.h),
            child: Row(
              children: [
                Image.asset(
                  currentBid.up ? Helper.bidUp : Helper.bidDown,
                  height: 27.h,
                  width: 27.w,
                ),
                SizedBox(width: 10.w),
                Text(
                  currentBid.pair,
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
                  '\$${currentBid.bid.toStringAsFixed(2)}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
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
                    text: 'Left: ',
                    style: TextStyle(
                      color: const Color(0xFF7A7A7A),
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.10,
                    ),
                    children: [
                      TextSpan(
                        text: formatRemainingTime(ref.watch(timerNP(currentBid.pair))),
                        style: TextStyle(
                          color: const Color(0xFFF7CF00),
                          fontSize: 13.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // *******
                RichText(
                  text: TextSpan(
                    text: 'Deal time: ',
                    style: TextStyle(
                      color: const Color(0xFF7A7A7A),
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.10,
                    ),
                    children: [
                      TextSpan(
                        text: DateFormat('HH:mm').format(currentBid.dealTime),
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
