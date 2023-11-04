import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/finished_bids_notifier.dart';
import 'package:trading_club/logic/notifiers/progress_notifier.dart';
import 'package:trading_club/ui/screens/achievement_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AchievementTile extends ConsumerWidget {
  final String text;
  final bool completed;
  // if not completed, then show the progress
  final String completion;
  // index is used for displaying item's date time of achievement
  final int index;
  final int reward;
  final double progressBar;
  final List<FinishedBid> history;
  final String auxiliaryText;

  const AchievementTile({
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
    final progress = ref.watch(progressNP);

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AchievementDetailsScreen(
            text: text,
            completed: completed,
            completion: completion,
            index: index,
            reward: reward,
            progressBar: progressBar,
            history: history,
            auxiliaryText: auxiliaryText,
          ),
        ),
      ),
      child: Container(
        decoration: ShapeDecoration(
          color: completed ? null : Helper.greyTile,
          gradient: completed
              ? const LinearGradient(
                  begin: Alignment(-0.92, -0.39),
                  end: Alignment(0.92, 0.39),
                  colors: [
                    Color(0xFFF7CF00),
                    Color(0xFFD19219),
                  ],
                )
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: completed ? const Color(0xFF070808) : Colors.white,
                  // fontSize: 17,
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  // letterSpacing: -0.10,
                ),
              ),
              const Spacer(),
              if (completed) ...[
                Row(
                  children: [
                    Text(
                      DateFormat('dd.MM.yy').format(progress.time[index]!),
                      style: TextStyle(
                        color: Helper.grey,
                        fontSize: 12.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.40,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${NumberFormat('#,###').format(reward).replaceAll(',', '.')} points',
                      style: TextStyle(
                        color: Helper.grey,
                        fontSize: 12.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.40,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      completion,
                      style: TextStyle(
                        color: Helper.greySecondary,
                        fontSize: 11.5.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.10,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    LinearProgressIndicator(
                      backgroundColor: Colors.grey.shade700,
                      value: progressBar,
                      minHeight: 3.h,
                      borderRadius: BorderRadius.circular(8.r),
                      color: Helper.yellow,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
