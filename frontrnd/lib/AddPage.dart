import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'GeneratePdf.dart';
import 'Host.dart';
import 'Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

Host link = Host();
final hostApi = link.host;

class _AddPageState extends State<AddPage> {
  final String apiUrl = '$hostApi/add';
  bool _isLoading = false;
  Map<String, dynamic>? _responseData;
  File? _imageFile;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlLocationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _urlLocationController = TextEditingController();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _urlLocationController.dispose();
    super.dispose();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJWT = prefs.getString('tokenJWT');

    if (tokenJWT == null || tokenJWT.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
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

  Future<void> _sendData({
    required File imageFile,
    required String name,
    required String description,
    required String urlLocation,
  }) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
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
      _processResponse(response);
    } catch (e) {
      setState(() {
        _responseData = {'error': e.toString()};
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  void _processResponse(http.Response response) {
    final jsonData = jsonDecode(response.body);

    setState(() {
      if (response.statusCode == 200) {
        _responseData = jsonData;
      } else {
        _responseData = {'error': jsonData};
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Sertifikat'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
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
                    _imageFile != null ? 'Gambar dipilih' : 'Pilih Gambar'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        String name = _nameController.text;
                        String description = _descriptionController.text;
                        String urlLocation = _urlLocationController.text;

                        if (_imageFile != null) {
                          await _sendData(
                            imageFile: _imageFile!,
                            name: name,
                            description: description,
                            urlLocation: urlLocation,
                          );
                        }
                      },
                child: Text('Kirim'),
              ),
              if (_isLoading) CircularProgressIndicator(),
              if (_responseData != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_responseData!.containsKey('message'))
                      ElevatedButton(
                        onPressed: () {
                          GeneratePdf(_responseData!['message']!);
                        },
                        child: Text('Cetak Sertifikat'),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
