import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Utils
import 'utils/app_state.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/landing_screen.dart';

// Widgets
import 'widgets/home_scaffold.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late ApplicationState _appState;

  @override
  void initState() {
    super.initState();
    _appState = ApplicationState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _appState,
      child: MaterialApp.router(
        title: 'Gomiko',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue, secondary: Colors.red),
        ),
        darkTheme: ThemeData.dark(),
        routerConfig: _router,
      ),
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