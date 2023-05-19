import 'package:flutter/material.dart';
import 'package:todofluttersqlite/app_screens/todo_crud.dart';
import 'package:todofluttersqlite/app_screens/user_profile.dart';
import 'package:todofluttersqlite/auth_screens/login.dart';
import 'package:todofluttersqlite/auth_screens/register.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  CloudinaryContext.cloudinary = Cloudinary.fromCloudName(cloudName: "demo");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo CRUD App',
        theme: ThemeData.dark(),
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  int _currentIndex = 0;
  final tabs = [
    HomePage(),
    RegisterPage(),
    LoginPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoApp CMS'),
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.teal,
        // iconSize: 30,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration_rounded),
              label: 'Register',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.lock_open_rounded),
              label: 'Login',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.blue)
        ],
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
      ),
    );
  }
}
