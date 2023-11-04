import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:trading_club/logic/notifiers/finished_bids_notifier.dart';
import 'package:trading_club/ui/widgets/empty_history.dart';
import 'package:trading_club/ui/widgets/bids/finished_bids/finished_bid_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

const String dateFormatter = 'MMMM d';

extension DateHelper on DateTime {
  String formatDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}

class AchievementDetailsScreen extends ConsumerWidget {
  final String text;
  final bool completed;
  final String completion;
  final int index;
  final int reward;
  final double progressBar;
  final List<FinishedBid> history;
  final String auxiliaryText;

  const AchievementDetailsScreen({
    super.key,
    required this.text,
    required this.completed,
    required this.completion,
    required this.index,
    required this.reward,
    required this.progressBar,
    required this.history,
    required this.auxiliaryText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = ref.watch(deviceInfoNP);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Helper.greyTile,
        leadingWidth: 100.w,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.chevron_back,
                color: Helper.greySecondary,
                size: 27.r,
                // size: 11.sp,
              ),
              Text(
                'Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Helper.greySecondary,
                  // fontSize: 20,
                  fontSize: 15.sp,
                  fontFamily: 'SF Pro Text',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.41,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
        title: Text(
          'Achievement',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            // fontSize: 22,
            fontSize: 19.sp,
            fontFamily: 'SF Pro Text',
            fontWeight: FontWeight.w600,
            letterSpacing: -0.21,
          ),
        ),
        backgroundColor: Helper.greyTile,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 12.h),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 50.w : 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    // height: 127.h,
                    decoration: BoxDecoration(
                      color: Helper.greyTile,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(8.w, 5.h, 0.w, 5.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                              color: const Color(0xFF7A7A7A),
                              fontSize: 13.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.10,
                            ),
                          ),
                          Text(
                            text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.10,
                            ),
                          ),
                          SizedBox(height: 13.h),
                          Text(
                            '$completion$auxiliaryText',
                            style: TextStyle(
                              color: Helper.greySecondary,
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.10,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Padding(
                            padding: EdgeInsets.only(right: 15.w),
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey.shade700,
                              value: progressBar,
                              minHeight: 3.h,
                              borderRadius: BorderRadius.circular(8.r),
                              color: Helper.yellow,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Divider(
                            height: 8.h,
                            color: Helper.grey,
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'Reward',
                            style: TextStyle(
                              color: const Color(0xFF7A7A7A),
                              fontSize: 13.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.10,
                            ),
                          ),
                          Text(
                            '${NumberFormat('#,###').format(reward).replaceAll(',', '.')} points',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 1.w, bottom: 5.h),
                    child: Text(
                      'History',
                      style: TextStyle(
                        color: Colors.white,
                        // fontSize: 21,
                        fontSize: 17.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (history.isEmpty) ...[
            const SliverFillRemaining(
              child: Center(
                child: EmptyHistory(
                  includeSizedBox: false,
                  includeBottomSizedBox: true,
                  popFromAchievement: true,
                ),
              ),
            ),
          ] else ...[
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              sliver: SliverList.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  bool isSameDate = true;
                  final date = history[index].timeFinished;

                  if (index == 0) {
                    isSameDate = false;
                  } else {
                    final prevDate = history[index - 1].timeFinished;
                    isSameDate = date.isSameDate(prevDate);
                  }

                  if (index == 0 || !(isSameDate)) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index != 0) SizedBox(height: 15.h),
                        Text(
                          date.formatDate(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.10,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 7.h),
                          child: FinishedBidTile(
                            history[index],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(
                        top: 13.h,
                        // TODO change this just in case
                        bottom: index == history.length - 1 ? 33.h : 0.h,
                      ),
                      child: FinishedBidTile(
                        history[index],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
