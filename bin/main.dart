import 'package:togglTool/ConfigurationReader.dart';
import 'package:togglTool/DataConverter.dart';
import 'package:togglTool/TogglClient.dart';
import 'dart:io';
import 'dart:convert';

void main(List<String> arguments) async {
  try {
    var config = await ConfigurationReader.readConfiguration();
    var client = TogglClient(config.apiKey, config.email, DateTime.now());
    var body = await client.getDetailsReport('1636155');

    var mappedEntries = DataConverter().doConversion(body);

    var prettyprint = JsonEncoder.withIndent('  ').convert(mappedEntries);

    print(prettyprint);
    exit(0);
  } catch (e) {
    print(e);
  } finally {
    exit(-1);
  }
}
