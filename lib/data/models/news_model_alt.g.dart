// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model_alt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsAlt _$NewsAltFromJson(Map<String, dynamic> json) => NewsAlt(
      id: json['id'] as int?,
      headline: json['headline'] as String?,
      image: json['image'] as String?,
      dateTime: json['dateTime'] as int?,
      summary: json['summary'] as String?,
    );

Map<String, dynamic> _$NewsAltToJson(NewsAlt instance) => <String, dynamic>{
      'id': instance.id,
      'headline': instance.headline,
      'image': instance.image,
      'dateTime': instance.dateTime,
      'summary': instance.summary,
    };
