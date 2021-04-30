import 'package:togglTool/configuration/ConfigurationReader.dart';
import 'package:togglTool/toggl/TogglDataConverter.dart';
import 'package:togglTool/toggl/TogglRestClient.dart';
import 'dart:io';
import 'dart:convert';

void main(List<String> arguments) async {
  try {
    final config = await ConfigurationReader.readConfiguration();
    final client = TogglRestClient(config.apiKey, config.email, DateTime.now());
    final body = await client.getDetailsReport('1636155');

    final mappedEntries = DataConverter().doConversion(body);

    final prettyprint = JsonEncoder.withIndent('  ').convert(mappedEntries);

    print(prettyprint);
    exit(0);
  } catch (e) {
    print(e);
  } finally {
    exit(-1);
  }
}
