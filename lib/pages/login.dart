import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:recycle/app_state.dart';
import 'package:recycle/widgets/login_signup_widgets.dart';

import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // USER SIGN-IN SECTION VARIABLES AND METHODS SECTION
  final _emailController = TextEditingController();
  final passwordFormField = GomikoPasswordTextFormField(
    hintText: "Password",
    controller: TextEditingController(),
    validator: (String? password) {
      return LSUtilities.passwordFormValidator(password: password);
    },
  );

  double formSizedBoxHeight = 20;
  double textSizedBoxHeight = 50;

  String? errorMessage = '';

  /// Try a sign-in with the current email and password in the text fields.
  Future<UserCredential?> signInWithEmailAndPassword() async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: passwordFormField.currentPassword);
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
    var appState = context.watch<ApplicationState>();

    // check if keyboard is open, if so, move the text up
    // https://stackoverflow.com/questions/56902559/how-to-detect-keyboard-open-in-flutter
    bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Login-Page.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: AnimatedPadding(
                padding: EdgeInsets.only(top: keyboardOpen ? 0.0 : 20.0),
                duration: const Duration(milliseconds: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 54),
                      child: RichText(
                        text: const TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: 'GOMI',
                              style: TextStyle(
                                color: Color(0xffD7E9B9),
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: 'KO',
                              style: TextStyle(
                                color: Color(0xff95CA4A),
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: keyboardOpen ? 15 : textSizedBoxHeight,
                    ),
                    AnimatedPadding(
                      padding: EdgeInsets.only(top: keyboardOpen ? 0.0 : 25.0),
                      duration: const Duration(milliseconds: 200),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 59),
                        child: RichText(
                          text: const TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: keyboardOpen ? 25 : textSizedBoxHeight,
                    ),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: windowWidth / 1.25,
                        ),
                        child: Column(
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  // I'm currently referencing: https://api.flutter.dev/flutter/widgets/Form-class.html
                                  GomikoEmailTextFormField(
                                    hintText: "Email",
                                    controller: _emailController,
                                    validator: (String? email) {
                                      return LSUtilities.emailFormValidator(
                                          email: email);
                                    },
                                  ),
                                  SizedBox(height: formSizedBoxHeight),
                                  passwordFormField,
                                  ActionChip(
                                    label: const Text("Create Account"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpPage(),
                                          ));
                                    },
                                  ),
                                  Text(errorMessage == ''
                                      ? ''
                                      : "$errorMessage"),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: ElevatedButton(
                                      child: const Text("Login"),
                                      onPressed: () async {
                                        // Validate will return true if the form is valid,
                                        // or false if the form is invalid.
                                        if (_formKey.currentState!.validate()) {
                                          // try sign in, if successful, push to homepage
                                          final UserCredential? signInResult =
                                              await signInWithEmailAndPassword();
                                          if (signInResult != null) {
                                            context.pushReplacement('/');
                                            print(appState.loggedIn);
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
