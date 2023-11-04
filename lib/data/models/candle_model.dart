import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'candle_model.g.dart';

@JsonSerializable(createToJson: false)
class Candle {
  final String open;
  final String high;
  final String low;
  final String close;
  @JsonKey(name: 'datetime')
  final DateTime time;

  const Candle({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.time,
  });

  factory Candle.fromJson(Map<String, dynamic> json) => _$CandleFromJson(json);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'open': double.parse(open),
        'high': double.parse(high),
        'low': double.parse(low),
        'close': double.parse(close),
        'time': DateFormat('yyyy-MM-dd hh:mm').format(time),
      };
}
