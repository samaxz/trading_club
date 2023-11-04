import 'dart:convert';

import 'package:trading_club/logic/notifiers/user_info_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'progress_notifier.g.dart';

@JsonSerializable()
class UserProgress {
  int points;
  int level;
  Map<int, DateTime> time;
  int deals;
  int successfulDeals;
  double maxBid;
  Map<int, bool> verifyGiven;

  UserProgress({
    required this.points,
    required this.level,
    required this.time,
    required this.deals,
    required this.successfulDeals,
    required this.maxBid,
    required this.verifyGiven,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) => _$UserProgressFromJson(json);

  Map<String, dynamic> toJson() => _$UserProgressToJson(this);

  UserProgress copyWith({
    int? points,
    int? level,
    Map<int, DateTime>? time,
    int? deals,
    int? successfulDeals,
    double? maxBid,
    Map<int, bool>? verifyGiven,
  }) {
    return UserProgress(
      points: points ?? this.points,
      level: level ?? this.level,
      time: time ?? this.time,
      deals: deals ?? this.deals,
      successfulDeals: successfulDeals ?? this.successfulDeals,
      maxBid: maxBid ?? this.maxBid,
      verifyGiven: verifyGiven ?? this.verifyGiven,
    );
  }

  @override
  String toString() {
    return 'UserProgress{points: $points, level: $level, time: $time, deals: $deals, successfulDeals: $successfulDeals, maxBid: $maxBid, verifyGiven: $verifyGiven}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgress &&
          runtimeType == other.runtimeType &&
          points == other.points &&
          level == other.level &&
          time == other.time &&
          deals == other.deals &&
          successfulDeals == other.successfulDeals &&
          maxBid == other.maxBid &&
          verifyGiven == other.verifyGiven;

  @override
  int get hashCode =>
      points.hashCode ^
      level.hashCode ^
      time.hashCode ^
      deals.hashCode ^
      successfulDeals.hashCode ^
      maxBid.hashCode ^
      verifyGiven.hashCode;
}

class ProgressNotifier extends StateNotifier<UserProgress> {
  final Ref ref;
  final SharedPreferences prefs;

  ProgressNotifier({
    required this.ref,
    required this.prefs,
  }) : super(
          UserProgress(
            points: 0,
            level: 1,
            time: {},
            deals: 0,
            successfulDeals: 0,
            maxBid: 0,
            verifyGiven: {
              100: false,
              200: false,
              500: false,
              1000: false,
            },
          ),
        ) {
    // Future.microtask(() async {
    //   final currentProgress = _getProgress();
    //
    //   if (currentProgress == null) {
    //     // await setInitialProgress();
    //     await updateProgress(state);
    //   } else {
    //     state = currentProgress;
    //   }
    // });

    final currentProgress = _getProgress();

    if (currentProgress != null) {
      // hopefully, i shouldn't be using copy with here
      // instead
      state = currentProgress;
    }
  }

  // this gets the progress and sets the initial value for it if the
  // progress hasn't been set previously
  Future<void> setInitialProgress() async {
    final progressString = prefs.getString('progress');

    if (progressString == null) {
      await updateProgress(state);
    }
  }

  UserProgress? _getProgress() {
    final progressString = prefs.getString('progress');

    if (progressString == null) {
      return null;
    }
    final progressJson = jsonDecode(progressString);
    final progress = UserProgress.fromJson(progressJson);

    return progress;
  }

  // this'll pass in the current state which'll be modified
  Future<void> updateProgress(UserProgress progress) async {
    await prefs.setString(
      'progress',
      jsonEncode(
        progress.toJson(),
      ),
    );

    state = progress;
  }

  Future<void> resetProgress() async {
    await updateProgress(
      UserProgress(
        points: 0,
        level: 1,
        time: {},
        deals: 0,
        successfulDeals: 0,
        maxBid: 0,
        verifyGiven: {
          100: false,
          200: false,
          500: false,
          1000: false,
        },
      ),
    );
  }
}

final progressNP = StateNotifierProvider<ProgressNotifier, UserProgress>(
  (ref) => ProgressNotifier(
    ref: ref,
    prefs: ref.read(sharedPrefsP),
  ),
);
