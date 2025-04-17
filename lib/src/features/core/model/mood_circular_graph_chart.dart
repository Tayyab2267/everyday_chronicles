class MoodCircularGraphData{
  final int date;
  final String moodName;

  MoodCircularGraphData(this.date, this.moodName);
}

List<MoodCircularGraphData> getCircularChartData(){
  final List<MoodCircularGraphData> circularChartData = [
    MoodCircularGraphData(5, "Fantastic"),
    MoodCircularGraphData(10, "Happy"),
    MoodCircularGraphData(3, "Normal"),
    MoodCircularGraphData(6, "Boring"),
    MoodCircularGraphData(6, "Sad"),
  ];

  return circularChartData;
}