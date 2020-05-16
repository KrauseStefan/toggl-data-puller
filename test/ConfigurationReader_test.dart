import 'dart:io';

import 'package:test/test.dart';
import 'package:togglTool/ConfigurationReader.dart';

void main() {
  test('calculate', () async {
    Directory.current = 'test';
    var config = await ConfigurationReader.readConfiguration();

    expect(config.email, 'example@gmail.com');
    expect(config.apiKey, '123456569832893278');
  });
}
