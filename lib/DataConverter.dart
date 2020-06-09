import 'package:togglTool/TimeEntry.dart';

class DataConverter {
  Map<String, Map<String, dynamic>> doConversion(Map<String, dynamic> body) {
    List<dynamic> entries = body['data'];
    var mappedEntries = entries
      .map((entry) => TimeEntry(entry))
      .fold<Map<String, List<TimeEntry>>>({}, _groupEntriesByWeekday)
      .map((weekday, entryList) {
        var descMap = entryList.fold<Map<String, TimeEntry>>({}, _summarizeDurationByDescription);
        return MapEntry(weekday, descMap);
      });

    return mappedEntries;
  }

  Map<String, List<TimeEntry>> _groupEntriesByWeekday(Map<String, List<TimeEntry>> prev, TimeEntry entry) {
    var list = prev[entry.getWeekday()] ??= [];
    list.add(entry);
    prev[entry.getWeekday()] = list;
    return prev;
  }

  Map<String, TimeEntry> _summarizeDurationByDescription(Map<String, TimeEntry> prev, TimeEntry entry) {
    if (prev.containsKey(entry.description)) {
      prev[entry.description].milliSecsDur += entry.milliSecsDur;
    } else {
      prev[entry.description] = entry;
    }
    return prev;
  }
}
