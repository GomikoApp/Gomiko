import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// utilities
import '../../services/auth_services.dart';

// widgets
import 'widgets/base_auth_screen.dart'; // Added import
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

  // double formSizedBoxHeight = 20; // Will be localized or removed if not needed
  // double textSizedBoxHeight = 50; // Removed, BaseAuthScreen handles this
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

  // Refactored _buildSignUpForm to remove windowWidth parameter and outer layout
  Widget _buildSignUpForm() {
    double formSizedBoxHeight = 20; // Local variable for internal spacing
    return Column( // Removed Center and Container
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formKey,
          child: Column(children: [
            ErrorText(
              errorMessage: errorMessage,
              onClose: () {
                setState(() {
                  errorMessage = '';
                });
              },
            ),
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
            context.pushReplacement('/login');
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseAuthScreen(
      title: 'Sign Up', // Added title
      backgroundImagePath: 'assets/backgrounds/Sign-Up-Page.png',
      logo: const GomikoLogo(), // Included logo
      headerTextWidget: const CustomRichText(
        text: 'Sign Up',
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      formContent: _buildSignUpForm(),
    );
  }
}
