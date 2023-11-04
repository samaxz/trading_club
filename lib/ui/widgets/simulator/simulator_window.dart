import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trading_club/data/models/candle_model.dart';
import 'package:trading_club/data/helper.dart';
import 'package:trading_club/logic/notifiers/forex_api_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// this'll be the selected timer bid, which when the user selects, will
// update the chart time frame accordingly
final selectedTimerBidSP = StateProvider(
  (ref) => const Duration(minutes: 5),
);

class SimulatorWindow extends ConsumerStatefulWidget {
  const SimulatorWindow({super.key});

  @override
  ConsumerState createState() => _SimulatorWindowState();
}

class _SimulatorWindowState extends ConsumerState<SimulatorWindow> {
  late final TrackballBehavior trackballBehavior;

  @override
  void initState() {
    super.initState();
    trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final candles = ref.watch(forexApiNP);

    return Container(
      color: Helper.black,
      child: candles.when(
        data: (data) => SfCartesianChart(
          plotAreaBorderWidth: 0,
          margin: const EdgeInsets.only(top: 10),
          series: <CandleSeries>[
            CandleSeries<Candle, DateTime>(
              dataSource: data.reversed.toList(),
              enableSolidCandles: true,
              xValueMapper: (candle, _) => candle.time,
              lowValueMapper: (candle, _) => double.parse(candle.low),
              highValueMapper: (candle, _) => double.parse(candle.high),
              openValueMapper: (candle, _) => double.parse(candle.open),
              closeValueMapper: (candle, _) => double.parse(candle.close),
            ),
          ],
          trackballBehavior: trackballBehavior,
          enableAxisAnimation: true,
          primaryXAxis: DateTimeCategoryAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            labelPlacement: LabelPlacement.onTicks,
            interval: 5,
            plotOffset: 0,
            axisLine: const AxisLine(
              color: Helper.black,
              width: 0,
            ),
            borderWidth: 0,
            intervalType: DateTimeIntervalType.minutes,
            axisBorderType: AxisBorderType.withoutTopAndBottom,
          ),
          annotations: [
            CartesianChartAnnotation(
              horizontalAlignment: ChartAlignment.near,
              coordinateUnit: CoordinateUnit.point,
              y: double.parse(data.first.open),
              widget: Row(
                children: [
                  const Spacer(),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: Helper.yellow,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        double.parse(data.first.open).toStringAsFixed(3),
                        maxLines: 1,
                        style: TextStyle(
                          overflow: TextOverflow.clip,
                          fontSize: 13.sp,
                          color: Helper.black,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          primaryYAxis: NumericAxis(
            plotBands: [
              PlotBand(
                dashArray: const [20, 20],
                sizeType: DateTimeIntervalType.minutes,
                start: double.parse(data.first.open),
                end: double.parse(data.first.open),
                borderColor: Colors.yellow,
                borderWidth: 2,
              ),
            ],
            axisLine: const AxisLine(
              width: 0,
              color: Helper.black,
            ),
            desiredIntervals: 4,
            borderWidth: 0,
            borderColor: Helper.black,
            axisBorderType: AxisBorderType.withoutTopAndBottom,
            opposedPosition: true,
          ),
        ),
        error: (error, stackTrace) => Center(
          child: TextButton(
            onPressed: () => ref.read(forexApiNP.notifier).getCandles(),
            child: const Text('try again'),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
