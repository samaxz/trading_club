import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WidgetMethods {
  static Widget placeImage({
    required String imagePath,
    required bool isTablet,
    required bool isBigTablet,
  }) {
    Widget widget = Align(
      alignment: Alignment.topCenter,
      child: Image.asset(imagePath),
    );

    if (isTablet) {
      widget = Positioned(
        top: -120.h,
        left: 10.w,
        right: 10.w,
        bottom: 30.h,
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(imagePath),
        ),
      );
    }

    if (isBigTablet) {
      widget = Positioned(
        top: -140.h,
        left: 10.w,
        right: 10.w,
        bottom: 40.h,
        child: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(imagePath),
        ),
      );
    }

    return widget;
  }

  static double shouldWrapHeader({
    required bool wrapText,
    required bool isTablet,
    required bool isBigTablet,
  }) {
    double value = 230.h;

    // if (wrapText) {
    //   if (isTablet) {
    //     value = 180.h;
    //   }
    //   if (isBigTablet) {
    //     value = 150.h;
    //   } else {
    //     value = 270.h;
    //   }
    // } else {
    //   if (isTablet) {
    //     value = 180.h;
    //   }
    //   if (isBigTablet) {
    //     value = 150.h;
    //   } else {
    //     value = 230.h;
    //   }
    // }

    if (isTablet) {
      value = 180.h;
    }
    if (isBigTablet) {
      value = 150.h;
    }
    if (wrapText) {
      value = 270.h;
    }

    return value;
  }

  static double shouldWrapBody({
    required bool wrapText,
    required bool isTablet,
    required bool isBigTablet,
  }) {
    double value = 200.h;

    // if (wrapText) {
    //   if (isTablet) {
    //     value = 150.h;
    //     if (isBigTablet) {
    //       value = 120.h;
    //     }
    //   } else {
    //     value = 240.h;
    //   }
    // } else {
    //   if (isTablet) {
    //     value = 150.h;
    //     if (isBigTablet) {
    //       value = 120.h;
    //     }
    //   } else {
    //     value = 200.h;
    //   }
    // }

    if (isTablet) {
      value = 150.h;
    }
    if (isBigTablet) {
      value = 120.h;
    }
    if (wrapText) {
      value = 240.h;
    }

    return value;
  }

  // ************************
  static double positionDots({
    required bool isTablet,
    required bool isBigTablet,
  }) {
    double value = 115.h;

    if (isTablet) {
      value = 105.h;
    }
    // TODO test this case
    // if (isBigTablet) {}

    return value;
  }
}

class Helper {
  const Helper._();

  static const String appIcon = 'assets/icons/app_icon.jpg';

  static const String checkSplash = 'assets/icons/check_splash.png';
  static const String pocketSplash = 'assets/icons/pocket_splash.png';
  static const String settings = 'assets/icons/settings.png';
  static const String history = 'assets/icons/history.png';
  static const String chevronRight = 'assets/icons/chevron_right.png';
  static const String simulator = 'assets/icons/simulator.png';
  static const String progress = 'assets/icons/progress.png';
  static const String news = 'assets/icons/news.png';
  static const String camera = 'assets/icons/camera.png';
  static const String drawer = 'assets/icons/drawer.png';
  static const String chevronDown = 'assets/icons/chevron_down.png';
  static const String balance = 'assets/icons/balance.png';
  static const String timer = 'assets/icons/timer.png';
  static const String bid = 'assets/icons/bid.png';
  static const String arrowUp = 'assets/icons/arrow_up.png';
  static const String arrowDown = 'assets/icons/arrow_down.png';
  static const String historyBar = 'assets/icons/history_bar.png';
  static const String bidUp = 'assets/icons/bid_up.png';
  static const String bidDown = 'assets/icons/bid_down.png';
  static const String telegramIcon = 'assets/icons/telegram.png';
  static const String closeButton = 'assets/icons/close_button.png';

  static const String euroPng = 'assets/icons/euro.png';
  static const String dollarPng = 'assets/icons/dollar.png';
  static const String yenPng = 'assets/icons/yen.png';
  static const String poundPng = 'assets/icons/pound.png';
  static const String frankPng = 'assets/icons/frank.png';
  static const String rublePng = 'assets/icons/ruble.png';
  static const String canDolPng = 'assets/icons/can_dol.png';

  static const String onboarding1 = 'assets/images/onboarding_1.png';
  static const String onboarding2Plug = 'assets/images/onboarding_2_plug.png';

  // TODO delete these
  static const String onboarding1Pocket = 'assets/images/onboarding_1_pocket.png';
  static const String onboarding2PlugPocket = 'assets/images/onboarding_2_plug_pocket.png';

  // TODO delete some of these
  static const String onboarding2WebView = 'assets/images/onboarding_2_web_view.png';
  static const String telegramDialog = 'assets/images/telegram.png';
  static const String notificationsDialog = 'assets/images/notifications.png';
  static const String onboarding2WebViewPocket = 'assets/images/onboarding_2_web_view_pocket.png';
  static const String notificationsDialogPocket = 'assets/images/notifications_pocket.png';

  static const Color yellow = Color(0xFFF8D000);
  static const Color grey = Color(0xFF3A3C3F);
  static const Color greySecondary = Color(0xFF7A7A7A);
  static const Color black = Color(0xFF080809);
  static const Color greyTile = Color(0xFF252525);
  static const Color blue = Color(0xFF2A8CFF);

  static const String usdEur = 'USD/EUR';
  static const String usdJpy = 'USD/JPY';
  static const String usdRub = 'USD/RUB';
  static const String eurRub = 'EUR/RUB';
  static const String usdChf = 'USD/CHF';
  static const String usdCad = 'USD/CAD';
}
