// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finished_bids_notifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FinishedBid _$FinishedBidFromJson(Map<String, dynamic> json) => FinishedBid(
      won: json['won'] as bool,
      pair: json['pair'] as String,
      returns: (json['returns'] as num).toDouble(),
      invested: (json['invested'] as num).toDouble(),
      timeFinished: DateTime.parse(json['timeFinished'] as String),
    );

Map<String, dynamic> _$FinishedBidToJson(FinishedBid instance) =>
    <String, dynamic>{
      'won': instance.won,
      'pair': instance.pair,
      'returns': instance.returns,
      'invested': instance.invested,
      'timeFinished': instance.timeFinished.toIso8601String(),
    };
