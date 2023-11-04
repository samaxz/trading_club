import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_bids_notifier.g.dart';

@JsonSerializable()
class CurrentBid {
  final String pair;
  final bool up;
  final Duration timeLeft;
  final double bid;
  final DateTime dealTime;
  final double? openPrice;

  const CurrentBid({
    required this.pair,
    required this.up,
    required this.timeLeft,
    required this.bid,
    required this.dealTime,
    this.openPrice,
  });

  factory CurrentBid.fromJson(Map<String, dynamic> json) => _$CurrentBidFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentBidToJson(this);
}

class CurrentBidsNotifier extends StateNotifier<List<CurrentBid>> {
  final Ref ref;

  CurrentBidsNotifier(this.ref) : super([]);

  void makeBid(CurrentBid currentBid) => state = List.from(state)..add(currentBid);

  void removeBid(CurrentBid currentBid) => state = List.from(state)..remove(currentBid);
}

final currentBidsNP = StateNotifierProvider<CurrentBidsNotifier, List<CurrentBid>>(
  (ref) => CurrentBidsNotifier(ref),
);
