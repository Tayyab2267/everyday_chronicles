import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../constants/colors.dart';
import '../../model/mood_Line_graph_data.dart';
import '../../model/mood_circular_graph_chart.dart';

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  late List<MoodLineGraphData> _lineChartData;
  late TooltipBehavior _tooltipBehaviorLine;

  late List<MoodCircularGraphData> _CircularChartData;
  late TooltipBehavior _tooltipBehaviorCircluar;

  @override
  void initState() {
    _lineChartData = getLineChartData();
    _tooltipBehaviorLine = TooltipBehavior(enable: true);

    _CircularChartData = getCircularChartData();
    _tooltipBehaviorCircluar = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? myHomeScreenBackgroundDarkColor
          : myHomeScreenBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 2,
        title: Text(
          "Insight",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                height: 330,
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SfCartesianChart(
                        title: ChartTitle(
                            text: "Emotion Line Graph",
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            alignment: ChartAlignment.center),
                        tooltipBehavior: _tooltipBehaviorLine,
                        series: <CartesianSeries>[
                          LineSeries<MoodLineGraphData, int>(
                            // Correct type: CartesianSeries
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            width: 3,
                            dataSource: _lineChartData,
                            xValueMapper: (MoodLineGraphData mood, _) =>
                                mood.date,
                            yValueMapper: (MoodLineGraphData mood, _) =>
                                mood.moodNumber,
                            enableTooltip: true,
                          ),
                        ],
                        primaryXAxis: NumericAxis(
                          title: AxisTitle(
                            text: "Date",
                          ),
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          maximum: 31,
                          minimum: 1,
                          majorGridLines: const MajorGridLines(width: 1),
                        ),
                        primaryYAxis: NumericAxis(
                          title: AxisTitle(
                            text: "Emotions",
                          ),
                          maximum: 5,
                          minimum: 1,
                          majorGridLines: const MajorGridLines(width: 1),
                          majorTickLines: const MajorTickLines(size: 0),
                          interval: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 300,
                decoration: BoxDecoration(
                  color: Get.isDarkMode ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SfCircularChart(
                        title: ChartTitle(
                            text: "Emotion Circular Graph",
                            textStyle: Theme.of(context).textTheme.bodyLarge,
                            alignment: ChartAlignment.center),
                        legend: const Legend(
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap),
                        tooltipBehavior: _tooltipBehaviorCircluar,
                        series: <CircularSeries>[
                          PieSeries<MoodCircularGraphData, String>(
                            dataSource: _CircularChartData,
                            xValueMapper: (MoodCircularGraphData mood, _) =>
                                mood.moodName,
                            yValueMapper: (MoodCircularGraphData mood, _) =>
                                mood.date,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            enableTooltip: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
