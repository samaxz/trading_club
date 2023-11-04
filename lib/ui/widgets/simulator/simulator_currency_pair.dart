import 'dart:async';
import 'dart:math' as math;

import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:trading_club/logic/notifiers/forex_api_notifier.dart';
import 'package:trading_club/logic/notifiers/timer_notifier.dart';
import 'package:trading_club/logic/notifiers/current_bids_notifier.dart';
import 'package:trading_club/logic/notifiers/user_info_notifier.dart';
import 'package:trading_club/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrencyPair extends ConsumerStatefulWidget {
  const CurrencyPair({super.key});

  @override
  ConsumerState createState() => _CurrencyPairState();
}

class _CurrencyPairState extends ConsumerState<CurrencyPair> {
  static const List<DropdownMenuItem<String>> pairItems = [
    DropdownMenuItem(
      value: Helper.usdEur,
      child: Text(Helper.usdEur),
    ),
    DropdownMenuItem(
      value: Helper.usdJpy,
      child: Text(Helper.usdJpy),
    ),
    DropdownMenuItem(
      value: Helper.usdRub,
      child: Text(Helper.usdRub),
    ),
    DropdownMenuItem(
      value: Helper.eurRub,
      child: Text(Helper.eurRub),
    ),
    DropdownMenuItem(
      value: Helper.usdChf,
      child: Text(Helper.usdChf),
    ),
    DropdownMenuItem(
      value: Helper.usdCad,
      child: Text(Helper.usdCad),
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoSharedPrefsNP);
    final selectedPair = ref.watch(selectedPairSP);
    final selectedTimer = ref.watch(timerNP(selectedPair));
    final isTablet = ref.watch(deviceInfoNP);
    final currentBids = ref.watch(currentBidsNP);

    return Align(
      alignment: isTablet ? Alignment.topCenter : Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 15.h,
        ),
        child: SizedBox(
          height: isTablet ? 50.h : 60.h,
          child: ListView.builder(
            itemCount: currentBids.length + 1,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Container(
                  width: isTablet ? 100.w : 150.w,
                  height: isTablet ? 40.h : 50.h,
                  decoration: BoxDecoration(
                    color: Helper.greyTile,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      value: selectedPair,
                      items: pairItems,
                      style: TextStyle(
                        color: const Color(0xFF7A7A7A),
                        fontSize: 17.sp,
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
                      dropdownColor: Helper.greyTile,
                      onChanged: (pair) {
                        if (selectedPair == pair!) return;

                        ref.read(selectedPairSP.notifier).update((state) => pair);

                        changeData();
                      },
                    ),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Container(
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: Helper.yellow,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Row(
                      children: [
                        Text(
                          currentBids[index - 1].pair,
                          style: TextStyle(
                            color: Helper.black,
                            fontSize: 17.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.10,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            ref.read(madeBidSP.notifier).update((state) => {
                                  ...state,
                                  currentBids[index - 1].pair: false,
                                });
                            await ref.read(userInfoSharedPrefsNP.notifier).setBalance(
                                  userInfo.balance + currentBids[index - 1].bid,
                                );
                            ref.read(currentBidsNP.notifier).removeBid(
                                  currentBids[index - 1],
                                );
                            ref
                                .read(timerNP(currentBids[index - 1].pair).notifier)
                                .setTimer(selectedTimer);
                            ref.read(timerNP(currentBids[index - 1].pair).notifier).cancelBid();
                          },
                          child: const Icon(
                            Icons.close_outlined,
                            color: Helper.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
