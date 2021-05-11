import 'package:collection/collection.dart';

import 'package:togglTool/dto/TimeEntry.dart';

extension MapValues<K, V> on Map<K, V> {
  Map<K, V2> mapValues<V2>(V2 Function(V value) convert) {
    return map((key, value) => MapEntry(key, convert(value)));
  }
}

extension IterableGroup<V> on Iterable<V> {
  Map<K, Iterable<V>> group<K>(K Function(V value) select) {
    return groupBy<V, K>(this, select);
  }
}

class DataConverter {
  static Iterable<TimeEntry> parseTimeEntries(Map<String, dynamic> body) {
    List<dynamic> data = body['data'];
    return data.map((entry) => TimeEntry.FromJson(entry));
  }

  static Map<Weekday, Map<String, TimeEntry>> getWeekOverview(
      Iterable<TimeEntry> timeEntries) {
    final entriesByWeekday = _groupByWeekday(timeEntries);
    final weekOverview = entriesByWeekday.mapValues(_sumByDesc);
    return weekOverview;
  }

  static Map<Weekday, List<TimeEntry>> _groupByWeekday(
      Iterable<TimeEntry> timeEntries) {
    return timeEntries.group((entry) => entry.getWeekday());
  }

  static Map<String, TimeEntry> _sumByDesc(Iterable<TimeEntry> timeEntries) {
    final timeEntriesByDesc = _groupByDesc(timeEntries);
    return timeEntriesByDesc.mapValues(_sumTimeEntries);
  }

  static TimeEntry _sumTimeEntries(Iterable<TimeEntry> timeEntries) {
    final totalTime = timeEntries.map((entry) => entry.duration).sum;

    return timeEntries.first.copyWithDuration(totalTime);
  }

  static Map<String, Iterable<TimeEntry>> _groupByDesc(
      List<TimeEntry> timeEntries) {
    return timeEntries.group((entry) => entry.description);
  }
}
