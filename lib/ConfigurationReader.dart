import 'dart:convert';
import 'dart:io';

class Config {
  String email;
  String apiKey;
}

class ConfigurationReader {
  static Future<Config> readConfiguration() async {
    var configMap = await File('config.json')
      .readAsString()
      .then((content) => jsonDecode(content));

    var config = Config();
    config.email = configMap['email'];
    config.apiKey = configMap['apikey'];

    if(config.email == null || config.email == '') {
      print('Missing email field in "config.json"');
    }

    if(config.apiKey == null || config.apiKey == '') {
      print('Missing apikey field in "config.json"');
    }

    return config;
  }
}
