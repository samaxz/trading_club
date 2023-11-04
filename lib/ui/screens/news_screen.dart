import 'package:trading_club/logic/notifiers/device_info_notifier.dart';
import 'package:trading_club/ui/widgets/news/news_screen_mobile_builder.dart';
import 'package:trading_club/ui/widgets/news/news_screen_tablet_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTablet = ref.watch(deviceInfoNP);

    return Scaffold(
      body: isTablet ? const NewsScreenTabletBuilder() : const NewsScreenMobileBuilder(),
    );
  }
}
