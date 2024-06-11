import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'GeneratePdf.dart';
import 'Host.dart';
import 'Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

Host link = Host();
final hostApi = link.host;

class _UpdatePageState extends State<UpdatePage> {
  final String apiUrl = '$hostApi/update/';
  bool _isLoading = false;
  bool _isSubmitted = false;

  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlLocationController;
  File? _imageFile;
  Map<String, dynamic>? _responseData;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _urlLocationController = TextEditingController();
    checkLoginStatus();
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _urlLocationController.dispose();
    super.dispose();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJWT = prefs.getString('tokenJWT');

    if (tokenJWT == null || tokenJWT.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  Future<void> _sendData({
    required String id,
    required File imageFile,
    required String name,
    required String description,
    required String urlLocation,
  }) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl + id));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tokenJWT = prefs.getString('tokenJWT');
      request.headers['Authorization'] = 'Bearer $tokenJWT';

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
          _isSubmitted = true;
          _idController.text = '';
          _nameController.text = '';
          _descriptionController.text = '';
          _urlLocationController.text = '';
          _imageFile = null;
        });
        print('Data sent successfully!');
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
        title: Text('Ubah Sertifikat'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isSubmitted)
              Column(
                children: [
                  TextFormField(
                    controller: _idController,
                    decoration: InputDecoration(labelText: 'ID'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isSubmitted = true;
                      });
                    },
                    child: Text('Submit ID'),
                  ),
                ],
              ),
            if (_isSubmitted)
              Column(
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
                    label: Text(
                        _imageFile != null ? 'Image Selected' : 'Select Image'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            String id = _idController.text;
                            String name = _nameController.text;
                            String description = _descriptionController.text;
                            String urlLocation = _urlLocationController.text;

                            if (_imageFile != null) {
                              await _sendData(
                                id: id,
                                imageFile: _imageFile!,
                                name: name,
                                description: description,
                                urlLocation: urlLocation,
                              );
                            }
                          },
                    child: Text('Submit'),
                  ),
                  SizedBox(height: 16.0),
                  if (_isLoading) CircularProgressIndicator(),
                ],
              ),
            if (_responseData != null && !_isLoading)
              ElevatedButton(
                onPressed: () {
                  GeneratePdf(_responseData!);
                },
                child: Text('Cetak Sertifikat'),
              ),
            if (_isSubmitted)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isSubmitted = false;
                    _responseData = null;
                  });
                },
                child: Text('Reset'),
              ),
          ],
        ),
      ),
    );
  }
}
