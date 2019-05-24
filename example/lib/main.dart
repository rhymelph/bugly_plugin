import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bugly_plugin/bugly_app.dart';

void main() => runCatchErrorApp(MyApp(),'你的AndroidAppId','你的IOSAppID');

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initSdk();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initSdk() async {

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
