import 'dart:io';

import 'package:built_value/serializer.dart';
import 'package:test/test.dart';
import 'package:togglTool/configuration/ConfigurationReader.dart';

void main() {
  Directory.current = 'test/configuration';

  test('read Properties', () async {
    final config = await ConfigurationReader.readConfiguration();

    expect(config.email, 'example@gmail.com');
    expect(config.apiKey, '123456569832893278');
  });
}
