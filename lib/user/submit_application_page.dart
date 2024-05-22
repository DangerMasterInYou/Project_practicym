import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class SubmitApplicationPage extends StatefulWidget {
  @override
  _SubmitApplicationPageState createState() => _SubmitApplicationPageState();
}

class _SubmitApplicationPageState extends State<SubmitApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  String nazvanie = '';
  String korpus = '';
  int kabinet = 0;
  int otpravitel = 0; // в дальнейшем вводить не нужно будет и это будет id текущего пользователя
  String opisanie = '';
  String fileName = '';
  int kategoria = 0;
  File? file;

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      final url = Uri.parse('http://dienis72.beget.tech/api/submit-application');

      final request = http.MultipartRequest('POST', url)
        ..fields['nazvanie'] = nazvanie
        ..fields['korpys'] = korpus
        ..fields['kabinet'] = kabinet.toString()
        ..fields['otpravitel'] = otpravitel.toString()
        ..fields['opisanie'] = opisanie
        ..fields['kategoria'] = kategoria.toString();

      if (file != null) {
        final mimeType = lookupMimeType(file!.path)!;
        final mimeTypeData = mimeType.split('/');

        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file!.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // проверяем, что код состояния находится в диапазоне от 200 до 299
      if (response.statusCode >= 200 && response.statusCode < 300) {
        try {
          final responseData = jsonDecode(response.body);
          // проверяем, что сервер вернул ожидаемое сообщение об успешной отправке
          if (responseData['message'] == 'Application submitted successfully') {
            print('Application submitted successfully');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Заявка успешно отправлена')),
            );
            // сбрасываем все поля ввода
            _formKey.currentState!.reset();
            nazvanie = '';
            korpus = '';
            kabinet = 0;
            otpravitel = 0;
            opisanie = '';
            kategoria = 0;
            file = null;
            fileName = '';
          } else {
            print('Application submission failed: ${response.body}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Не удалось подать заявку: ${response.body}')),
            );
          }
        } catch (e) {
          print('Ошибка при обработке ответа сервера: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при отправке заявки: $e')),
          );
        }
      } else {
        print('API call failed: ${response.statusCode} ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при отправке заявки: ${response.statusCode} ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      print('Exception caught: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при отправке заявки: $e')),
      );
    }
  }

  Future<void> _pickFile() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
        fileName = pickedFile.path.split('/').last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отправка заявки'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Название'),
                  validator: (value) => value!.isEmpty ? 'Введите название' : null,
                  onSaved: (value) => nazvanie = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Корпус'),
                  validator: (value) => value!.isEmpty ? 'Введите корпус' : null,
                  onSaved: (value) => korpus = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Кабинет'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Введите кабинет' : null,
                  onSaved: (value) => kabinet = int.parse(value!),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Отправитель'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Введите отправителя' : null,
                  onSaved: (value) => otpravitel = int.parse(value!),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Описание'),
                  validator: (value) => value!.isEmpty ? 'Введите описание' : null,
                  onSaved: (value) => opisanie = value!,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Категория'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Введите категорию' : null,
                  onSaved: (value) => kategoria = int.parse(value!),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickFile,
                  child: Text('Прикрепить файл'),
                ),
                SizedBox(height: 8),
                file != null ? Text('Файл выбран: $fileName') : Text('Файл не выбран'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitApplication,
                  child: Text('Отправить заявку'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

