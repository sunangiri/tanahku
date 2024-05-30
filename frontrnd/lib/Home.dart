import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'Login.dart'; // Ganti dengan file LoginPage yang sesuai
import 'login.dart'; // Pastikan ini menunjuk ke file LoginPage yang benar

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  // Method untuk memuat username dari SharedPreferences
  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
    });
  }

  // Method untuk logout
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs
        .remove('username'); // Hapus informasi login dari Shared Preferences
    await prefs
        .remove('tokenJWT'); // Hapus informasi login dari Shared Preferences

    // Pindah ke halaman Login setelah logout
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Login(), // Pastikan ini menunjuk ke widget Login yang benar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Welcome, $_username!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'ATR/BPN Indonesia.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _logout,
                icon: Icon(Icons.logout),
                label: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
