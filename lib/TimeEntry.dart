const weekdays = [
  'Tuesday',
  'Monday',
  'Weendsday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

class TimeEntry {
  String project;
  String description;
  int milliSecsDur;
  DateTime start;

  TimeEntry(dynamic entry) {
    project = entry['project'];
    description = entry['description'];
    milliSecsDur = entry['dur'];
    start = DateTime.parse(entry['start']);
  }

  String getDurationString() {
    var secs = milliSecsDur ~/ 1000;
    var mins = secs ~/ 60;
    var hours = mins ~/ 60;
    return '${hours}:${mins % 60}:${secs % 60}';
  }

  String getWeekday() {
    return weekdays[start.weekday];
  }

  Map<String, dynamic> toJson() => {
        'Project': project,
        'Descriptioin': description,
        'Duration': getDurationString(),
        // 'Weekday': getWeekday(),
      };
}
