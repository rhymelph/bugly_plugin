package com.rhyme.bugly_plugin;

import android.app.Activity;
import android.text.TextUtils;

import com.tencent.bugly.crashreport.CrashReport;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/** BuglyPlugin */
public class BuglyPlugin implements MethodChannel.MethodCallHandler {
  private Activity activity;

  private BuglyPlugin(Activity activity) {
    this.activity = activity;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(PluginRegistry.Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "bugly_plugin");
    channel.setMethodCallHandler(new BuglyPlugin(registrar.activity()));
  }

  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result result) {
    if (call.method.equals("initCrashReport")) {
      initCrashReport(call, result);
    } else if(call.method.equals("postCatchedException")){
      postCatchedException(call, result);
    }else {
      result.notImplemented();
    }
  }

  //初始化sdk
  private void initCrashReport(MethodCall call, MethodChannel.Result result) {
    String appId = call.argument("appId");
    Boolean isDebug = call.argument("isDebug");
    CrashReport.initCrashReport(activity.getApplicationContext(), appId, isDebug == null ? false : isDebug);
    result.success(null);
  }

  //上报异常
  private void postCatchedException(MethodCall call, MethodChannel.Result result) {
    String message=call.argument("message");
    String stack=call.argument("stack");
    CrashReport.postCatchedException(formatFlutterExcetion(message,stack));
    result.success(null);
  }


  //格式化异常信息
  private Throwable formatFlutterExcetion(String message, String stack) {
    String[] details = stack.split("#");
    List<StackTraceElement> elements = new ArrayList<>();
    for (String s : details) {
      if (!TextUtils.isEmpty(s)) {
        String methodName = null;
        String fileName = null;
        int lineNum = -1;
        String[] contents = s.split(" \\(");
        if (contents.length > 0) {
          methodName = contents[0];
          if (contents.length < 2) {
            break;
          }
          String packageContent = contents[1].replace(")", "");
          String[] packageContentArray = packageContent.split("\\.dart:");
          if (packageContentArray.length > 0) {
            if (packageContentArray.length == 1) {
              fileName = packageContentArray[0];
            } else {
              fileName = packageContentArray[0] + ".dart";
              Pattern patternTrace = Pattern.compile("[1-9]\\d*");
              Matcher m = patternTrace.matcher(packageContentArray[1]);
              if (m.find()) {
                String lineNumStr = m.group();
                lineNum = Integer.parseInt(lineNumStr);
              }
            }
          }
        }
        StackTraceElement element = new StackTraceElement("Dart", methodName, fileName, lineNum);
        elements.add(element);
      }
    }
    Throwable throwable = new Throwable(message);
    if (elements.size() > 0) {
      StackTraceElement[] elementsArray = new StackTraceElement[elements.size()];
      throwable.setStackTrace(elements.toArray(elementsArray));
    }
    return throwable;
  }
}
