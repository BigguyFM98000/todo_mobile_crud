import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<User> createUser(
    String firstname, String lastname, String email, String password) async {
  final response = await http.post(
    Uri.parse('http://102.33.81.19/auth/register'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: jsonEncode(<String, String>{
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    return User.fromjson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to register user');
  }
}

class User {
  final String firstname;
  final String lastname;
  final String email;
  final String password;

  const User(
      {required this.firstname,
      required this.lastname,
      required this.email,
      required this.password});

  factory User.fromjson(Map<String, dynamic> json) {
    return User(
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      password: json['password'],
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  Future<User>? _newUser;
  bool _showPassword = false;

  void handleSubmit() {}

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
              widthFactor: 4,
              heightFactor: 3,
              child: Text(
                'Register Your Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: _firstnameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter firstname',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: _lastnameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter lastname',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter email address',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                  setState(() {
                    _newUser = createUser(
                        _firstnameController.text,
                        _lastnameController.text,
                        _emailController.text,
                        _passwordController.text);
                    print(_newUser);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
                _firstnameController.text = '';
                _lastnameController.text = '';
                _emailController.text = '';
                _passwordController.text = '';
              },
              child: const Center(
                  child: Text('Register', textAlign: TextAlign.center)),
            ),
          ),
        ],
      ),
    );
  }
}
