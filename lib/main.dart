import 'dart:async';

import 'package:flutter/material.dart';
import 'package:virtual_agent/screens/home_screen.dart';
import 'package:virtual_agent/utill/local_storage.dart';
import 'screens/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.instance.initLocalStorage();
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Homepage(),
    );
  }
}
