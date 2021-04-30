import 'dart:convert';
import 'dart:io';
import 'package:togglTool/toggl/TogglError.dart';
import 'package:intl/intl.dart';

const domain = 'api.track.toggl.com';
const reportsBaseUrl = 'reports/api/v2';
const weeklyUrl = '$reportsBaseUrl/weekly';
const summaryUrl = '$reportsBaseUrl/summary';
const detailsUrl = '$reportsBaseUrl/details';

// https://github.com/toggl/toggl_api_docs/blob/master/reports.md#request-parameters

class TogglRestClient {
  String _authorizationHeaders;
  String _email;
  DateTime _now;

  TogglRestClient(String apiKey, String email, DateTime nowOverride) {
    if (nowOverride == null) {
      _now = nowOverride;
    } else {
      _now = DateTime.now();
    }

    _email = email;
    _authorizationHeaders =
        'Basic ' + base64Encode(utf8.encode('$apiKey:api_token'));
  }

  bool _requestSucessfull(HttpClientResponse resp) {
    return resp.statusCode >= 200 && resp.statusCode < 300;
  }

  Future<Map<String, dynamic>> _sendRequest(
      String url, Map<String, String> query) async {
    final uri = Uri.https(domain, url, query);

    final req = await HttpClient().getUrl(uri);
    req.headers.add('authorization', _authorizationHeaders);

    final resp = await req.close();
    final responseStr =
        await resp.transform(Utf8Decoder()).reduce((prev, cur) => prev + cur);
    final responseData = jsonDecode(responseStr);
    if (_requestSucessfull(resp)) {
      return responseData;
    }

    throw TogglError(responseData['error']);
  }

  Future<Map<String, dynamic>> getWeeklyReport(String workspaceId) async {
    return await _sendRequest(weeklyUrl, {
      'user_agent': _email,
      'workspace_id': workspaceId,
    });
  }

  Future<Map<String, dynamic>> getSummaryReport(String workspaceId) async {
    final timeSpan = _getLastWeekTimeSpan();
    return await _sendRequest(summaryUrl, {
      'user_agent': _email,
      'workspace_id': workspaceId,
      'since': timeSpan[0],
      'until': timeSpan[1],
    });
  }

  Future<Map<String, dynamic>> getDetailsReport(String workspaceId) async {
    final timeSpan = _getLastWeekTimeSpan();
    return await _sendRequest(detailsUrl, {
      'user_agent': _email,
      'workspace_id': workspaceId,
      'since': timeSpan[0],
      'until': timeSpan[1],
      'page': '1',
      // 'display_hours': 'decimal',
    });
  }

  List<String> _getLastWeekTimeSpan() {
    final sunday = _now.subtract(Duration(days: _now.weekday));
    final since =
        DateFormat('yyyy-MM-dd').format(sunday.subtract(Duration(days: 7)));
    final until = DateFormat('yyyy-MM-dd').format(sunday);
    return [since, until];
  }
}
