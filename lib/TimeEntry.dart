const weekdays = [
  'Tuesday',
  'Monday',
  'Weendsday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

var jiraIdRegex = RegExp(r'\w{4}-\d+');

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

  String getJiraId() {
    return jiraIdRegex.firstMatch(description)?.group(0);
  }

  Map<String, dynamic> toJson() => {
    'Project': project,
    'Descriptioin': description,
    'Duration': getDurationString(),
    'JiraId': getJiraId(),
    // 'Weekday': getWeekday(),
  };
}
