import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'Host.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

Host link = Host();
final hostApi = link.host;

class _AddPageState extends State<AddPage> {
  final apiUrl = '$hostApi/add';
  bool _isLoading = false;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlLocationController;
  File? _imageFile;
  Map<String, dynamic>? _responseData;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _urlLocationController = TextEditingController();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username == null || username.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _urlLocationController.dispose();
    super.dispose();
  }

  Future<void> _sendData({
    required File imageFile,
    required String name,
    required String description,
    required String urlLocation,
    required String tokenJWT,
  }) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers['Authorization'] =
          'Bearer $tokenJWT'; // Set Authorization header
      request.fields.addAll({
        'name': name,
        'description': description,
        'urlLocation': urlLocation,
      });

      var image = await http.MultipartFile.fromPath('file', imageFile.path);
      request.files.add(image);

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _responseData = jsonData['message'];
        });
        print('Data sent successfully!');
        print(response.body);
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<File?> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Sertifikat'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _urlLocationController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () async {
                final imageFile = await _getImage();
                if (imageFile != null) {
                  setState(() {
                    _imageFile = imageFile;
                  });
                }
              },
              icon: Icon(_imageFile != null ? Icons.check : Icons.image),
              label:
                  Text(_imageFile != null ? 'Image Selected' : 'Select Image'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      String name = _nameController.text;
                      String description = _descriptionController.text;
                      String urlLocation = _urlLocationController.text;
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? tokenJWT = prefs.getString('tokenJWT');
                      if (_imageFile != null && tokenJWT != null) {
                        await _sendData(
                          imageFile: _imageFile!,
                          name: name,
                          description: description,
                          urlLocation: urlLocation,
                          tokenJWT: tokenJWT,
                        );
                      }
                    },
              child: Text('Submit'),
            ),
            SizedBox(height: 16.0),
            if (_isLoading) CircularProgressIndicator(),
            if (_responseData != null && !_isLoading)
              ElevatedButton(
                onPressed: () {
                  // Do something
                },
                child: Text('Cetak Sertifikat'),
              ),
          ],
        ),
      ),
    );
  }
}
