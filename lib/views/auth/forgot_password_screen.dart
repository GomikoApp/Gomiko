import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';

// Widgets
import 'widgets/base_auth_screen.dart'; // Correctly imported
import 'widgets/logo.dart';
import 'widgets/login_signup_widgets.dart';
import 'widgets/custom_rich_text.dart';
import 'widgets/error_text.dart';

// Utilities
import '../../services/auth_services.dart';

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

  void _resetPassword() async {
    try {
      await AuthService().resetPassword(_emailFormField.controller!.text);
      if (context.mounted) {
        // Consider showing a success message before popping or navigating
        // For now, directly popping as per original logic.
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _buildForgotPasswordForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: Text(
                  "Enter the email address associated with your account and we'll send you a link to reset your password.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
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
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GomikoMainActionButton(
                  labelText: "Send",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _resetPassword();
                      if (kDebugMode) {
                        print("Password reset email sent to: ${_emailFormField.controller?.text}");
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),
              GomikoContextLinkRow(
                contextLabel: "Go back to",
                linkLabel: "Login",
                onTap: () {
                  context.pushReplacement('/login');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseAuthScreen(
      title: 'Forgot Password', // Added title as required by BaseAuthScreen
      backgroundImagePath: 'assets/backgrounds/Forgot-Password.png',
      logo: const GomikoLogo(),
      headerTextWidget: const CustomRichText(
        text: 'Forgot Password',
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      formContent: _buildForgotPasswordForm(),
    );
  }
}
