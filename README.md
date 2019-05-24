# bugly_plugin

## Getting Started
添加包：
```yaml
dependencies:
  bugly_plugin:
    git: https://github.com/rhymelph/bugly_plugin.git
```

#### 1. Android使用说明：
> 添加权限
```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.READ_LOGS" />
```
> 适配Android P
`项目/android/app/src/main/res` 新建文件夹xml，在文件夹中添加`network_security_config.xml`文件，内容如下:
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">android.bugly.qq.com</domain>
    </domain-config>
</network-security-config>
```
`项目/android/app/src/main/AndroidManifest.xml`中给`Application`添加
```xml
<application 
...
android:networkSecurityConfig="@xml/network_security_config"
...
> 
</application>
```
#### 2. IOS使用说明：

#### 3. 开始使用:
> 初始化:
```dart
BuglyPlugin.initCrashReport('你的appid',false);
//第二个参数:你是否为发布模式
```

> 上报异常
```dart
BuglyPlugin.postCatchedException(message, stack);
//第一个参数：异常消息
//第二个参数：出错栈的位置
```

> 急速使用
```dart
import 'package:flutter/material.dart';
import 'package:bugly_plugin/bugly_app.dart';

void main() => runCatchErrorApp(MyApp(),'你的AndroidAppId','你的IOSAppID');
```

> 欢迎关注
> 我的博客：https://www.jianshu.com/u/0c89c7e04e7a
> 公众号：Dart客栈
> 欢迎加入
> QQ群：129380453
> 接活
> QQ：708959817(只接活，问问题请加Q群)