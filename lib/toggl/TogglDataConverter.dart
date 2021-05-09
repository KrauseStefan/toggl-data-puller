import 'package:togglTool/dto/TimeEntry.dart';

class DataConverter {
  Map<Weekday, Map<String, dynamic>> doConversion(Map<String, dynamic> body) {
    List<dynamic> entries = body['data'];
    return entries
        .map((entry) => TimeEntry.FromJson(entry))
        .fold<Map<Weekday, List<TimeEntry>>>({}, _groupEntriesByWeekday).map(
            (weekday, entryList) {
      final descriptionMap = entryList
          .fold<Map<String, TimeEntry>>({}, _summarizeDurationByDescription);
      return MapEntry(weekday, descriptionMap);
    });
  }

  Map<Weekday, List<TimeEntry>> _groupEntriesByWeekday(
      Map<Weekday, List<TimeEntry>> prev, TimeEntry entry) {
    var list = prev[entry.getWeekday()] ??= [];
    list.add(entry);
    prev[entry.getWeekday()] = list;
    return prev;
  }

  Map<String, TimeEntry> _summarizeDurationByDescription(
      Map<String, TimeEntry> prev, TimeEntry entry) {
    if (prev.containsKey(entry.description)) {
      prev[entry.description].millisecondsDuration +=
          entry.millisecondsDuration;
    } else {
      prev[entry.description] = entry;
    }
    return prev;
  }
}
