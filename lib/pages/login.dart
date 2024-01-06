import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  RegExp emailRegex = RegExp(
      r'[a-zA-Z0-9.!#$%&’+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:.[a-zA-Z0-9-]+)(?:.[a-zA-Z0-9-]+)');
  double formSizedBoxHeight = 20;
  int passwordLengthMinimum = 5;
  int passwordLengthMaximum = 32;
  RegExp passwordRegex = RegExp(r"[a-zA-Z0-9.!#@$%&’+/=?^_`{|}~-]");
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppChangeNotifier>();

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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: "Enter your email",
                    ),
                    // Validate string
                    // TODO: validators need to be implemented later
                    validator: (String? email) {
                      if (email == null ||
                          email.isEmpty ||
                          !emailRegex.hasMatch(email)) {
                        return "Please enter a valid email.";
                      }

                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z0-9.!#@$%&’+/=?^_`{|}~-]"),
                        replacementString: '',
                      )
                    ],
                  ),
                  SizedBox(height: formSizedBoxHeight),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.key),
                      hintText: "Enter your password.",
                    ),
                    focusNode: passwordFocusNode,
                    // Validate string
                    validator: (String? password) {
                      if (password == null || password.isEmpty) {
                        return "Your password must not be empty.";
                      }

                      // NOTE: we use String.characters.length because complex characters will only count as one instead of
                      // the >1 value that String.length can give.
                      if (password.characters.length < passwordLengthMinimum ||
                          password.characters.length > passwordLengthMaximum) {
                        return "Your password must contain $passwordLengthMinimum-$passwordLengthMaximum characters.";
                        // Your password can only contain alphanumeric symbols and the and must be $passwordLengthMinimum-$passwordLengthMaximum characters long.
                      }

                      return null;
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(passwordLengthMaximum),
                      // Only allow alphanumeric characters and the symbols "!@#$%^&*+=".
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9!@#$%^&*+=]'),
                        replacementString: '',
                      ),
                    ],
                  ),
                  SizedBox(height: formSizedBoxHeight),
                  ActionChip(
                    label: const Text("Create Account"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SignUpPage(title: "Signup"),
                          ));
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
                          // TODO: Later to be used to integrate with Firebase
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
    ));
  }
}
