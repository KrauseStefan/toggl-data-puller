import 'dart:io';

import 'package:test/test.dart';
import 'package:togglTool/configuration/ConfigurationReader.dart';

void main() {
  Directory.current = 'test/configuration';

  final throwsAssertionError = throwsA(TypeMatcher<AssertionError>());

  test('read Properties', () async {
    final config = await ConfigurationReader.readConfiguration();

    expect(config.email, 'example@gmail.com');
    expect(config.apiKey, '123456569832893278');
  });

  test('fail on missing email', () async {
    expect(
        ConfigurationReader.readConfigurationFromFile(
            'config-missing-email.json'),
        throwsAssertionError);
  });

  test('fail on missing apiKey', () async {
    expect(
        ConfigurationReader.readConfigurationFromFile(
            'config-missing-apiKey.json'),
        throwsAssertionError);
  });
}
