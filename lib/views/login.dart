import 'dart:convert';

import '/models/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var loginController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: loginController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Login',
                  hintText: 'Enter your login'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  var response = await http.post(
                      Uri.parse("http://10.0.2.2:5000/user/sign-in"),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, String>{
                        "login": loginController.text,
                        "password": passwordController.text
                      }));

                  if (response.statusCode == 200) {
                    var authModel = context.read<AuthModel>();
                    authModel.setToken(jsonDecode(response.body)["token"]);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Logged in!'),
                      backgroundColor: Colors.green,
                    ));
                  }

                  if (response.statusCode == 400) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Wrong password or login!'),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            width: 250,
            decoration: BoxDecoration(
                color: Colors.purple, borderRadius: BorderRadius.circular(20)),
            child: TextButton(
              onPressed: () async {
                var response = await http.post(
                    Uri.parse("http://10.0.2.2:5000/user/sign-up"),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      "login": loginController.text,
                      "password": passwordController.text
                    }));

                if (response.statusCode == 200) {
                  // var authModel = context.read<AuthModel>();
                  // authModel.setToken(jsonDecode(response.body)["token"]);
                  // Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Succesfully registered!'),
                    backgroundColor: Colors.green,
                  ));
                }

                if (response.statusCode == 400) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('User already exists!'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ),
        ]));
  }
}
