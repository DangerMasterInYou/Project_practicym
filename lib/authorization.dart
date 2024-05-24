import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user/submit_application_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String token = ''; // Инициализируем значением по умолчанию

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final url = Uri.parse('http://dienis72.beget.tech/api/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      token = responseData['access_token']; // Сохраняем токен
      final userId = responseData['user_id']; // Получаем ID пользователя
      print(
          'User ID after login: $userId'); // Выводим ID пользователя в консоль
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubmitApplicationPage(
            token: token,
            userId: userId, // Передаем ID пользователя
            logout: _logout, // Передаем функцию logout
          ),
        ),
      );
    } else {
      final errorData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${errorData['error']}')),
      );
    }
  }

  void _logout() async {
    if (token.isEmpty) {
      // Если токен не определен, выходим
      return;
    }

    final url = Uri.parse('http://dienis72.beget.tech/api/logout');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    // Печатаем статус и тело ответа для диагностики
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['message'] == 'Successfully logged out') {
        // Успешный выход, перенаправляем пользователя на страницу входа
        token = ''; // Очистка токена при успешном выходе
        if (mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginPage()));
        }
      }
    } else {
      try {
        final errorData = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: ${errorData['message']}')),
          );
        }
      } catch (e) {
        print('Ошибка при выходе: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при выходе: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
        automaticallyImplyLeading: false, // Убираем стрелку "назад"
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Логин'),
                validator: (value) => value!.isEmpty ? 'Введите логин' : null,
                onSaved: (value) => username = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Пароль'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Введите пароль' : null,
                onSaved: (value) => password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
