import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddPage.dart';
// import 'Login.dart';
import 'UpdatePage.dart';
import 'GetSertifikat.dart';
import 'Home.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

    if (username == null || username.isEmpty) {
      // Redirect user to login page if username is empty or null
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GetSertifikat()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.green,
        color: Colors.green,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(Icons.add, size: 26, color: Colors.white),
          Icon(Icons.update, size: 26, color: Colors.white),
          Icon(Icons.person, size: 26, color: Colors.white), // Icon for Home
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: IndexedStack(
        index: _page,
        children: <Widget>[
          GetSertifikat(),
          AddPage(),
          UpdatePage(),
          Home(), // Home widget here
        ],
      ),
    );
  }
}
