// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_bids_notifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentBid _$CurrentBidFromJson(Map<String, dynamic> json) => CurrentBid(
      pair: json['pair'] as String,
      up: json['up'] as bool,
      timeLeft: Duration(microseconds: json['timeLeft'] as int),
      bid: (json['bid'] as num).toDouble(),
      dealTime: DateTime.parse(json['dealTime'] as String),
      openPrice: (json['openPrice'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CurrentBidToJson(CurrentBid instance) =>
    <String, dynamic>{
      'pair': instance.pair,
      'up': instance.up,
      'timeLeft': instance.timeLeft.inMicroseconds,
      'bid': instance.bid,
      'dealTime': instance.dealTime.toIso8601String(),
      'openPrice': instance.openPrice,
    };
