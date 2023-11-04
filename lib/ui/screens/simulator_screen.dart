import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:trading_club/logic/notifiers/finished_bids_notifier.dart';
import 'package:trading_club/logic/notifiers/timer_notifier.dart';
import 'package:trading_club/ui/widgets/bids/bid_alert_dialog.dart';
import 'package:trading_club/ui/widgets/simulator/simulator_currency_pair.dart';
import 'package:trading_club/ui/widgets/simulator/simulator_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trading_club/ui/widgets/simulator/simulator_menu.dart';

final bidAmountSP = StateProvider<double>((ref) => 50);

class SimulatorScreen extends ConsumerWidget {
  const SimulatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = ref.watch(deviceInfoNP);
    final finishedBids = ref.watch(finishedBidsNP);

    ref.listen(showAlertDialogSP, (_, state) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return BidAlertDialog(
            pair: finishedBids.last.pair,
            bid: finishedBids.last.invested.toString(),
            won: finishedBids.last.won,
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: isTablet ? null : Helper.greyTile,
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isTablet) ...[
                  SizedBox(height: 30.h),
                ],
                const Expanded(
                  child: SimulatorWindow(),
                ),
                if (isTablet) ...[
                  SizedBox(height: 20.h),
                ],
                const SimulatorMenu(),
              ],
            ),
            const CurrencyPair(),
          ],
        ),
      ),
    );
  }
}
