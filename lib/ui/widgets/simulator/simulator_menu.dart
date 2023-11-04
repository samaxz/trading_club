import 'dart:async';
import 'dart:math' as math;

import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:trading_club/logic/notifiers/forex_api_notifier.dart';
import 'package:trading_club/logic/notifiers/timer_notifier.dart';
import 'package:trading_club/logic/notifiers/current_bids_notifier.dart';
import 'package:trading_club/logic/notifiers/user_info_notifier.dart';
import 'package:trading_club/ui/screens/home_screen.dart';
import 'package:trading_club/ui/widgets/primary_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:trading_club/ui/widgets/simulator/simulator_window.dart';

class SimulatorMenu extends ConsumerStatefulWidget {
  const SimulatorMenu({super.key});

  @override
  ConsumerState createState() => _SimulatorMenuState();
}

class _SimulatorMenuState extends ConsumerState<SimulatorMenu> {
  static const List<DropdownMenuItem<Duration>> timerItems = [
    DropdownMenuItem(
      value: Duration(minutes: 1),
      child: Text('1:00'),
    ),
    DropdownMenuItem(
      value: Duration(minutes: 5),
      child: Text('5:00'),
    ),
    DropdownMenuItem(
      value: Duration(minutes: 15),
      child: Text('15:00'),
    ),
    DropdownMenuItem(
      value: Duration(minutes: 30),
      child: Text('30:00'),
    ),
    DropdownMenuItem(
      value: Duration(minutes: 60),
      child: Text('60:00'),
    ),
  ];

  Duration parseDuration(String durationString) {
    List<String> components = durationString.split(':');

    int hours = int.parse(components[0]);
    int minutes = int.parse(components[1]);
    int seconds = int.parse(components[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  // the default values that'll also be modified
  late int sell = math.Random().nextInt(100);
  late int buy = 100 - sell;

  void changeData() {
    Future.microtask(
      () => ref.read(forexApiNP.notifier).getCandles(),
    );

    setState(() {
      sell = math.Random().nextInt(100);
      buy = 100 - sell;
    });
  }

  String formatRemainingTime(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> makeBid(bool up) async {
    final selectedPair = ref.read(selectedPairSP);
    final madeBid = ref.read(madeBidSP)[selectedPair]!;
    final disableBid = ref.read(disableBidSP)[selectedPair]!;

    if (madeBid || disableBid) return;

    ref.read(madeBidSP.notifier).update(
          (state) => {...state, selectedPair: true},
        );

    final userNot = ref.read(userInfoSharedPrefsNP.notifier);
    userNot.setBalance(
      ref.read(userInfoSharedPrefsNP).balance -
          double.parse(ref.read(textFormFieldControllerP).text),
    );

    final currentBid = CurrentBid(
      pair: selectedPair,
      up: up,
      timeLeft: ref.read(
        timerNP(selectedPair),
      ),
      bid: double.parse(ref.read(textFormFieldControllerP).text),
      dealTime: DateTime.now(),
      openPrice: double.parse(ref.read(forexApiNP).value!.first.open),
    );

    ref.read(currentBidsNP.notifier).makeBid(currentBid);

    final timerNot = ref.read(timerNP(selectedPair).notifier);
    timerNot.startCountdown(
      selectedPair: selectedPair,
      currentBid: currentBid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoSharedPrefsNP);
    final selectedPair = ref.watch(selectedPairSP);
    final selectedTimer = ref.watch(timerNP(selectedPair));
    final madeBid = ref.watch(madeBidSP)[selectedPair]!;
    final disableBid = ref.watch(disableBidSP)[selectedPair]!;
    final isTablet = ref.watch(deviceInfoNP);

    return Container(
      width: isTablet ? 210.w : 1.sw,
      color: Helper.greyTile,
      child: Padding(
        padding: isTablet ? EdgeInsets.only(bottom: 10.h) : EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
                vertical: 10.h,
              ),
              child: Row(
                children: [
                  Text(
                    '$sell%',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.10,
                    ),
                  ),
                  SizedBox(width: 7.w),
                  Expanded(
                    flex: sell,
                    child: Container(
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCA3131),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    flex: buy,
                    child: Container(
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2EBB2E),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 7.w),
                  Text(
                    '$buy%',
                    style: TextStyle(
                      color: const Color(0xFF2EBB2E),
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.10,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 15.w,
                top: 3.h,
                bottom: 10.h,
              ),
              child: Row(
                children: [
                  Image.asset(
                    Helper.balance,
                    width: 25.w,
                    height: 25.h,
                  ),
                  SizedBox(width: 7.w),
                  RichText(
                    text: TextSpan(
                      text: 'Your balance:  ',
                      style: TextStyle(
                        color: const Color(0xFF7A7A7A),
                        fontSize: 15.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.10,
                      ),
                      children: [
                        TextSpan(
                          text: NumberFormat('#,##0.00')
                              .format(userInfo.balance)
                              .replaceFirst(',', ' '),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0.08,
                            letterSpacing: -0.10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Divider(
                height: 8.h,
                color: Helper.grey,
              ),
            ),
            SizedBox(
              height: 70.h,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 7.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1B1B),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Duration>(
                            value: timerItems[0].value,
                            items: timerItems,
                            selectedItemBuilder: (context) => [
                              Center(
                                child: Row(
                                  children: [
                                    Image.asset(
                                      Helper.timer,
                                      height: 27.h,
                                      width: 27.w,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      formatRemainingTime(
                                        selectedTimer,
                                      ),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.5.sp,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            style: TextStyle(
                              // color: Color(0xFF7A7A7A),
                              color: Colors.white,
                              fontSize: 16.5.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.10,
                            ),
                            icon: Image.asset(
                              Helper.chevronDown,
                              width: 25.w,
                              height: 25.h,
                            ),
                            padding: EdgeInsets.all(10.r),
                            dropdownColor: const Color(0xFF1B1B1B),
                            // onChanged: disableBid || madeBid
                            onChanged: madeBid
                                ? null
                                : (timer) async {
                                    ref.read(timerNP(selectedPair).notifier).setTimer(timer!);

                                    ref.read(selectedTimerBidSP.notifier).update((state) {
                                      return timer;
                                    });

                                    await ref.read(forexApiNP.notifier).getCandles();
                                  },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1B1B),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(12.r),
                              child: SizedBox(
                                child: Image.asset(
                                  Helper.bid,
                                  width: 27.w,
                                  height: 27.h,
                                ),
                              ),
                            ),
                            const CustomTextFormField(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ******************
            SizedBox(
              height: 70.h,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 7.h,
                ),
                child: Row(
                  // this fills in the parent
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async => await makeBid(true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: disableBid || madeBid ? Colors.grey : const Color(0xFF2EBB2E),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'UP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.10,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 24.h,
                                  width: 24.w,
                                  color: Colors.black.withOpacity(0.1),
                                  child: Image.asset(
                                    Helper.arrowUp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => makeBid(false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: disableBid || madeBid ? Colors.grey : const Color(0xFFCA3131),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'DOWN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.10,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 24.h,
                                  width: 24.w,
                                  color: Colors.black.withOpacity(0.1),
                                  child: Image.asset(
                                    Helper.arrowDown,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 7.h),
          ],
        ),
      ),
    );
  }
}
