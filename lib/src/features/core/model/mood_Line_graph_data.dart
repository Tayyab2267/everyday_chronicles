class MoodLineGraphData{
  final int date;
  final int moodNumber;

  MoodLineGraphData(this.date, this.moodNumber);
}

List<MoodLineGraphData> getLineChartData(){
  final List<MoodLineGraphData> lineChartData = [
    MoodLineGraphData(6, 5),
    MoodLineGraphData(13, 1),
    MoodLineGraphData(20, 3),
    MoodLineGraphData(27, 2),
  ];

  return lineChartData;
}