// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_notifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) => UserProgress(
      points: json['points'] as int,
      level: json['level'] as int,
      time: (json['time'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), DateTime.parse(e as String)),
      ),
      deals: json['deals'] as int,
      successfulDeals: json['successfulDeals'] as int,
      maxBid: (json['maxBid'] as num).toDouble(),
      verifyGiven: (json['verifyGiven'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as bool),
      ),
    );

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{
      'points': instance.points,
      'level': instance.level,
      'time': instance.time
          .map((k, e) => MapEntry(k.toString(), e.toIso8601String())),
      'deals': instance.deals,
      'successfulDeals': instance.successfulDeals,
      'maxBid': instance.maxBid,
      'verifyGiven':
          instance.verifyGiven.map((k, e) => MapEntry(k.toString(), e)),
    };
