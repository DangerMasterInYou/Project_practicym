// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import '/db/dbMap.dart';

// class CreateApplicationPage extends StatefulWidget {
//   @override
//   _CreateApplicationPageState createState() => _CreateApplicationPageState();
// }

// class _CreateApplicationPageState extends State<CreateApplicationPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();

//   int _selectedCorpusId = 0;
//   int _selectedCategoryId = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create Application'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextFormField(
//               controller: _nameController,
//               decoration: InputDecoration(
//                 labelText: 'Name',
//               ),
//             ),
//             SizedBox(height: 12.0),
//             DropdownButtonFormField<int>(
//               value: _selectedCorpusId,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCorpusId = value ?? 0;
//                 });
//               },
//               items: corpuses.entries
//                   .map((entry) => DropdownMenuItem<int>(
//                         value: entry.key,
//                         child: Text(entry.value),
//                       ))
//                   .toList(),
//               decoration: InputDecoration(
//                 labelText: 'Corpus',
//               ),
//             ),
//             SizedBox(height: 12.0),
//             DropdownButtonFormField<int>(
//               value: _selectedCategoryId,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedCategoryId = value ?? 0;
//                 });
//               },
//               items: categories.entries
//                   .map((entry) => DropdownMenuItem<int>(
//                         value: entry.key,
//                         child: Text(entry.value),
//                       ))
//                   .toList(),
//               decoration: InputDecoration(
//                 labelText: 'Category',
//               ),
//             ),
//             SizedBox(height: 12.0),
//             TextFormField(
//               controller: _descriptionController,
//               decoration: InputDecoration(
//                 labelText: 'Description',
//               ),
//             ),
//             SizedBox(height: 24.0),
//             ElevatedButton(
//               onPressed: _createApplication,
//               child: Text('Create Application'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _createApplication() async {
//     final String name = _nameController.text.trim();
//     final String description = _descriptionController.text.trim();

//     if (name.isEmpty || description.isEmpty) {
//       _showAlertDialog('Name and Description are required.');
//       return;
//     }

//     // Generate a unique key for the new application
//     int newApplicationKey = applications.keys.isEmpty
//         ? 0
//         : applications.keys.reduce((key1, key2) => key1 > key2 ? key1 : key2) +
//             1;

//     // Create a new application
//     final newApplication = {
//       'name': name,
//       'senderId': 0, // Assuming senderId is the current user's id
//       'corpusId': _selectedCorpusId,
//       'cabinet': 0, // Assuming cabinet is not required for now
//       'categoryId': _selectedCategoryId,
//       'description': description,
//       'pathToPhoto': "", // Assuming photo is not required for now
//       'statuseId': 0, // Assuming statusId is not required for now
//       'developerId': null, // Assuming developerId is not required for now
//     };

//     // Add the new application to the applications map
//     applications[newApplicationKey] = newApplication;

//     // Save the updated applications map to a JSON file
//     final String jsonString =
//         JsonEncoder.withIndent('  ').convert(applications);
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String path = directory.path + '/applications.json';
//     final File file = File(path);
//     await file.writeAsString(jsonString);

//     // Show success message
//     _showAlertDialog('Application created successfully.');
//   }

//   void _showAlertDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Message'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }
