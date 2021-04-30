import 'dart:convert';
import 'dart:io';

import 'ConfigurationFile.dart';

class ConfigurationReader {
  static Future<ConfigurationFile> readConfigurationFromFile(
      String configurationFile) async {
    final configMap = await File(configurationFile)
        .readAsString()
        .then((content) => jsonDecode(content));

    final config = ConfigurationFile(configMap['email'], configMap['apiKey']);

    if (config.email == null || config.email == '') {
      throw AssertionError('Missing email field in "config.json"');
    }

    if (config.apiKey == null || config.apiKey == '') {
      throw AssertionError('Missing apiKey field in "config.json"');
    }

    return config;
  }

  static Future<ConfigurationFile> readConfiguration() async {
    return readConfigurationFromFile('config.json');
  }
}
