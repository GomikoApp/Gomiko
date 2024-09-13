import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Services
import '../../services/auth_services.dart';

// Widgets
import 'widgets/login_signup_widgets.dart';
import 'widgets/logo.dart';
import 'widgets/social_media_auth.dart';
import 'widgets/custom_rich_text.dart';
import 'widgets/error_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double formSizedBoxHeight = 20;
  double textSizedBoxHeight = 50;

  String? errorMessage = '';

  // USER SIGN-IN SECTION VARIABLES AND METHODS SECTION
  final _emailFormField = GomikoEmailTextFormField(
    hintText: "Email",
    controller: TextEditingController(),
    validator: (String? email) {
      return LSUtilities.emailFormValidator(email: email);
    },
  );

  final _passwordFormField = GomikoPasswordTextFormField(
    hintText: "Password",
    controller: TextEditingController(),
    validator: (String? password) {
      return LSUtilities.passwordFormValidator(password: password);
    },
  );

  /// Try a sign-in with the current email and password in the text fields.
  void signInWithEmailAndPassword() async {
    try {
      await AuthService().signInWithEmailAndPassword(
          _emailFormField.currentEmail, _passwordFormField.currentPassword);
      if (mounted) context.pushReplacement('/home');
    } on FirebaseAuthException catch (e) {
      // The only error code that you can get is Invalid-Credentials because we have email enumeration protection turned on in firebase settings. To enable other error codes like user-not-found, you need to turn off email enumeration protection in firebase settings.
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  void signInWithGoogle() async {
    try {
      await AuthService().signInWithGoogle();
      if (mounted) context.pushReplacement('/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  void signInWithFacebook() async {
    try {
      await AuthService().signInWithFacebook();
      if (mounted) context.pushReplacement('/home');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _buildSocialMediaButtons() {
    return Column(
      children: <Widget>[
        SocialMediaAuth(
          onGoogleSignIn: () {
            signInWithGoogle();
            if (kDebugMode) print("Google Sign In");
          },
          onFacebookSignIn: () {
            signInWithFacebook();
            if (kDebugMode) print("Facebook Sign In");
          },
        ),
        SizedBox(height: formSizedBoxHeight),
      ],
    );
  }

  Widget _buildForm(
      double windowWidth, double windowHeight, bool keyboardOpen) {
    return Center(
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
                  ErrorText(
                    errorMessage: errorMessage,
                    // This callback is triggered when the close button of the error message is pressed.
                    // It clears the error message.
                    onClose: () {
                      setState(() {
                        errorMessage = '';
                      });
                    },
                  ),
                  // I'm currently referencing: https://api.flutter.dev/flutter/widgets/Form-class.html

                  // This is the form field for the email input.
                  _emailFormField,

                  const SizedBox(height: 8),

                  // This is the form field for the email input.
                  _passwordFormField,

                  // This method builds the "Forgot Password" button. When pressed, it pushes the user to the forgot password page.
                  Container(
                      alignment: AlignmentDirectional.centerEnd,
                      child: GomikoLink(
                        label: "Forgot Password? ",
                        labelSize: 14,
                        onTap: () {
                          if (context.mounted) {
                            context.push('/forgot-password');
                          }
                        },
                      )),

                  SizedBox(height: formSizedBoxHeight),

                  // This is the "Login" button. When pressed, it validates the form and attempts to sign in the user.
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GomikoMainActionButton(
                        labelText: "Login",
                        onPressed: () async {
                          // Validate will return true if the form is valid,
                          // or false if the form is invalid.
                          if (_formKey.currentState!.validate()) {
                            // try sign in, if successful, push to homepage
                            signInWithEmailAndPassword();
                          }
                        }),
                  ),

                  SizedBox(height: formSizedBoxHeight / 4),

                  // This builds the "Sign Up" button. When pressed, it pushes the user to the sign up page.
                  GomikoContextLinkRow(
                    contextLabel: "Don't have an account?",
                    linkLabel: "Sign Up",
                    onTap: () {
                      // prevents transparent background when pushing to sign up page
                      if (context.mounted) {
                        context.pushReplacement('/signup');
                      }
                    },
                  ),

                  // add spacing and push to bottom of screen
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: keyboardOpen ? 50 : windowHeight / 8),

                  windowHeight > 800
                      ? SizedBox(height: windowHeight * 0.1)
                      : Container(),

                  const GomikoTextDivider(
                    label: "Or Log in with",
                    labelSize: 13.5,
                  ),

                  _buildSocialMediaButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // check if keyboard is open, if so, move the text up
    // https://stackoverflow.com/questions/56902559/how-to-detect-keyboard-open-in-flutter
    bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;

    double windowWidth = MediaQuery.of(context).size.width;
    double windowHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/backgrounds/Login-Page.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedPadding(
          padding: EdgeInsets.only(top: keyboardOpen ? 0.0 : 20.0),
          duration: const Duration(milliseconds: 200),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                windowHeight > 800
                    ? SizedBox(height: windowHeight * 0.1)
                    : const SizedBox(height: 40),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: keyboardOpen ? 0.0 : 1.0,
                  // ignore: prefer_const_constructors
                  child: windowHeight > 800 ? GomikoLogo() : Container(),
                ),

                // Changes the textSizedBoxHeight variable to 15 is keyboard is open, otherwise it is the default value
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: keyboardOpen ? 0 : textSizedBoxHeight - 30,
                ),

                AnimatedPadding(
                  padding: EdgeInsets.only(top: keyboardOpen ? 0.0 : 15.0),
                  duration: const Duration(milliseconds: 200),
                  child: const CustomRichText(
                    text: 'Login',
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                // Changes the textSizedBoxHeight variable to 5 is keyboard is open, otherwise it is the default value
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: keyboardOpen ? 0 : textSizedBoxHeight - 30,
                ),

                _buildForm(windowWidth, windowHeight, keyboardOpen),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
