import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/main.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;
  
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppChangeNotifier>();

    double formSizedBoxHeight = 20;
    double windowWidth = MediaQuery.of(context).size.width;
    double windowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: windowWidth / 1.25,
            maxHeight: windowHeight / 2,
          ),
          child: Column(
            // I want to add animations to these elements that is a simple fade 
            // and transform up.
            children: [
              const Text(
                "Welcome to Gomiko",
                textScaler: TextScaler.linear(2.5),
              ),
              SizedBox(height: formSizedBoxHeight),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // I'm currently referencing: https://api.flutter.dev/flutter/widgets/Form-class.html
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        hintText: "Enter your email",
                      ),
                      // Validate string
                      // TODO: validators need to be implemented later
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: formSizedBoxHeight),
                    TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.key),
                        hintText: "Enter your password",
                      ),
                      // Validate string
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: formSizedBoxHeight),
                    ActionChip(
                      label: const Text("Create Account"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(title: "Signup"),
                          )
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        child: const Text("Login"),
                        onPressed: () {
                          // Validate will return true if the form is valid, 
                          // or false if the form is invalid.
                          if (_formKey.currentState!.validate()) {
                            // Later to be used to integrate with Firebase
                            Navigator.pop(context);
                            appState.testLogInToUser();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}