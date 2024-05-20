import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '/message.dart';
import '/db/dbMap.dart';
import '/readJsonFile.dart';
import '/home.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String login = _loginController.text;
    final String password = _passwordController.text;

    // Проверка параметров авторизации (заменить на нужную логику)
    bool isAuthenticated = false;
    int userId = -1;
    int roleId = -1;
    int categoryId = -1;

    for (final key in users.keys) {
      final user = users[key];
      if (user != null &&
          user['login'] == login &&
          user['password'] == password) {
        isAuthenticated = true;
        userId = int.parse(key);
        roleId = int.parse(user['roleId'].toString());
        categoryId = int.parse(user['categoryId'].toString());
        break;
      }
    }

    if (isAuthenticated) {
      // Создание JSON файла при успешной авторизации
      final Map<String, dynamic> user = {
        'user_id': userId,
        'username': login,
        'password': password,
        'role_id': roleId, // Используем roleId из dbMap.dart
        'category_id': categoryId, // Используем categoryId из dbMap.dart
      };
      final String jsonString = jsonEncode(user);

      // Получение директории документов
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = directory.path + '/user_data.json';

      // Запись данных в файл
      final File file = File(path);
      await file.writeAsString(jsonString);

      // Переход на следующий экран (HomePage)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showAlertDialog(context, "Incorrect login or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _loginController,
            decoration: InputDecoration(
              labelText: 'Login',
            ),
          ),
          SizedBox(height: 12.0),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: _login,
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
