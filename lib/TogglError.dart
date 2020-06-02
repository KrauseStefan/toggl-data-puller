class TogglError implements Exception {
  String message;
  String tip;
  int code;
 
  TogglError(Map<String, dynamic> errorObj) {
    message = errorObj['message'];
    tip = errorObj['tip'];
    code = errorObj['code'];
  }

  @override
  String toString() {
    return 'code ${code}: ${message}\n${tip}';
  }
}
