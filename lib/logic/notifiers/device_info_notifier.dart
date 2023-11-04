import 'dart:core';

import 'package:trading_club/logic/notifiers/user_info_notifier.dart';
import 'package:trading_club/logic/services/forex_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// false - isn't tablet, true - is a tablet
class DeviceInfoNotifier extends StateNotifier<bool> {
  final Dio dio;
  final SharedPreferences prefs;

  DeviceInfoNotifier(
    this.dio,
    this.prefs,
  ) : super(false) {
    final data = isTablet();
    state = data;
  }

  bool isTablet() {
    final data = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.single);
    return data.size.shortestSide < 550 ? false : true;
  }
}

final deviceInfoNP = StateNotifierProvider<DeviceInfoNotifier, bool>(
  (ref) => DeviceInfoNotifier(
    ref.read(dioP),
    ref.read(sharedPrefsP),
  ),
);
