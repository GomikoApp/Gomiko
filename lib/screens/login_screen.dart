import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recycle/utils/app_state.dart';
import 'package:recycle/widgets/login_signup_widgets.dart';

// Widgets
import '../widgets/logo.dart';
import '../widgets/custom_rich_text.dart';
import '../widgets/error_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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
  Future<UserCredential?> signInWithEmailAndPassword() async {
    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailFormField.currentEmail,
          password: _passwordFormField.currentPassword);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }

    return null;
  }

  Widget _buildForgotPasswordButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            if (kDebugMode) print("Forgot Password");
          },
          child: RichText(
            text: const TextSpan(
              text: "Forgot Password? ",
              style: TextStyle(
                color: Color(0xff2364C6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: [
              WidgetSpan(
                child: InkWell(
                  onTap: () {
                    if (context.mounted) context.push('/signup');
                    if (kDebugMode) ("Sign Up");
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Color(0xff2364C6),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialMediaSignInButtons() {
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xffebf4dc),
      minimumSize: const Size(90, 50),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );

    return Column(
      children: <Widget>[
        const SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: const Divider(
                    color: Colors.black,
                    height: 36,
                  )),
            ),
            const Text("OR"),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                  child: const Divider(
                    color: Colors.black,
                    height: 36,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: style,
              child: const Image(
                image: AssetImage('assets/Google-Logo.png'),
                height: 30,
                width: 30,
              ),
              onPressed: () {
                if (kDebugMode) print("Google Sign In");
              },
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              style: style,
              child: const Image(
                image: AssetImage('assets/Facebook-Logo.png'),
                height: 30,
                width: 30,
              ),
              onPressed: () {
                if (kDebugMode) print("Facebook Sign In");
              },
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              style: style,
              child: const Image(
                image: AssetImage('assets/Apple-Logo.png'),
                height: 30,
                width: 30,
              ),
              onPressed: () {
                if (kDebugMode) print("Apple Sign In");
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForm(double windowWidth) {
    var appState = context.watch<ApplicationState>();

    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      foregroundColor: Colors.black,
      backgroundColor: const Color(0xFF98CB51),
      minimumSize: const Size(300, 60),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      shadowColor: Colors.black,
      elevation: 5,
    );

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
                  // TODO: Implement forgot password page.
                  _buildForgotPasswordButton(),

                  SizedBox(height: formSizedBoxHeight),

                  // This is the "Login" button. When pressed, it validates the form and attempts to sign in the user.
                  ElevatedButton(
                    style: style,
                    child: const Text("Login",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    onPressed: () async {
                      // Validate will return true if the form is valid,
                      // or false if the form is invalid.
                      if (_formKey.currentState!.validate()) {
                        // try sign in, if successful, push to homepage
                        final UserCredential? signInResult =
                            await signInWithEmailAndPassword();
                        if (signInResult != null) {
                          if (context.mounted) context.push('/');
                          if (kDebugMode) (appState.loggedIn);
                        }
                      }
                    },
                  ),

                  SizedBox(height: formSizedBoxHeight),

                  // This method builds the "Sign Up" button. When pressed, it pushes the user to the sign up page.
                  _buildSignupButton(),

                  // To Do: Implement Google Sign in/Facebook Sign in/Apple Sign in Design
                  _buildSocialMediaSignInButtons(),
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
    double windowWidth = MediaQuery.of(context).size.width;

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

                    // Uncomment if we want the logo to be on the page
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: keyboardOpen ? 0.0 : 1.0,
                      child: const GomikoLogo(),
                    ),

                    // Changes the textSizedBoxHeight variable to 15 is keyboard is open, otherwise it is the default value
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: keyboardOpen ? 15 : textSizedBoxHeight - 30,
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
                    _buildForm(windowWidth),
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
