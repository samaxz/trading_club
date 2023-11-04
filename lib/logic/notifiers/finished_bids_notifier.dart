import 'dart:convert';
import 'dart:developer';

import 'package:trading_club/logic/notifiers/user_info_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'finished_bids_notifier.g.dart';

@JsonSerializable()
class FinishedBid {
  final bool won;
  final String pair;
  final double returns;
  final double invested;
  final DateTime timeFinished;

  const FinishedBid({
    required this.won,
    required this.pair,
    required this.returns,
    required this.invested,
    required this.timeFinished,
  });

  factory FinishedBid.fromJson(Map<String, dynamic> json) => _$FinishedBidFromJson(json);

  Map<String, dynamic> toJson() => _$FinishedBidToJson(this);

  FinishedBid copyWith({
    bool? won,
    String? pair,
    double? returns,
    double? invested,
    DateTime? timeFinished,
  }) {
    return FinishedBid(
      won: won ?? this.won,
      pair: pair ?? this.pair,
      returns: returns ?? this.returns,
      invested: invested ?? this.invested,
      timeFinished: timeFinished ?? this.timeFinished,
    );
  }

  @override
  String toString() {
    return 'FinishedBid{won: $won, pair: $pair, returns: $returns, invested: $invested, timeFinished: $timeFinished}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FinishedBid &&
          runtimeType == other.runtimeType &&
          won == other.won &&
          pair == other.pair &&
          returns == other.returns &&
          invested == other.invested &&
          timeFinished == other.timeFinished;

  @override
  int get hashCode =>
      won.hashCode ^ pair.hashCode ^ returns.hashCode ^ invested.hashCode ^ timeFinished.hashCode;
}

class FinishedBidsNotifier extends StateNotifier<List<FinishedBid>> {
  final SharedPreferences prefs;

  FinishedBidsNotifier(this.prefs) : super([]) {
    final finishedBids = getBids();

    state = [
      ...state,
      ...finishedBids,
    ];
  }

  Future<void> saveBid(FinishedBid finishedBid) async {
    final decodedBids = getBids();
    decodedBids.add(finishedBid);

    final encodedBids = decodedBids.map((bid) => jsonEncode(bid.toJson())).toList();
    await prefs.setStringList(
      'finished_bids',
      encodedBids,
    );

    state = List.from(state)..add(finishedBid);
  }

  List<FinishedBid> getBids() {
    try {
      final bidsString = prefs.getStringList('finished_bids');

      if (bidsString == null) return [];
      final bidsJsonList = bidsString.map((bid) => jsonDecode(bid)).toList();
      final bids = bidsJsonList.map((bid) => FinishedBid.fromJson(bid)).toList();

      return bids;
    } catch (e, st) {
      log('error got caught inside getBids():', error: e, stackTrace: st);
      return [];
    }
  }

  // this is for manual testing purposes only
  Future<void> resetBids() async {
    await prefs.setStringList(
      'finished_bids',
      [],
    );
  }
}

final finishedBidsNP = StateNotifierProvider<FinishedBidsNotifier, List<FinishedBid>>(
  (ref) => FinishedBidsNotifier(
    ref.read(sharedPrefsP),
  ),
);
