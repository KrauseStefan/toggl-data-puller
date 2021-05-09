enum Weekday {
  Tuesday,
  Monday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday,
}

const weekdays = Weekday.values;

extension ParseToString on Weekday {
  String toJson() {
    return toString().split('.').last;
  }
}

class TimeEntry {
  static final _jiraIdRegex = RegExp(r'\w{4}-\d+');

  final String project;
  final String description;
  int millisecondsDuration;
  final DateTime start;

  TimeEntry(
      this.project, this.description, this.millisecondsDuration, this.start);

  TimeEntry.FromJson(dynamic entry)
      : project = entry['project'],
        description = entry['description'],
        millisecondsDuration = entry['dur'],
        start = DateTime.parse(entry['start']);

  String getDurationString() {
    final secs = millisecondsDuration ~/ 1000;
    final mins = secs ~/ 60;
    final hours = mins ~/ 60;
    return '$hours:${mins % 60}:${secs % 60}';
  }

  Weekday getWeekday() {
    return weekdays[start.weekday];
  }

  String getJiraId() {
    return _jiraIdRegex.firstMatch(description)?.group(0);
  }

  Map<String, dynamic> toJson() => {
        'Project': project,
        'Description': description,
        'Duration': getDurationString(),
        'JiraId': getJiraId(),
        // 'Weekday': getWeekday(),
      };
}
