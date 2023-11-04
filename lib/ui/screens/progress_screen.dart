import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:trading_club/logic/notifiers/finished_bids_notifier.dart';
import 'package:trading_club/logic/notifiers/progress_notifier.dart';
import 'package:trading_club/ui/widgets/achievement_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(progressNP);
    final history = ref.watch(finishedBidsNP).reversed;
    final isTablet = ref.watch(deviceInfoNP);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 12.h),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 50.w : 12.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Helper.greyTile,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 6.h,
                        left: 8.w,
                        right: 8.w,
                        bottom: 10.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Level: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.10,
                              ),
                              children: [
                                TextSpan(
                                  text: progress.level.toString(),
                                  style: TextStyle(
                                    color: const Color(0xFFF7CF00),
                                    fontSize: 23.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '${progress.points} / ${progress.level * 4000}',
                            style: TextStyle(
                              color: const Color(0xFF7A7A7A),
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.10,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          LinearProgressIndicator(
                            backgroundColor: Colors.grey.shade700,
                            value: progress.points.remainder(4000) / 4000,
                            minHeight: 4.h,
                            borderRadius: BorderRadius.circular(8.r),
                            color: Helper.yellow,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Text(
                      'Achievements',
                      style: TextStyle(
                        color: Colors.white,
                        // fontSize: 20,
                        fontSize: 16.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.10,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 50.w : 12.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: isTablet ? 4 : 1.85,
              ),
              delegate: SliverChildListDelegate(
                [
                  AchievementTile(
                    text: 'Bidding for \$100',
                    // if it's not completed, then use the progress below
                    completed: progress.maxBid >= 100,
                    // otherwise, show the date of achievement and the amount
                    // of earned points
                    completion: '${progress.maxBid.toInt()} / 100',
                    index: 0,
                    reward: 5000,
                    progressBar: progress.maxBid / 100,
                    history: history.where((element) => element.invested >= 100).toList(),
                    auxiliaryText: '\$ bid',
                  ),
                  AchievementTile(
                    text: 'Bidding for \$200',
                    completed: progress.maxBid >= 200,
                    completion: '${progress.maxBid.toInt()} / 200',
                    index: 1,
                    reward: 7000,
                    progressBar: progress.maxBid / 200,
                    history: history.where((element) => element.invested >= 200).toList(),
                    auxiliaryText: '\$ bid',
                  ),
                  AchievementTile(
                    text: '10 successful deals',
                    completed: progress.successfulDeals >= 10,
                    completion: '${progress.successfulDeals} / 10',
                    index: 2,
                    reward: 5000,
                    progressBar: progress.successfulDeals / 10,
                    history: history.where((element) => element.won).take(10).toList(),
                    auxiliaryText: ' successful deals',
                  ),
                  AchievementTile(
                    text: '20 deals',
                    completed: progress.deals >= 20,
                    completion: '${progress.deals} / 20',
                    index: 3,
                    reward: 7000,
                    progressBar: progress.deals / 20,
                    history: history.take(20).toList(),
                    auxiliaryText: ' deals',
                  ),
                  AchievementTile(
                    text: '40 deals',
                    completed: progress.deals >= 40,
                    completion: '${progress.deals} / 40',
                    index: 4,
                    reward: 10000,
                    progressBar: progress.deals / 40,
                    history: history.take(40).toList(),
                    auxiliaryText: ' deals',
                  ),
                  AchievementTile(
                    text: '100 deals',
                    completed: progress.deals >= 100,
                    completion: '${progress.deals} / 100',
                    index: 5,
                    reward: 15000,
                    progressBar: progress.deals / 100,
                    history: history.take(100).toList(),
                    auxiliaryText: ' deals',
                  ),
                  AchievementTile(
                    text: '20 successful deals',
                    completed: progress.successfulDeals >= 20,
                    completion: '${progress.successfulDeals} / 20',
                    index: 6,
                    reward: 10000,
                    progressBar: progress.successfulDeals / 20,
                    history: history.where((element) => element.won).take(20).toList(),
                    auxiliaryText: ' successful deals',
                  ),
                  AchievementTile(
                    text: '80 successful deals',
                    completed: progress.successfulDeals >= 80,
                    completion: '${progress.successfulDeals} / 80',
                    index: 7,
                    reward: 15000,
                    progressBar: progress.successfulDeals / 80,
                    history: history.where((element) => element.won).take(80).toList(),
                    auxiliaryText: ' successful deals',
                  ),
                  AchievementTile(
                    text: 'Bidding for \$500',
                    completed: progress.maxBid >= 500,
                    completion: '${progress.maxBid.toInt()} / 500',
                    index: 8,
                    reward: 10000,
                    progressBar: progress.maxBid / 500,
                    history: history.where((element) => element.invested >= 500).toList(),
                    auxiliaryText: '\$ bid',
                  ),
                  AchievementTile(
                    text: 'Bidding for \$1000',
                    completed: progress.maxBid >= 1000,
                    completion: '${progress.maxBid.toInt()} / 1000',
                    index: 9,
                    reward: 15000,
                    progressBar: progress.maxBid / 1000,
                    history: history.where((element) => element.invested >= 1000).toList(),
                    auxiliaryText: '\$ bid',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
