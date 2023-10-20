// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_boost/flutter_boost.dart';

void main(List<String> args) {

   Widget _defaultAppBuilder(Widget home) {
    return MaterialApp(home: home, builder: (_, __) => home);
  }
  runApp(MultiApp(args,routeFactory,appBuilder: _defaultAppBuilder));
  // RouteSettings settings = const RouteSettings(name: '/', arguments: null);
  // MultiAppNavigator.instance.routeFactory = routeFactory;
  //
  // if (args != null && args.isNotEmpty) {
  //   //取第一个string
  //   String jsonString = args[0];
  //   print('main args[0]:$jsonString');
  //   Map valueMap = json.decode(jsonString);
  //   String name = valueMap['pageName'];
  //   String uniqueId = valueMap['uniqueId'];
  //   if (name != null) {
  //     String argumentsStr =  valueMap['arguments'];
  //     Object arguments = json.decode(argumentsStr);
  //     print('main arguments:$arguments');
  //     settings = RouteSettings(name: name, arguments: arguments);
  //   }
  // }
  //
  // FlutterBoostRouteFactory safeRouteFactory = routeFactoryWrapper(routeFactory);
  // CupertinoPageRoute route =
  // safeRouteFactory(settings, null) as CupertinoPageRoute;
  //
  // runApp(MaterialApp(
  //   debugShowCheckedModeBanner: true,
  //
  //   ///必须加上builder参数，否则showDialog等会出问题
  //   builder: (BuildContext context, _) {
  //     return route.builder(context);
  //   },
  // ));
  //
  // setupContainerEvent();
}

void setupContainerEvent() {
  print("setupContainerEvent in state");

  // 容器显示
      {
    const String channelName = 'dev.flutter.MultiApp.onContainerShow';
    BasicMessageChannel<Object> channel =
    const BasicMessageChannel<Object>(channelName, StandardMessageCodec());
    if (channel != null) {
      channel.setMessageHandler((Object message) async {
        if (kDebugMode) {
          print("$channelName,Object:$message");
        }
        return;
      });
    } else {
      print('channel is null!!!');
    }
  }
  // 容器隐藏
      {
    const String channelName = 'dev.flutter.MultiApp.onContainerHide';
    BasicMessageChannel<Object> channel =
    const BasicMessageChannel<Object>(channelName, StandardMessageCodec());
    if (channel != null) {
      channel.setMessageHandler((Object message) async {
        if (kDebugMode) {
          print("$channelName,Object:$message");
        }
        return;
      });
    } else {
      print('channel is null!!!');
    }
  }

  // 应用回到前台
      {
    const String channelName = 'dev.flutter.MultiApp.onForeground';
    BasicMessageChannel<Object> channel =
    const BasicMessageChannel<Object>(channelName, StandardMessageCodec());
    if (channel != null) {
      channel.setMessageHandler((Object message) async {
        if (kDebugMode) {
          print("$channelName,Object:$message");
        }
        return;
      });
    } else {
      print('channel is null!!!');
    }
  }

  // 应用回到后台
      {
    const String channelName = 'dev.flutter.MultiApp.onBackground';
    BasicMessageChannel<Object> channel =
    const BasicMessageChannel<Object>(channelName, StandardMessageCodec());
    if (channel != null) {
      channel.setMessageHandler((Object message) async {
        if (kDebugMode) {
          print("$channelName,Object:$message");
        }
        return;
      });
    } else {
      print('channel is null!!!');
    }
  }

  // 点击返回键
      {
    const String channelName = 'dev.flutter.MultiApp.onBackPressed';
    BasicMessageChannel<Object> channel =
    const BasicMessageChannel<Object>(channelName, StandardMessageCodec());
    if (channel != null) {
      channel.setMessageHandler((Object message) async {
        if (kDebugMode) {
          print("$channelName,Object:$message");
        }
        return;
      });
    } else {
      print('channel is null!!!');
    }
  }



}

Map<String, FlutterBoostRouteFactory> routerMap = {
  '/': (RouteSettings settings, String uniqueId) {
    return CupertinoPageRoute(
        settings: settings,
        builder: (_) {
          Map<String, Object> map = settings.arguments as Map<String, Object>;
          String title = map['title'] as String;
          return MyHomePage(
            title: title,
          );
        });
  },
  'SimplePage': (settings, uniqueId) {
    return CupertinoPageRoute(
        settings: settings,
        builder: (_) {
          Map<String, Object> map = settings.arguments as Map<String, Object>;
          String title = map['title'] as String;
          return SimplePage(
            title: title,
          );
        });
  },
  'Main': (settings, uniqueId) {
    return CupertinoPageRoute(
        settings: settings,
        builder: (_) {
          Map<String, Object> map = settings.arguments as Map<String, Object>;
          String title = map['title'] as String;
          return MyHomePage(
            title: title,
          );
        });
  },
};

Route<dynamic> routeFactory(RouteSettings settings, String uniqueId) {
  if (kDebugMode) {
    print("routeFactory settings.name:" + settings.name);
    print("routeFactory settings.arguments:${settings.arguments}");
  }
  FlutterBoostRouteFactory func = routerMap[settings.name];
  if (func == null) {
    return null;
  }
  return func(settings, uniqueId);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.title),
              ElevatedButton(
                child: const Text("pop"),
                onPressed: () {
                  MultiAppNavigator.instance.pop();
                },
              ),
              ElevatedButton(
                child: const Text("push native"),
                onPressed: () {
                  MultiAppNavigator.instance.push(
                    "NewNative", //required
                    arguments: {'title': "New NewNative"}, //optional
                  );
                },
              ),
              ElevatedButton(
                child: const Text("push flutter"),
                onPressed: () {
                  MultiAppNavigator.instance.push(
                    "SimplePage", //required
                    arguments: {'title': "New NewNative"}, //optional
                  );
                },
              ),
              ElevatedButton(
                child: const Text("push flutte default"),
                onPressed: () {
                  MultiAppNavigator.instance.push(
                    "/", //required
                    arguments: {'title': "Main"}, //optional
                  );
                },
              ),
            ],
          )),
    );
  }
}

class SimplePage extends StatelessWidget {
  const SimplePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title),
              ElevatedButton(
                child: const Text("pop"),
                onPressed: () {
                  MultiAppNavigator.instance.pop();
                },
              ),
            ],
          )),
    );
  }
}
