import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Stream Validation',
      home: MyForm(),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailStreamController = StreamController<String>();
  final _passwordStreamController = StreamController<String>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailStreamController.close();
    _passwordStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream Validation Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter email',
              ),
              onChanged: (email) {
                _emailStreamController.add(email);
              },
            ),
            SizedBox(height: 16),
            StreamBuilder<String>(
              stream: _emailStreamController.stream.transform(_validateEmail),
              builder: (context, snapshot) {
                return Text(
                  snapshot.error as String? ?? '',
                  style: TextStyle(color: Colors.red),
                );
              },
            ),
            SizedBox(height: 32),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Enter password',
              ),
              obscureText: true,
              onChanged: (password) {
                _passwordStreamController.add(password);
              },
            ),
            SizedBox(height: 16),
            StreamBuilder<String>(
              stream: _passwordStreamController.stream.transform(_validatePassword),
              builder: (context, snapshot) {
                return Text(
                  snapshot.error as String? ?? '',
                  style: TextStyle(color: Colors.red),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  StreamTransformer<String, String> get _validateEmail =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (email, sink) {
          // Use a simple email regex for demonstration purposes
          if (RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(email)) {
            sink.add(email);
          } else {
            sink.addError('Enter a valid email address');
          }
        },
      );

  StreamTransformer<String, String> get _validatePassword =>
      StreamTransformer<String, String>.fromHandlers(
        handleData: (password, sink) {
          if (password.length >= 6) {
            sink.add(password);
          } else {
            sink.addError('Password must be at least 6 characters');
          }
        },
      );
}
