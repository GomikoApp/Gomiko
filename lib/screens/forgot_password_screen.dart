import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";

// Widgets
import '../widgets/custom_rich_text.dart';
import '../widgets/error_text.dart';
import '../widgets/login_signup_widgets.dart';
import '../widgets/logo.dart';

// Utilities
import '../services/auth_services.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? errorMessage = "";

  final _emailFormField = GomikoEmailTextFormField(
    hintText: "Email",
    controller: TextEditingController(),
    validator: (String? email) {
      return LSUtilities.emailFormValidator(email: email);
    },
  );

  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.of(context).size.width;

    // check if keyboard is open, if so, move the text up
    // https://stackoverflow.com/questions/56902559/how-to-detect-keyboard-open-in-flutter
    bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

    void resetPassword() async {
      try {
        await AuthService().resetPassword(_emailFormField.controller!.text);
        if (context.mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    }

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/backgrounds/Forgot-Password.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 40),

                  // Uncomment if we want the logo to be on the page
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: keyboardOpen ? 0.0 : 1.0,
                    // ignore: prefer_const_constructors
                    child: GomikoLogo(),
                  ),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: keyboardOpen ? 15 : 20,
                  ),

                  AnimatedPadding(
                    padding: EdgeInsets.only(top: keyboardOpen ? 0.0 : 15.0),
                    duration: const Duration(milliseconds: 200),
                    child: const CustomRichText(
                      text: 'Forgot Password',
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
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
                                const Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.0, left: 10.0),
                                  child: Text(
                                    "Enter the email address associated with your account and well send you a link to reset your password",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                ErrorText(
                                  errorMessage: errorMessage,
                                  onClose: () {
                                    setState(() {
                                      errorMessage = "";
                                    });
                                  },
                                ),
                                _emailFormField,
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: keyboardOpen ? 15 : 20,
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GomikoMainActionButton(
                                    labelText: "Send",
                                    onPressed: () async {
                                      // Validate will return true if the form is valid,
                                      // or false if the form is invalid.
                                      if (_formKey.currentState!.validate()) {
                                        // try sign in, if successful, push to homepage
                                        resetPassword();
                                        if (kDebugMode) {
                                          print(
                                              "Email: ${_emailFormField.controller?.text}");
                                        }
                                      }
                                    },
                                  ),
                                ),

                                const SizedBox(height: 20),
                                
                                // Go Back Text Button
                                RichText(
                                  text: TextSpan(
                                    text: "Go back to ",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      WidgetSpan(
                                        child: InkWell(
                                          onTap: () {
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text(
                                            "Login",
                                            style: TextStyle(
                                              color: Color(0xFF98CB51),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
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
      ],
    );
  }
}
