import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trading_club/data/helper.dart';
import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final String? icon;
  final String text;
  final double? size;
  final bool isLast;
  final bool isFirst;
  final VoidCallback? onTap;

  const DrawerTile({
    super.key,
    this.icon,
    required this.text,
    this.size,
    this.isLast = false,
    this.isFirst = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Helper.greyTile,
          borderRadius: isFirst
              ? BorderRadius.only(
                  topLeft: Radius.circular(4.r),
                  topRight: Radius.circular(4.r),
                )
              : isLast
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(4.r),
                      bottomRight: Radius.circular(4.r),
                    )
                  : null,
        ),
        child: Padding(
          padding: isLast
              ? EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 15.h)
              : EdgeInsets.symmetric(horizontal: 14.r),
          child: Row(
            children: [
              icon == null
                  ? const SizedBox()
                  : Image.asset(
                      icon!,
                      width: size,
                      height: size,
                    ),
              SizedBox(width: icon == null ? 3.w : 12.w),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.5.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: -0.10,
                ),
              ),
              const Spacer(),
              Image.asset(
                Helper.chevronRight,
                width: 22.w,
                height: 22.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
