import 'dart:convert';
import 'dart:io';

import 'package:togglTool/serializers/serializers.dart';

import 'ConfigurationFile.dart';

class ConfigurationReader {
  static Future<ConfigurationFile> readConfigurationFromFile(
      String configurationFile) async {
    final content = await File(configurationFile).readAsString();

    final config = serializers.deserializeWith(
        ConfigurationFile.serializer, json.decode(content));

    return config;
  }

  static Future<ConfigurationFile> readConfiguration() async {
    return readConfigurationFromFile('config.json');
  }
}
