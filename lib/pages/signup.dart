import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recycle/app_state.dart';
import 'package:recycle/widgets/login_signup_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<ApplicationState>();

    double windowWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Transform.translate(
          offset: const Offset(0, 200),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: windowWidth / 1.25,
            ),
            child: Column(
              children: [
                const TitleText(
                  text: "Sign Up",
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GomikoTextFormField(
                        hintText: "Name",
                        icon: const Icon(Icons.person_outline_outlined),
                        validator: (String? name) {
                          return null;
                        },
                      ),
                      GomikoEmailTextFormField(
                        hintText: "Email",
                        validator: (String? email) {
                          return LSUtilities.emailFormValidator(email: email);
                        },
                      ),
                      GomikoPasswordTextFormField(
                        hintText: "Password",
                        controller: _passwordController,
                      ),
                      GomikoPasswordTextFormField(
                        hintText: "Confirm Password",
                        controller: _confirmPasswordController,
                      )
                    ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GomikoMainActionButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    labelText: "Go Back"
                  ),
                ),
                GomikoContextLinkRow(
                  contextLabel: "Already have an account?",
                  linkLabel: "Login",
                  onTap: () {
                    // Link to login page
                    context.go('/login');
                  },
                ),
                const GomikoTextDivider(
                  label: "Or Sign up with",
                  labelSize: 13.5,
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Google Auth
                        print("Pressed G button!");
                      }, 
                      icon: const Icon(Icons.g_mobiledata)
                    )
                  ],
                ),
                GomikoLink(
                  label: "Continue without an account",
                  onTap: () {
                    appState.guestSignIn();
                    context.push('/');
                  },
                )
              ],
            ),
          ),
        )
      )
    );
  }
}