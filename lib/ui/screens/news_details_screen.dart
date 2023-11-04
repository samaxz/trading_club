import 'package:trading_club/data/helper.dart';
import 'package:trading_club/data/models/news_model.dart';
import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as time_ago;

class NewsDetailScreen extends ConsumerStatefulWidget {
  final News news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  ConsumerState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends ConsumerState<NewsDetailScreen> {
  void removeFirstSentenceWithSameTitle(News news) {
    if (news.text!.startsWith(news.title!)) {
      final titleLength = news.title!.length;
      final bodyWithoutFirstSentence = news.text!.substring(titleLength).trimLeft();
      news.text = bodyWithoutFirstSentence;
    }
  }

  @override
  void initState() {
    super.initState();
    removeFirstSentenceWithSameTitle(widget.news);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ref.watch(deviceInfoNP);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: isTablet ? -20.h : -50.h,
            child: SizedBox(
              height: 1.sh + 45.h,
              width: 1.sw,
              child: ListView(
                children: [
                  widget.news.image == null
                      ? Container(
                          height: 50.h,
                        )
                      : SizedBox(
                          child: Image.network(
                            widget.news.image!,
                            fit: BoxFit.fill,
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 0.h),
                    child: Text(
                      widget.news.dateTime == null
                          ? 'unknown'
                          // : timeago.format(
                          //     DateFormat('dd.MM.y').parse(
                          //       DateTime.fromMillisecondsSinceEpoch(widget.news.dateTime!)
                          //           .toString(),
                          //     ),
                          //   ),
                          : time_ago.format(
                              DateFormat('dd.MM.y').parse(widget.news.dateTime!),
                            ),
                      style: TextStyle(
                        color: const Color(0xFF7A7A7A),
                        fontSize: 13.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.10,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 5.h),
                    child: Text(
                      widget.news.title ?? 'no title',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.10,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 0.h),
                    child: Text(
                      widget.news.text ?? 'no text',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: isTablet ? 10.w : 10.w,
            top: isTablet ? 40.h : 60.h,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                CupertinoIcons.chevron_back,
                // size: 33,
                size: 22.r,
                color: widget.news.image == null ? Helper.greySecondary : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
