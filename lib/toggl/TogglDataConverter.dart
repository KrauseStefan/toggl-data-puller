import 'package:togglTool/dto/TimeEntry.dart';

class DataConverter {
  Map<String, Map<String, dynamic>> doConversion(Map<String, dynamic> body) {
    List<dynamic> entries = body['data'];
    return entries
        .map((entry) => _createTimeEntry(entry))
        .fold<Map<String, List<TimeEntry>>>({}, _groupEntriesByWeekday).map(
            (weekday, entryList) {
      final descriptionMap = entryList
          .fold<Map<String, TimeEntry>>({}, _summarizeDurationByDescription);
      return MapEntry(weekday, descriptionMap);
    });
  }

  TimeEntry _createTimeEntry(dynamic entry) {
    final timeEntry = TimeEntry(entry['project'], entry['description'],
        entry['dur'], DateTime.parse(entry['start']));
    return timeEntry;
  }

  Map<String, List<TimeEntry>> _groupEntriesByWeekday(
      Map<String, List<TimeEntry>> prev, TimeEntry entry) {
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
