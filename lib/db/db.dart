import 'package:mysql1/mysql1.dart';

class Database {
  Future<dynamic> connectToDatabase() async {
    var settings = new ConnectionSettings(
      host: 'your_host',
      port: 3306,
      user: 'your_username',
      password: 'your_password',
      db: 'your_database',
    );

    var connection = await MySqlConnection.connect(settings);
  }
}
