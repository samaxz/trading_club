import 'package:json_annotation/json_annotation.dart';

part 'news_model.g.dart';

@JsonSerializable()
class News {
  @JsonKey(name: 'resultId')
  final int? id;
  @JsonKey(name: 'resultTitle')
  final String? title;
  @JsonKey(name: 'resultImage')
  String? image;
  @JsonKey(name: 'resultMark')
  final String? mark;
  @JsonKey(name: 'resultDateTime')
  final String? dateTime;
  @JsonKey(name: 'resultText')
  String? text;
  @JsonKey(name: 'resultTotalLikes')
  final int? totalLikes;
  @JsonKey(name: 'resultComments')
  final int? totalComments;

  News({
    this.id,
    this.title,
    this.image,
    this.mark,
    this.dateTime,
    this.text,
    this.totalLikes,
    this.totalComments,
  });

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  @override
  String toString() {
    return 'News{id: $id, title: $title, image: $image, mark: $mark, dateTime: $dateTime, text: $text, totalLikes: $totalLikes, totalComments: $totalComments}';
  }

  News copyWith({
    int? id,
    String? title,
    String? image,
    String? mark,
    String? dateTime,
    String? text,
    int? totalLikes,
    int? totalComments,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      mark: mark ?? this.mark,
      dateTime: dateTime ?? this.dateTime,
      text: text ?? this.text,
      totalLikes: totalLikes ?? this.totalLikes,
      totalComments: totalComments ?? this.totalComments,
    );
  }
}

// import 'package:json_annotation/json_annotation.dart';
//
// import 'dart:convert';
//
// part 'news_model.g.dart';
//
// @JsonSerializable()
// class News {
//   final int? id;
//   final String? headline;
//   String? image;
//   final int? dateTime;
//   String? summary;
//
//   News({
//     this.id,
//     this.headline,
//     this.image,
//     this.dateTime,
//     this.summary,
//   });
//
//   factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
//
//   News copyWith({
//     int? id,
//     String? headline,
//     String? image,
//     int? dateTime,
//     String? summary,
//   }) {
//     return News(
//       id: id ?? this.id,
//       headline: headline ?? this.headline,
//       image: image ?? this.image,
//       dateTime: dateTime ?? this.dateTime,
//       summary: summary ?? this.summary,
//     );
//   }
//
//   @override
//   String toString() {
//     return 'News{id: $id, headline: $headline, image: $image, dateTime: $dateTime, summary: $summary}';
//   }
// }
