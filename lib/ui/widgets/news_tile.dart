import 'package:trading_club/data/helper.dart';
import 'package:trading_club/data/models/news_model.dart';
import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:trading_club/ui/screens/news_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as time_ago;

class NewsTile extends ConsumerStatefulWidget {
  final News news;

  const NewsTile({
    super.key,
    required this.news,
  });

  @override
  ConsumerState createState() => _NewsTileState();
}

class _NewsTileState extends ConsumerState<NewsTile> {
  String formatRemainingTime(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void removeFirstSentenceWithSameTitle(News news) {
    if (news.text!.startsWith(news.title!)) {
      final titleLength = news.title!.length;
      final bodyWithoutFirstSentence = news.text!.substring(titleLength).trimLeft();
      news.text = bodyWithoutFirstSentence;
    }
    // news.image = null;
  }

  @override
  void initState() {
    super.initState();
    removeFirstSentenceWithSameTitle(widget.news);
  }

  double setWidth({required bool isTablet}) {
    double value = 210.w;

    // TODO refactor this
    if (isTablet) {
      if (widget.news.image == null) {
        value = 150.w;
      } else {
        value = 100.w;
      }
    } else {
      if (widget.news.image == null) {
        value = 340.w;
      }
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = ref.watch(deviceInfoNP);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(news: widget.news),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Helper.greyTile,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: setWidth(isTablet: isTablet),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.news.title ?? 'no title',
                            maxLines: 2,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.10,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            widget.news.text ?? 'no text',
                            maxLines: 2,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xFF7A7A7A),
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.10,
                            ),
                          ),
                          widget.news.image == null ? Container() : SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                    if (widget.news.image != null) ...[
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              widget.news.image!,
                              fit: BoxFit.cover,
                              height: 120.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Divider(
                height: 8,
                color: Helper.grey,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 11),
                // padding: EdgeInsets.zero,
                child: Text(
                  widget.news.dateTime == null
                      ? 'unknown'
                      // : timeago.format(
                      //     DateFormat('dd.MM.y').parse(
                      //       DateTime.fromMillisecondsSinceEpoch(widget.news.dateTime!).toString(),
                      //     ),
                      //     // DateTime.fromMillisecondsSinceEpoch(widget.news.dateTime!),
                      //   ),
                      : time_ago.format(
                          DateFormat('dd.MM.y').parse(widget.news.dateTime!),
                        ),
                  style: TextStyle(
                    color: const Color(0xFF7A7A7A),
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.10,
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
