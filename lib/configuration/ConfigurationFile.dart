import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'ConfigurationFile.g.dart';

abstract class ConfigurationFile
    implements Built<ConfigurationFile, ConfigurationFileBuilder> {
  static Serializer<ConfigurationFile> get serializer =>
      _$configurationFileSerializer;

  String get email;
  String get apiKey;

  factory ConfigurationFile([Function(ConfigurationFileBuilder) updates]) =
      _$ConfigurationFile;
  ConfigurationFile._();
}
