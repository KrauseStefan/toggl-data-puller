import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:togglTool/TogglClient.dart';
import 'package:mockito/mockito.dart';

const testApiKey = 'jkdsjno3niod990';
const testEmail = 'test@email.com';
const testWorkspaceId = 'testWorkspaceID';

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

void main() {
  var httpClientMock = MockHttpClient();
  var httpClientRequestMock = MockHttpClientRequest();
  var httpClientResponseMock = MockHttpClientResponse();
  var httpHeadersMock = MockHttpHeaders();

  var authHeader = 'Basic ' + base64Encode(utf8.encode('$testApiKey:api_token'));
  const jsonExample = '{"unique": "value"}';

  test('getDetailsReport', () async {
    await HttpOverrides.runZoned(() async {
      when(httpClientRequestMock.headers).thenReturn(httpHeadersMock);

      when(httpClientMock.getUrl(any)).thenAnswer((_) => Future.value(httpClientRequestMock));

      when(httpClientRequestMock.close()).thenAnswer((_) => Future.value(httpClientResponseMock));

      var jsonStream = Stream.value(jsonExample);
      when(httpClientResponseMock.transform(any)).thenAnswer((_) => jsonStream);

      when(httpClientResponseMock.statusCode).thenReturn(200);

      var client = TogglClient(testApiKey, testEmail);
      var result = await client.getDetailsReport(testWorkspaceId);

      var queryMap = extractQueryParams(httpClientMock);
      expectToContainKeyValuePair(queryMap, 'user_agent', testEmail);

      var headerKeyValuePair = verify(httpHeadersMock.add(captureAny, captureAny)).captured;
      expect(headerKeyValuePair[0], 'authorization');
      expect(headerKeyValuePair[1], authHeader);

      var jsonResult = JsonEncoder().convert(result);
      expect(jsonResult, encodeDecodeJson(jsonExample));
    }, createHttpClient: (SecurityContext c) => httpClientMock);
  });
}

void expectToContainKeyValuePair<A, B>(Iterable<MapEntry<A, B>> map, A key, B value) {
  try {
    var entry = map.singleWhere((e) => e.key == key);
    expect(entry.key, key);
    expect(entry.value, value);
  } catch (e) {
    print('Unable to lookup key: "$key", with value: "$value"');
    rethrow;
  }
}

Iterable<MapEntry<String, String>> extractQueryParams(MockHttpClient httpClientMock) {
  Uri uri = verify(httpClientMock.getUrl(captureAny)).captured[0];
  return uri.queryParameters.entries;
}

String encodeDecodeJson(String json) {
  return JsonEncoder().convert(jsonDecode(json));
}
