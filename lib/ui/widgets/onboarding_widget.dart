import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingWidget extends ConsumerWidget {
  final String image;
  final String header;
  final String body;
  final bool wrapText;

  const OnboardingWidget({
    super.key,
    required this.image,
    required this.header,
    required this.body,
    required this.wrapText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = ref.watch(deviceInfoNP);
    final isBigTablet = MediaQuery.of(context).size.width > 1000;

    return Scaffold(
      body: Container(
        color: Colors.black,
        height: 1.sh,
        child: Stack(
          children: [
            WidgetMethods.placeImage(
              imagePath: image,
              isTablet: isTablet,
              isBigTablet: isBigTablet,
            ),
            Positioned(
              bottom: WidgetMethods.shouldWrapHeader(
                wrapText: wrapText,
                isTablet: isTablet,
                isBigTablet: isBigTablet,
              ),
              left: 40.w,
              child: SizedBox(
                width: 260.w,
                child: Text(
                  header,
                  style: TextStyle(
                    color: Colors.white,
                    // fontSize: isTablet ? 20.sp : 29,
                    fontSize: 29.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.20,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: WidgetMethods.shouldWrapBody(
                wrapText: wrapText,
                isTablet: isTablet,
                isBigTablet: isBigTablet,
              ),
              left: 40.w,
              child: SizedBox(
                width: 250.w,
                child: Text(
                  body,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
