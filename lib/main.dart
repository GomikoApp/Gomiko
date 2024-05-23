import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

// utils
import 'utils/providers/login_state_provider.dart';

// Screens
import 'views/auth/login_screen.dart';
import 'views/auth/forgot_password_screen.dart';
import 'views/auth/signup_screen.dart';
import 'views/landing_screen.dart';

// Widgets
import 'views/features/home/widgets/home_scaffold.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Load environment variables
  await dotenv.load(fileName: '.env');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  // This function determines the initial route of the app
  // If the user is logged in, it will redirect to the home page
  // If the user has logged in before and has signed out, it will redirect to the login page
  // If the user is a first time user, it will redirect to the landing page
  String determineInitialRoute() {
    final appState = ref.watch(applicationStateProvider);
    if (appState.loggedIn) {
      return '/home';
    } else if (appState.wasLoggedIn) {
      return '/login';
    } else {
      return '/';
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final appState = ref.watch(applicationStateProvider);
    final initialLocation = determineInitialRoute();

    // Remove the splash screen if the app is done loading
    if (!appState.loading) {
      FlutterNativeSplash.remove();
    }

    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        // This is where the default page goes
        GoRoute(
            path: '/',
            builder: (context, state) {
              return const LandingPage();
            }),
        GoRoute(
            path: '/home',
            builder: (context, state) {
              return const HomeScaffold();
            }),
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
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Gomiko',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //       seedColor: Colors.blue, secondary: Colors.red),
      // ),
      // darkTheme: ThemeData.dark(),
      routerConfig: router,
    );
  }
}
