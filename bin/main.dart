import 'package:togglTool/ConfigurationReader.dart';
import 'package:togglTool/TimeEntry.dart';
import 'package:togglTool/TogglClient.dart';
import 'dart:io';
import 'dart:convert';

void main(List<String> arguments) async {
  try {
    var config = await ConfigurationReader.readConfiguration();
    var client = TogglClient(config.apiKey, config.email, DateTime.now());
    var body = await client.getDetailsReport('1636155');

    List<dynamic> entries = body['data'];
    var mappedEntries = entries.map((entry) => TimeEntry(entry)).fold<Map<String, List<TimeEntry>>>({}, (prev, entry) {
      var list = prev[entry.getWeekday()] ??= [];
      list.add(entry);
      prev[entry.getWeekday()] = list;
      return prev;
    }).map((weekday, entryList) {
      var descMap = entryList.fold<Map<String, TimeEntry>>({}, (prev, entry) {
        if (prev.containsKey(entry.description)) {
          prev[entry.description].milliSecsDur += entry.milliSecsDur;
        } else {
          prev[entry.description] = entry;
        }
        return prev;
      });
      return MapEntry(weekday, descMap);
    });

    var prettyprint = JsonEncoder.withIndent('  ').convert(mappedEntries);

    print(prettyprint);
    exit(0);
  } catch (e) {
    print(e);
  } finally {
    exit(-1);
  }
}
