import 'dart:convert';
import 'dart:io';
import 'package:togglTool/toggl/TogglError.dart';

const domain = 'api.track.toggl.com';
const reportsBaseUrl = 'reports/api/v2';
const weeklyUrl = '$reportsBaseUrl/weekly';
const summaryUrl = '$reportsBaseUrl/summary';
const detailsUrl = '$reportsBaseUrl/details';

// https://github.com/toggl/toggl_api_docs/blob/master/reports.md#request-parameters

class TogglRestClient {
  String _authorizationHeaders;
  final String email;

  TogglRestClient(final String apiKey, final this.email) {
    _authorizationHeaders =
        'Basic ' + base64Encode(utf8.encode('$apiKey:api_token'));
  }

  bool _requestSuccessful(final HttpClientResponse resp) {
    return resp.statusCode >= 200 && resp.statusCode < 300;
  }

  Future<Map<String, dynamic>> _sendRequest(
      final String url, final Map<String, String> query) async {
    final uri = Uri.https(domain, url, query);

    final req = await HttpClient().getUrl(uri);
    req.headers.add('authorization', _authorizationHeaders);

    final resp = await req.close();
    final responseStr =
        await resp.transform(Utf8Decoder()).reduce((prev, cur) => prev + cur);
    final responseData = jsonDecode(responseStr);
    if (_requestSuccessful(resp)) {
      return responseData;
    }

    throw TogglError(responseData['error']);
  }

  Future<Map<String, dynamic>> getWeeklyReport(final String workspaceId) async {
    return await _sendRequest(weeklyUrl, {
      'user_agent': email,
      'workspace_id': workspaceId,
    });
  }

  Future<Map<String, dynamic>> getSummaryReport(
      final String workspaceId, final List<String> timeSpan) async {
    return await _sendRequest(summaryUrl, {
      'user_agent': email,
      'workspace_id': workspaceId,
      'since': timeSpan[0],
      'until': timeSpan[1],
    });
  }

  Future<Map<String, dynamic>> getDetailsReport(
      final String workspaceId, final List<String> timeSpan) async {
    return await _sendRequest(detailsUrl, {
      'user_agent': email,
      'workspace_id': workspaceId,
      'since': timeSpan[0],
      'until': timeSpan[1],
      'page': '1',
      // 'display_hours': 'decimal',
    });
  }
}
