import 'package:json_annotation/json_annotation.dart';

part 'news_model_alt.g.dart';

@JsonSerializable()
class NewsAlt {
  final int? id;
  final String? headline;
  String? image;
  final int? dateTime;
  String? summary;

  NewsAlt({
    this.id,
    this.headline,
    this.image,
    this.dateTime,
    this.summary,
  });

  factory NewsAlt.fromJson(Map<String, dynamic> json) => _$NewsAltFromJson(json);

  NewsAlt copyWith({
    int? id,
    String? headline,
    String? image,
    int? dateTime,
    String? summary,
  }) {
    return NewsAlt(
      id: id ?? this.id,
      headline: headline ?? this.headline,
      image: image ?? this.image,
      dateTime: dateTime ?? this.dateTime,
      summary: summary ?? this.summary,
    );
  }

  @override
  String toString() {
    return 'News{id: $id, headline: $headline, image: $image, dateTime: $dateTime, summary: $summary}';
  }
}
