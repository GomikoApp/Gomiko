import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// utilities
import '../../services/auth_services.dart';

// widgets
import 'widgets/login_signup_widgets.dart';
import 'widgets/custom_rich_text.dart';
import 'widgets/logo.dart';
import 'widgets/error_text.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double formSizedBoxHeight = 20;
  double textSizedBoxHeight = 50;

  String? errorMessage = '';

  // FIELDS
  final _emailController = TextEditingController();
  final passwordField = GomikoPasswordTextFormField(
    hintText: "Password",
    controller: TextEditingController(),
  );

  final confirmPasswordField = GomikoPasswordTextFormField(
    hintText: "Confirm Password",
    controller: TextEditingController(),
  );

  // // Create User With Email and Password
  void createUserWithEmailAndPassword() async {
    try {
      await AuthService().createUserWithEmailAndPassword(
          _emailController.text, passwordField.currentPassword);
      if (mounted) context.pushReplacement('/home');
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  Widget _buildSignUpForm(double windowWidth) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: windowWidth / 1.25),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(children: [
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
                // GomikoTextFormField(
                //   hintText: "Name",
                //   icon: const Icon(Icons.person_outline_outlined),
                //   validator: (String? name) {
                //     return null;
                //   },
                // ),
                GomikoEmailTextFormField(
                  hintText: "Email",
                  controller: _emailController,
                  validator: (String? email) {
                    return LSUtilities.emailFormValidator(email: email);
                  },
                ),
                const SizedBox(height: 8),
                passwordField,
                const SizedBox(height: 8),
                confirmPasswordField
              ]),
            ),
            SizedBox(height: formSizedBoxHeight),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GomikoMainActionButton(
                labelText: "Sign Up",
                onPressed: () async {
                  // Check if password and confirm password fields are matching
                  if (passwordField.currentPassword !=
                      confirmPasswordField.currentPassword) {
                    setState(() {
                      errorMessage = "Passwords do not match";
                    });
                    return;
                  }

                  if (_formKey.currentState!.validate()) {
                    createUserWithEmailAndPassword();
                  }
                },
              ),
            ),
            SizedBox(height: formSizedBoxHeight / 4),
            GomikoContextLinkRow(
              contextLabel: "Already have an account?",
              linkLabel: "Login",
              onTap: () {
                // Link to login page
                context.pushReplacement('/login');
              },
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
          image: AssetImage("assets/backgrounds/Sign-Up-Page.png"),
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
                windowHeight > 800
                    ? SizedBox(height: windowHeight * 0.1)
                    : const SizedBox(height: 40),

                // Uncomment if we want the logo to be on the page
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: keyboardOpen ? 0.0 : 1.0,
                  // ignore: prefer_const_constructors
                  child: windowHeight > 800 ? GomikoLogo() : Container(),
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
                    text: 'Sign Up',
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

                _buildSignUpForm(windowWidth)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
