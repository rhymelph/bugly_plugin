import 'package:flutter/material.dart';
import 'dart:async';
import 'bugly_plugin.dart';
import 'package:flutter/foundation.dart';


void runCatchErrorApp(Widget widget,String androidAppId,String iosAppId) async {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    await BuglyPlugin.initCrashReport(iosAppId, true);
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    await BuglyPlugin.initCrashReport(androidAppId, true);
  }
  _ErrorManager.init();
  runZoned(() => runApp(widget), onError: (Object obj, StackTrace stack) {
    debugPrint('''${obj.toString()}
${stack.toString()}
    ''');
    _ErrorManager.reportError(obj, stack);
  });
}

class _ErrorManager {
  static void init() {
    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrint('''${details.exceptionAsString()}
${details.stack}
    ''');
      reportError(details.exceptionAsString(), details.stack);
    };
  }
  static void reportError(Object message, StackTrace stack) {
    BuglyPlugin.postCatchedException(message, stack);
  }
}
