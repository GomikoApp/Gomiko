import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recycle/widgets/login_signup_widgets.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/backgrounds/Landing-Page.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: RichText(
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'GOMI',
                        style: TextStyle(
                          color: Color(0xffD7E9B9),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'KO',
                        style: TextStyle(
                          color: Color(0xff95CA4A),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 70),
              const Image(
                image: AssetImage('assets/Landing_Page_Box.png'),
                width: 300,
                height: 150,
              ),
              const SizedBox(height: 70),
              GomikoMainActionButton(
                labelText: "Get Started",
                onPressed: () {
                  context.pushReplacement('/signup');
                },
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    WidgetSpan(
                      child: InkWell(
                        onTap: () {
                          context.pushReplacement('/login');
                          if (kDebugMode) ("Login");
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
