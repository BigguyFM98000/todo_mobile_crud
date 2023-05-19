import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<User> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost:4500/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 201) {
    return User.fromjson(jsonDecode(response.body));
  } else {
    throw Exception('Login failed');
  }
}

class User {
  final String email;
  final String password;

  const User({required this.email, required this.password});

  factory User.fromjson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      password: json['password'],
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<User>? _registeredUser;
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
              widthFactor: 4,
              heightFactor: 3,
              child: Text(
                'Enter Your Login Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter email address',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              obscuringCharacter: '*',
              obscureText: _showPassword,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              onTap: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter password',
                suffixIcon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  _registeredUser = loginUser(
                      _emailController.text, _passwordController.text);
                  print(_registeredUser);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
                _emailController.text = '';
                _passwordController.text = '';
              },
              child: const Center(
                  child: Text('Submit', textAlign: TextAlign.center)),
            ),
          ),
        ],
      ),
    );
  }
}
