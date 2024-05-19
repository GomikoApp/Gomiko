import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recycle/constants.dart';
import 'package:recycle/utils/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Utils
// import 'utils/app_state.dart';

// Screens
import 'views/auth/login_screen.dart';
import 'views/auth/forgot_password_screen.dart';
import 'views/auth/signup_screen.dart';
import 'views/landing_screen.dart';
import 'views/features/home/widgets/home_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

  // If local storage doesn't have a logged in key, initialize it to false.
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey(Constants.keyLoggedIn)) {
    prefs.setBool(Constants.keyLoggedIn, false);
  }

  runApp(
    const ProviderScope(
      child: MyApp()
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gomiko',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //       seedColor: Colors.blue, secondary: Colors.red),
      // ),
      // darkTheme: ThemeData.dark(),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  routes: [
    // This is where the default page goes
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScaffold(),
    ),
    GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginPage();
        }),
    GoRoute(
        path: '/signup',
        builder: (context, state) {
          return const SignUpPage();
        }),
    GoRoute(
        path: '/forgot-password',
        builder: (context, state) {
          return const ForgotPasswordPage();
        })
  ],
);
// end of GoRouter configuration
