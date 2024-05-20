import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<dynamic> getFromJsonFile(String pole) async {
  try {
    // Получение директории документов
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path + '/user_data.json';

    // Чтение JSON файла
    final File file = File(path);
    final jsonString = await file.readAsString();

    // Декодирование JSON строки
    final Map<String, dynamic> userData = jsonDecode(jsonString);

    // Получение значения pole
    return userData['$pole'];
  } catch (e) {
    return null;
  }
}
