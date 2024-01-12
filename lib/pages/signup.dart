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

  String? errorMessage = '';

  Future<UserCredential?> createUserWithEmailAndPassword() async {
    try {
      return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text, 
        password: passwordField.currentPassword
      );
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    }
    
    return null;
  }

  Future<UserCredential?> signInAsAnonymousUser() async {
    try {
      return await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    }
    
    return null;
  }

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
                Text(errorMessage == '' ? '' : "$errorMessage"),
                const TitleText(
                  text: "Sign Up",
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      passwordField,
                      confirmPasswordField
                    ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GomikoMainActionButton(
                    labelText: "Sign Up",
                    onPressed: () async {
                      final UserCredential? result;
                      // Check if password and confirm password fields are matching
                      if (passwordField.currentPassword == confirmPasswordField.currentPassword) {
                        result = await createUserWithEmailAndPassword();

                        // User was created successfully
                        if (result != null) {
                          context.push('/login');
                        }
                      }
                    },
                  ),
                ),
                GomikoContextLinkRow(
                  contextLabel: "Already have an account?",
                  linkLabel: "Login",
                  onTap: () {
                    // Link to login page
                    context.pushReplacement('/login');
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
                  onTap: () async {
                    await signInAsAnonymousUser();
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