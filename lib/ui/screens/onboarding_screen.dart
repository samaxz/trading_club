import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:trading_club/logic/notifiers/server_response_notifier.dart';
import 'package:trading_club/ui/screens/home_screen.dart';
import 'package:trading_club/ui/widgets/onboarding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final bool isPocket;

  const OnboardingScreen({
    super.key,
    this.isPocket = false,
  });

  @override
  ConsumerState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final pageController = PageController();
  int currentPage = 0;

  bool reviewShown = false;
  bool disableButton = false;

  @override
  Widget build(BuildContext context) {
    final isTablet = ref.watch(deviceInfoNP);
    final isBigTablet = MediaQuery.of(context).size.width > 1000;

    // log('width of the device is: ${MediaQuery.of(context).size.width}');

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (index) => setState(() => currentPage = index),
            children: [
              OnboardingWidget(
                image: widget.isPocket ? Helper.onboarding1Pocket : Helper.onboarding1,
                header: 'Practice on our simulator',
                body: 'In our app',
                wrapText: false,
              ),
              OnboardingWidget(
                image: widget.isPocket ? Helper.onboarding2PlugPocket : Helper.onboarding2Plug,
                header: 'Run your errands',
                body: 'In our app',
                wrapText: true,
              ),
            ],
          ),
          Positioned(
            bottom: WidgetMethods.positionDots(
              isTablet: isTablet,
              isBigTablet: isBigTablet,
            ),
            child: Row(
              children: [
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: currentPage == 0
                        ? widget.isPocket
                            ? Helper.blue
                            : Helper.yellow
                        : Helper.grey,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(width: 15.w),
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: currentPage == 1
                        ? widget.isPocket
                            ? Helper.blue
                            : Helper.yellow
                        : Helper.grey,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40.h,
            left: isTablet ? null : 30.w,
            right: isTablet ? null : 30.w,
            child: GestureDetector(
              onTap: () async {
                if (pageController.page!.toInt() == 1) {
                  if (disableButton) return;

                  await ref.read(screensStateNP.notifier).setPrefsDetails(onboardingShown: true);

                  if (!mounted) return;

                  await Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false,
                  );
                } else {
                  await pageController.nextPage(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOutSine,
                  );
                }
              },
              child: Container(
                width: isTablet ? 150.w : null,
                height: 55.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: widget.isPocket ? Helper.blue : Helper.yellow,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: widget.isPocket ? Colors.white : const Color(0xFF070808),
                    fontSize: 18.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
