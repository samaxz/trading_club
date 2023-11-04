// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) => News(
      id: json['resultId'] as int?,
      title: json['resultTitle'] as String?,
      image: json['resultImage'] as String?,
      mark: json['resultMark'] as String?,
      dateTime: json['resultDateTime'] as String?,
      text: json['resultText'] as String?,
      totalLikes: json['resultTotalLikes'] as int?,
      totalComments: json['resultComments'] as int?,
    );

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'resultId': instance.id,
      'resultTitle': instance.title,
      'resultImage': instance.image,
      'resultMark': instance.mark,
      'resultDateTime': instance.dateTime,
      'resultText': instance.text,
      'resultTotalLikes': instance.totalLikes,
      'resultComments': instance.totalComments,
    };
