import 'dart:convert';
import 'dart:io';
import 'package:togglTool/TogglError.dart';
import 'package:intl/intl.dart';

const domain = 'toggl.com';
const reportsBaseUrl = 'reports/api/v2';
const weeklyUrl = '${reportsBaseUrl}/weekly';
const summaryUrl = '${reportsBaseUrl}/summary';
const detailsUrl = '${reportsBaseUrl}/details';

// https://github.com/toggl/toggl_api_docs/blob/master/reports.md#request-parameters

class TogglClient {
  String _authorizationHeaders;
  String _email;
  DateTime _now;

  TogglClient(String apiKey, String email, DateTime nowOverride) {
    if(nowOverride == null) {
      _now = nowOverride;
    } else {
      _now = DateTime.now();
    }

    _email = email;
    _authorizationHeaders = 'Basic ' + base64Encode(utf8.encode('$apiKey:api_token'));
  }

  bool _requestSucessfull(HttpClientResponse resp) {
    return resp.statusCode >= 200 && resp.statusCode < 300;
  }

  Future<Map<String, dynamic>> _sendRequest(String url, Map<String, String> query) async {
    var uri = Uri.https(domain, url, query);

    var req = await HttpClient().getUrl(uri);
    req.headers.add('authorization', _authorizationHeaders);

    var resp = await req.close();
    var responseStr = await resp.transform(Utf8Decoder()).reduce((prev, cur) => prev + cur);
    var responseData = jsonDecode(responseStr);
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
    var timeSpan = _getLastWeekTimeSpan();
    return await _sendRequest(summaryUrl, {
      'user_agent': _email,
      'workspace_id': workspaceId,
      'since': timeSpan[0], // ISO 8601 date (YYYY-MM-DD) format. Defaults to today - 6 days.
      'until': timeSpan[1], // ISO 8601 date (YYYY-MM-DD) format.
    });
  }

  Future<Map<String, dynamic>> getDetailsReport(String workspaceId) async {
    var timeSpan = _getLastWeekTimeSpan();
    return await _sendRequest(detailsUrl, {
      'user_agent': _email,
      'workspace_id': workspaceId,
      'since': timeSpan[0], // ISO 8601 date (YYYY-MM-DD) format. Defaults to today - 6 days.
      'until': timeSpan[1], // ISO 8601 date (YYYY-MM-DD) format.
      'page': '1',
      // 'display_hours': 'decimal',
    });
  }

  List<String> _getLastWeekTimeSpan() {
    var sunday = _now.subtract(Duration(days: _now.weekday));
    var since = DateFormat('yyyy-MM-dd').format(sunday.subtract(Duration(days: 7)));
    var until = DateFormat('yyyy-MM-dd').format(sunday);
    return [since, until];
  }

}
