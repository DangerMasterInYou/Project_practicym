import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '/home.dart';
import '/authorization.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppStart(),
    );
  }
}

class AppStart extends StatefulWidget {
  @override
  _AppStartState createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/user_data.json');

    if (await file.exists()) {
      // Файл существует
      final String jsonData = await file.readAsString();
      final Map<String, dynamic> userData = jsonDecode(jsonData);

      // Проверка наличия данных пользователя
      if (userData["user_id"] != null) {
        // Пользователь успешно вошел в систему
        setState(() {
          _isLoggedIn = true;
        });
      }
    } else {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? HomePage() : LoginScreen();
  }
}
