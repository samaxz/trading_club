import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trading_club/data/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Map<String, List<String>> pairIcon = {
  Helper.usdEur: [Helper.dollarPng, Helper.euroPng],
  Helper.usdJpy: [Helper.dollarPng, Helper.yenPng],
  Helper.usdRub: [Helper.dollarPng, Helper.rublePng],
  Helper.eurRub: [Helper.euroPng, Helper.rublePng],
  Helper.usdChf: [Helper.dollarPng, Helper.frankPng],
  Helper.usdCad: [Helper.dollarPng, Helper.canDolPng],
};

class BidAlertDialog extends ConsumerWidget {
  final String pair;
  final String bid;
  final bool won;

  const BidAlertDialog({
    super.key,
    required this.pair,
    required this.bid,
    required this.won,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.only(bottom: 120),
      content: Container(
        decoration: BoxDecoration(
          color: Helper.greyTile,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1.5,
            color: Helper.grey,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Result',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.10,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Helper.grey,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 55,
                        width: 55,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                radius: 15.r,
                                backgroundImage: AssetImage(pairIcon[pair]!.first),
                              ),
                            ),
                            // Positioned(
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Helper.greyTile,
                                    width: 1,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 16.r,
                                  backgroundImage: AssetImage(pairIcon[pair]!.last),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        pair,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.10,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '\$$bid',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 45,
                width: 170,
                decoration: BoxDecoration(
                  color: won ? const Color(0x192EBB2E) : const Color(0x19CA3131),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Text(
                    won ? '+100 points' : '-100 points',
                    style: TextStyle(
                      color: won ? const Color(0xFF2EBB2E) : const Color(0xFFCB3131),
                      fontSize: 20.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Opacity(
                opacity: 0.80,
                child: Text(
                  won ? 'You made money on this deal.' : 'You lost on this trade.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.20,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Container(
                    width: 139,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 9),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF7CF00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Opacity(
                      opacity: 0.80,
                      child: Text(
                        'Ok',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF070808),
                          fontSize: 19.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
