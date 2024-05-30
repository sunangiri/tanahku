import 'dart:convert';
import 'GeneratePdf.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Host.dart';

class GetSertifikat extends StatefulWidget {
  @override
  _GetSertifikatState createState() => _GetSertifikatState();
}

Host link = Host();
final hostApi = link.host;

class _GetSertifikatState extends State<GetSertifikat> {
  final TextEditingController idController = TextEditingController();
  Map<String, dynamic> responseData = {};
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menambahkan Scaffold
      appBar: AppBar(
        // Menambahkan AppBar
        title: Text('Cari Sertifikat'), // Judul AppBar
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ID:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: idController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter ID',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              final id = idController.text;
              final apiUrl = '$hostApi/data/$id';

              try {
                final response = await http.get(Uri.parse(apiUrl));
                final jsonResponse = jsonDecode(response.body);

                if (jsonResponse['status']) {
                  setState(() {
                    responseData = jsonResponse['message'];
                    isLoading = false;
                  });
                } else {
                  setState(() {
                    responseData = {'error': 'Data not available'};
                    isLoading = false;
                  });
                }
              } catch (e) {
                setState(() {
                  responseData = {'error': 'Error: $e'};
                  isLoading = false;
                });
              }
            },
            child: Text('Send Request'),
          ),
          SizedBox(height: 16),
          if (isLoading)
            CircularProgressIndicator()
          else if (responseData.isNotEmpty && responseData['error'] == null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    GeneratePdf(responseData);
                  },
                  child: Text('Cetak Sertifikat'),
                ),
              ],
            )
          else if (responseData.isNotEmpty && responseData['error'] != null)
            Text(
              '${responseData['error']}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
