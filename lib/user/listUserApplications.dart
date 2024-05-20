import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '/db/dbMap.dart';
import '/readJsonFile.dart';
import '/user/createApplication.dart';
import '/user/checkApplication.dart';

class UserApplicationsPage extends StatefulWidget {
  @override
  _UserApplicationsPageState createState() => _UserApplicationsPageState();
}

class _UserApplicationsPageState extends State<UserApplicationsPage> {
  late Future<List<Map<String, dynamic>>> _applicationsFuture;

  @override
  void initState() {
    super.initState();
    _applicationsFuture = _getApplicationsForUser();
  }

  Future<List<Map<String, dynamic>>> _getApplicationsForUser() async {
    final user_id = int.parse((await getFromJsonFile("user_id")).toString());
    final List<Map<String, dynamic>> userApplications = [];

    applications.forEach((String key, Map<String, dynamic> application) {
      if (int.parse(application["senderId"]) == user_id) {
        userApplications.add(application);
      }
    });

    return userApplications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заявки'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _applicationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки данных'));
          } else {
            final applications = snapshot.data ?? [];
            return _buildApplicationsList(applications);
          }
        },
      ),
    );
  }

  Widget _buildApplicationsList(List<Map<String, dynamic>> applications) {
    return ListView.builder(
      itemCount: applications.length,
      itemBuilder: (context, index) {
        final application = applications[index];
        return _ApplicationTile(application: application);
      },
    );
  }
}

class _ApplicationTile extends StatelessWidget {
  final Map<String, dynamic> application;

  const _ApplicationTile({required this.application});

  @override
  Widget build(BuildContext context) {
    final name = application['name'];
    final statuseId = int.parse(application['statuseId']);
    final statuse = (statuses[statuseId]).toString();

    return ListTile(
      title: Text(name),
      subtitle: Text(statuse),
      onTap: () {
        // if (statuse == 'Выполнено') {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => checkApplicationPage(),
        //     ),
        //   );
        // }
        // Обработка нажатия на заявку
      },
    );
  }
}
