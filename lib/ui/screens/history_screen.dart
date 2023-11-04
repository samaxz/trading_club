import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:trading_club/ui/widgets/bids/current_bids/current_bids_mobile_builder.dart';
import 'package:trading_club/ui/widgets/bids/current_bids/current_bids_tablet_builder.dart';
import 'package:trading_club/ui/widgets/bids/finished_bids/finished_bids_mobile_builder.dart';
import 'package:trading_club/ui/widgets/bids/finished_bids/finished_bids_tablet_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final isTablet = ref.watch(deviceInfoNP);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(
              left: isTablet ? 50.w : 15.w,
              top: 15.h,
              bottom: 15.h,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => currentTab = 0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 9.h,
                      ),
                      decoration: ShapeDecoration(
                        color: currentTab == 0 ? Helper.yellow : Helper.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                          side: currentTab != 0
                              ? BorderSide(
                                  width: 1.w,
                                  color: Helper.grey,
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: Opacity(
                        opacity: 0.8,
                        child: Text(
                          'Current',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: currentTab == 0 ? Helper.black : Helper.greySecondary,
                            fontSize: 17.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 13.w),
                  GestureDetector(
                    onTap: () => setState(() => currentTab = 1),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 9.h,
                      ),
                      // padding: EdgeInsets.zero,
                      decoration: ShapeDecoration(
                        color: currentTab == 1 ? Helper.yellow : Helper.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                          side: currentTab != 1
                              ? BorderSide(
                                  width: 1.w,
                                  color: Helper.grey,
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: Opacity(
                        opacity: 0.80,
                        child: Text(
                          'Finished',
                          style: TextStyle(
                            color: currentTab == 1 ? Helper.black : Helper.greySecondary,
                            // fontSize: 20,
                            fontSize: 17.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (currentTab == 0) ...[
            if (isTablet) ...[
              const CurrentBidsTabletBuilder()
            ] else ...[
              const CurrentBidsMobileBuilder()
            ],
          ] else ...[
            if (isTablet) ...[
              const FinishedBidsTabletBuilder()
            ] else ...[
              const FinishedBidsMobileBuilder()
            ],
          ],
        ],
      ),
    );
  }
}
