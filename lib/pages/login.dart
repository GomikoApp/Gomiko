import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recycle/widgets/login_signup_widgets.dart';

import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double formSizedBoxHeight = 20;

  // USER SIGN-IN SECTION VARIABLES AND METHODS SECTION
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? errorMessage = '';

  /// Try a sign-in with the current email and password in the text fields.
  Future<UserCredential?> signInWithEmailAndPassword() async {
    try {  
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text, 
        password: _passwordController.text
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Transform.translate(
          offset: const Offset(0, 250),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: windowWidth / 1.25,
            ),
            child: Column(
              // I want to add animations to these elements that is a simple fade
              // and transform up.
              children: [
                const TitleText(
                  text: "Log In"
                ),
                SizedBox(height: formSizedBoxHeight),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // I'm currently referencing: https://api.flutter.dev/flutter/widgets/Form-class.html
                      GomikoEmailTextFormField(
                        hintText: "Email",
                        controller: _emailController,
                        validator: (String? email) {
                          return LSUtilities.emailFormValidator(email: email);
                        },
                      ),
                      SizedBox(height: formSizedBoxHeight),
                      GomikoPasswordTextFormField(
                        hintText: "Password",
                        controller: _passwordController,
                        validator: (String? password) {
                          return LSUtilities.passwordFormValidator(password: password);
                        },
                      ),
                      SizedBox(height: formSizedBoxHeight),
                      ActionChip(
                        label: const Text("Create Account"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SignUpPage(),
                              )
                          );
                        },
                      ),
                      Text(errorMessage == '' ? '' : "$errorMessage"),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          child: const Text("Login"),
                          onPressed: () async {
                            // Validate will return true if the form is valid,
                            // or false if the form is invalid.
                            if (_formKey.currentState!.validate()) {
                              // try sign in, if successful, push to homepage
                              final UserCredential? signInResult = await signInWithEmailAndPassword();
                              if (signInResult != null) {
                                context.pushReplacement('/');
                              }
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
        ),
      )
    );
  }
}
