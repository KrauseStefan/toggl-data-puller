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

    return config;
  }
}

