# toggl-data-puller

Small tool to pull data from toggl.

This is Work in progress, the intention is to in the end af first half of a pipeline to sync data into JIRA.

To initialize run:

``` bash
flutter pub get
flutter packages pub run build_runner build
```

To run: `dart bin/main_toggl_export.dart`
To run tests: `pub run test test`

To format run `dartfmt .`

Note: These commands assume running through flutter, they all are possible to use without the flutter command/framework.
