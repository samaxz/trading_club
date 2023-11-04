import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:trading_club/logic/notifiers/server_response_notifier.dart';
import 'package:trading_club/ui/screens/home_screen.dart';
import 'package:trading_club/ui/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final bool isPocket;

  const SplashScreen({super.key, this.isPocket = false});

  @override
  ConsumerState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Future<void> asyncStuff() async {
    final screensState = ref.read(screensStateNP);

    Future.delayed(
      const Duration(seconds: 1),
      () async {
        if (screensState.onboardingShown) {
          if (!mounted) return;

          await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        } else {
          if (!mounted) return;

          await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => OnboardingScreen(
                isPocket: widget.isPocket,
              ),
            ),
            (route) => false,
          );
        }
      },
    );

    // TODO delete this
    // Future.delayed(
    //   const Duration(seconds: 1),
    //   () async {
    //     if (!mounted) return;
    //
    //     await Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(
    //         builder: (context) => OnboardingScreen(
    //           isPocket: widget.isPocket,
    //         ),
    //       ),
    //       (route) => false,
    //     );
    //   },
    // );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(asyncStuff);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ref.watch(deviceInfoNP);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Helper.black,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 115.w : 95.w,
          ),
          decoration: BoxDecoration(
            gradient: widget.isPocket
                ? const LinearGradient(
                    begin: Alignment(0, -1),
                    end: Alignment(0, 1),
                    colors: [
                      Color(0xFF1A284B),
                      Color(0xFF1D3269),
                    ],
                  )
                : null,
            color: widget.isPocket ? null : Helper.black,
          ),
          height: 1.sh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(14.r),
                child: SizedBox(
                  width: isTablet
                      ? 304.5.w
                      : widget.isPocket
                          ? 180.w
                          : 165.w,
                  height: isTablet ? 203.h : null,
                  child: widget.isPocket
                      ? Image.asset(Helper.pocketSplash)
                      : Image.asset(Helper.checkSplash),
                ),
              ),
              isTablet ? SizedBox(height: 330.h) : SizedBox(height: 250.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: LinearPercentIndicator(
                  backgroundColor: widget.isPocket ? const Color(0xFF344775) : Colors.grey.shade700,
                  barRadius: Radius.circular(10.r),
                  progressColor: widget.isPocket ? Colors.white : Helper.yellow,
                  percent: 1,
                  lineHeight: isTablet ? 8.h : 6.h,
                  animation: true,
                  animationDuration: 1000,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
