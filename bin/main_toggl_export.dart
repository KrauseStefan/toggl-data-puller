import 'package:intl/intl.dart';
import 'package:togglTool/configuration/ConfigurationReader.dart';
import 'package:togglTool/toggl/TogglDataConverter.dart';
import 'package:togglTool/toggl/TogglRestClient.dart';
import 'dart:io';
import 'dart:convert';

List<String> getLastWeekTimeSpan(final DateTime now) {
  final sunday = now.subtract(Duration(days: now.weekday));
  final since =
      DateFormat('yyyy-MM-dd').format(sunday.subtract(Duration(days: 7)));
  final until = DateFormat('yyyy-MM-dd').format(sunday);
  return [since, until];
}

Object mapper(dynamic object) {
  if (object is Map<Weekday, dynamic>) {
    return object.map((weekday, value) => MapEntry(weekday.toJson(), value));
  }
  return object.toJson();
}

void printJson(Map<dynamic, dynamic> json) {
  final prettyprint = JsonEncoder.withIndent('  ', mapper).convert(json);
  print(prettyprint);
}

void main(List<String> arguments) async {
  const togglWorkspaceID = '1636155';

  try {
    final now = DateTime.now();
    final timespan = getLastWeekTimeSpan(now);

    final config = await ConfigurationReader.readConfiguration();
    final togglClient = TogglRestClient(config.apiKey, config.email);
    final body = await togglClient.getDetailsReport(togglWorkspaceID, timespan);
    final mappedEntries = DataConverter().doConversion(body);

    printJson(mappedEntries);

    exit(0);
  } catch (e) {
    print(e);
  } finally {
    exit(-1);
  }
}
