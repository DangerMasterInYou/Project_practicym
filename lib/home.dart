// home.dart
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/authorization.dart';
import '/developer/listDeveloperApplications.dart';
import '/user/listUserApplications.dart';
import '/db/dbMap.dart';
import '/readJsonFile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DeveloperApplicationsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              child: ElevatedButton(
                onPressed: () async {
                  final Map<String, dynamic> user = {
                    'user_id': null,
                    'username': null,
                    'password': null,
                    'role_id': null, // Используем roleId из dbMap.dart
                    'category_id': null, // Используем categoryId из dbMap.dart
                  };
                  final String jsonString = jsonEncode(user);

                  // Получение директории документов
                  final Directory directory =
                      await getApplicationDocumentsDirectory();
                  final String path = directory.path + '/user_data.json';

                  // Запись данных в файл
                  final File file = File(path);
                  await file.writeAsString(jsonString);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Log Out'),
              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: () async {
                  Widget nextPage;
                  final role_id =
                      roles[(await getFromJsonFile("role_id")).toString()];

                  if (role_id == 'Developer') {
                    nextPage = DeveloperApplicationsPage();
                  } else if (role_id == 'User') {
                    nextPage = UserApplicationsPage();
                  } else {
                    nextPage = LoginScreen();
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => nextPage,
                    ),
                  );
                },
                child: Text('List'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
