import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/forex_api_notifier.dart';
import 'package:trading_club/logic/notifiers/news_notifier.dart';
import 'package:trading_club/logic/notifiers/progress_notifier.dart';
import 'package:trading_club/logic/notifiers/user_info_notifier.dart';
import 'package:trading_club/ui/screens/history_screen.dart';
import 'package:trading_club/ui/screens/news_screen.dart';
import 'package:trading_club/ui/screens/profile_screen.dart';
import 'package:trading_club/ui/screens/progress_screen.dart';
import 'package:trading_club/ui/screens/simulator_screen.dart';
import 'package:trading_club/ui/widgets/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:screen_capture_event/screen_capture_event.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final currentIndexSP = StateProvider((ref) => 1);

final selectedPairSP = StateProvider((ref) => Helper.usdEur);

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final screenTitles = [
    'History',
    'Simulator',
    'Progress',
    'News',
  ];

  final screens = [
    const HistoryScreen(),
    const SimulatorScreen(),
    const ProgressScreen(),
    const NewsScreen(),
  ];

  Future<void> loadData() async {
    await ref.read(forexApiNP.notifier).getCandles();
    await ref.read(userInfoSharedPrefsNP.notifier).setInitialInfo();
    await ref.read(progressNP.notifier).setInitialProgress();
    await ref.read(newsNP.notifier).loadNews();

    // await ref.read(progressNP.notifier).resetProgress();
    // await ref.read(finishedBidsNP.notifier).resetBids();
  }

  Future<void> disposeScreenshotCallback() async {
    await screenshotCallback.dispose();
  }

  final screenshotCallback = ScreenshotCallback();

  // TODO remove this
  final screenListener = ScreenCaptureEvent();

  @override
  void initState() {
    super.initState();
    screenListener.addScreenRecordListener((recorded) {
      log(recorded ? "Start Recording" : "Stop Recording");
    });

    screenListener.addScreenShotListener((filePath) {
      // log('screenshot has been taken');
    });

    screenListener.watch();

    // it doesn't work on the latest flutter version, also, it probably
    // doesn't work with ios simulators - just saying
    screenshotCallback.addListener(() {
      log('screenshot has been taken');
    });

    Future.microtask(loadData);
    // log('init state inside home screen has been called');
  }

  @override
  void dispose() {
    Future.microtask(disposeScreenshotCallback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoSharedPrefsNP);
    final currentScreenIndex = ref.watch(currentIndexSP);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        endDrawerEnableOpenDragGesture: false,
        appBar: AppBar(
          elevation: 0,
          surfaceTintColor: Helper.greyTile,
          backgroundColor: Helper.greyTile,
          leadingWidth: 160.w,
          leading: Row(
            children: [
              GestureDetector(
                onTap: () => scaffoldKey.currentState!.openDrawer(),
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Icon(
                    MdiIcons.menu,
                    color: Helper.yellow,
                    // TODO probably use if tablet bool here
                    size: 29,
                  ),
                ),
              ),
              SizedBox(width: 13.w),
              Text(
                screenTitles[currentScreenIndex],
                style: const TextStyle(
                  color: Colors.white,
                  // TODO probably use if tablet bool here
                  fontSize: 23,
                  // fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 0,
                  letterSpacing: -0.10,
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          width: 330.w,
          backgroundColor: Helper.black,
          surfaceTintColor: Helper.black,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: [
              SizedBox(height: 75.h),
              GestureDetector(
                onTap: () {
                  scaffoldKey.currentState!.closeDrawer();

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Helper.greyTile,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundColor: Helper.grey,
                          backgroundImage: userInfo.imagePath == null
                              ? null
                              : !File(userInfo.imagePath!).existsSync()
                                  ? null
                                  : FileImage(
                                      File(userInfo.imagePath!),
                                    ),
                        ),
                        SizedBox(width: 13.w),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userInfo.name ?? 'User',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.5.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.10,
                              ),
                            ),
                            Text(
                              NumberFormat('#,##0.00')
                                  .format(userInfo.balance)
                                  .replaceFirst(',', ' '),
                              style: TextStyle(
                                color: const Color(0xFF7A7A7A),
                                fontSize: 13.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: -0.10,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Image.asset(
                          Helper.settings,
                          width: 21.w,
                          height: 21.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(
                  color: Helper.greyTile,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Column(
                  children: [
                    DrawerTile(
                      icon: Helper.history,
                      text: 'History',
                      size: 22.r,
                      isFirst: true,
                      onTap: () {
                        ref.read(currentIndexSP.notifier).update((state) => 0);
                        scaffoldKey.currentState!.closeDrawer();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Divider(
                        height: 5.h,
                        color: Helper.grey,
                      ),
                    ),
                    DrawerTile(
                      icon: Helper.simulator,
                      text: 'Simulator',
                      size: 24.r,
                      onTap: () {
                        ref.read(currentIndexSP.notifier).update((state) => 1);
                        scaffoldKey.currentState!.closeDrawer();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Divider(
                        height: 5.h,
                        color: Helper.grey,
                      ),
                    ),
                    DrawerTile(
                      icon: Helper.progress,
                      text: 'Progress',
                      size: 24.r,
                      onTap: () {
                        ref.read(currentIndexSP.notifier).update((state) => 2);
                        scaffoldKey.currentState!.closeDrawer();
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Divider(
                        height: 5.h,
                        color: Helper.grey,
                      ),
                    ),
                    DrawerTile(
                      icon: Helper.news,
                      text: 'News',
                      size: 24.r,
                      isLast: true,
                      onTap: () {
                        ref.read(currentIndexSP.notifier).update((state) => 3);
                        scaffoldKey.currentState!.closeDrawer();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                decoration: BoxDecoration(
                  color: Helper.greyTile,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Column(
                  children: [
                    DrawerTile(
                      text: 'Rate the app',
                      isFirst: true,
                      onTap: () async {
                        final inAppReview = InAppReview.instance;

                        if (await inAppReview.isAvailable()) {
                          inAppReview.requestReview();
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Divider(
                        height: 8.h,
                        color: Helper.grey,
                      ),
                    ),
                    DrawerTile(
                      text: 'Share app',
                      onTap: () async {
                        await Share.share('Share this with others');
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w),
                      child: Divider(
                        height: 8.h,
                        color: Helper.grey,
                      ),
                    ),
                    DrawerTile(
                      text: 'Usage policy',
                      isLast: true,
                      onTap: () async {
                        if (!await launchUrl(
                          Uri.parse(
                            'https://docs.google.com',
                          ),
                        )) {
                          if (!mounted) return;

                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog();
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: screens[currentScreenIndex],
      ),
    );
  }
}
