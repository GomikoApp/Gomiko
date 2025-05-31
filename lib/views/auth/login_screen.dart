import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Services
import '../../services/auth_services.dart';

// Widgets
import 'widgets/base_auth_screen.dart'; // Added import
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

  // double formSizedBoxHeight = 20; // Kept as it's used in _buildSocialMediaButtons and potentially _buildForm
  // double textSizedBoxHeight = 50; // Removed as it was for animated spacing now handled by BaseAuthScreen

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
    // formSizedBoxHeight is still used here.
    double formSizedBoxHeight = 20;
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

  // Refactored _buildForm to remove window/keyboard parameters and outer layout widgets
  Widget _buildForm() {
    double formSizedBoxHeight = 20; // Localized or use a class member if it's broadly used
    return Column( // Removed Center and Container with constraints
      mainAxisSize: MainAxisSize.min, // Important for Column within SingleChildScrollView
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ErrorText(
                errorMessage: errorMessage,
                onClose: () {
                  setState(() {
                    errorMessage = '';
                  });
                },
              ),
              _emailFormField,
              const SizedBox(height: 8),
              _passwordFormField,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GomikoMainActionButton(
                    labelText: "Login",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        signInWithEmailAndPassword();
                      }
                    }),
              ),
              SizedBox(height: formSizedBoxHeight / 4),
              GomikoContextLinkRow(
                contextLabel: "Don't have an account?",
                linkLabel: "Sign Up",
                onTap: () {
                  if (context.mounted) {
                    context.pushReplacement('/signup');
                  }
                },
              ),
              // Removed AnimatedContainers for spacing - BaseAuthScreen handles major keyboard adjustments
              // Add some consistent spacing if needed
              const SizedBox(height: 20),
              const GomikoTextDivider(
                label: "Or Log in with",
                labelSize: 13.5,
              ),
              _buildSocialMediaButtons(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseAuthScreen(
      title: 'Login', // Added title as required by BaseAuthScreen
      backgroundImagePath: 'assets/backgrounds/Login-Page.png',
      logo: const GomikoLogo(),
      headerTextWidget: const CustomRichText(
        text: 'Login',
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.w700,
      ),
      formContent: _buildForm(),
    );
  }
}
