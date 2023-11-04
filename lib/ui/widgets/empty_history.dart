import 'package:trading_club/data/helper.dart';
import 'package:trading_club/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyHistory extends ConsumerWidget {
  final bool includeSizedBox;
  final bool includeBottomSizedBox;
  final bool popFromAchievement;

  const EmptyHistory({
    super.key,
    this.includeSizedBox = true,
    this.includeBottomSizedBox = false,
    this.popFromAchievement = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (includeSizedBox) SizedBox(height: 200.h),
        Image.asset(
          Helper.historyBar,
          width: 70.w,
          height: 70.h,
        ),
        SizedBox(height: 22.h),
        Text(
          'There is no History',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            // fontSize: 33,
            fontSize: 22.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.30,
          ),
        ),
        SizedBox(height: 10.h),
        Opacity(
          opacity: 0.80,
          child: Text(
            'Start trading on our simulator',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              // fontSize: 20,
              fontSize: 13.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              letterSpacing: -0.30,
            ),
          ),
        ),
        SizedBox(height: 25.h),
        GestureDetector(
          onTap: () {
            if (popFromAchievement) {
              Navigator.of(context).pop();
            }

            ref.read(currentIndexSP.notifier).update((state) => 1);
          },
          child: FittedBox(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                horizontal: 25.w,
                vertical: 10.h,
              ),
              decoration: ShapeDecoration(
                color: const Color(0xFFF7CF00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              child: Opacity(
                opacity: 0.80,
                child: Text(
                  'Trade',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF070808),
                    // fontSize: 21,
                    fontSize: 16.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.10,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (includeBottomSizedBox) SizedBox(height: 70.h),
      ],
    );
  }
}
