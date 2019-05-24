import 'dart:async';

import 'package:flutter/services.dart';

class BuglyPlugin {
  static const MethodChannel _channel = const MethodChannel('bugly_plugin');

  static Future<void> initCrashReport(String appId, bool isDebug) async{
    return await _channel.invokeMethod('initCrashReport', {
      'appId': appId,
      'isDebug': isDebug,
    });
  }

  static Future<void> postCatchedException(Object message, StackTrace stack)async {
    return await _channel.invokeMethod('postCatchedException', {
      'message': message.toString(),
      'stack': stack.toString(),
    });
  }
}
