import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

class MobileUsageTime extends StatefulWidget {
  const MobileUsageTime({Key? key}) : super(key: key);

  @override
  _MobileUsageTimeState createState() => _MobileUsageTimeState();
}

class _MobileUsageTimeState extends State<MobileUsageTime> {
  List<UsageInfo> usageStats = [];

  @override
  void initState() {
    super.initState();
    fetchUsageStats();
  }

  Future<void> fetchUsageStats() async {
    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);

    // grant usage permission - opens Usage Settings
    UsageStats.grantUsagePermission();

    // check if permission is granted
    bool? isPermission = await UsageStats.checkUsagePermission();

    if (isPermission!) {
      // query usage stats
      List<UsageInfo> stats = await UsageStats.queryUsageStats(startDate, endDate);
      setState(() {
        // Filter out apps with 0 minutes of usage time
        usageStats = stats.where((usage) => getMinutes(usage.totalTimeInForeground) > 0).toList();
      });
    } else {
      // Handle permission not granted
    }
  }

  // Helper function to convert milliseconds to minutes
  int getMinutes(String? totalTimeInForeground) {
    int milliseconds = int.tryParse(totalTimeInForeground!) ?? 0;
    return (milliseconds / (1000 * 60)).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Usage Time'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mobile Usage Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: usageStats.length,
                itemBuilder: (context, index) {
                  final usage = usageStats[index];
                  int minutes = getMinutes(usage.totalTimeInForeground);
                  return ListTile(
                    title: Text('${usage.packageName}'),
                    subtitle: Text('Total time: $minutes minutes'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
