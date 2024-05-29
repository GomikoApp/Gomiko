import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recycle/views/auth/forgot_password_screen.dart';
import 'package:recycle/views/auth/login_screen.dart';
import 'package:recycle/views/auth/signup_screen.dart';
import 'package:recycle/views/features/home/widgets/home_scaffold.dart';
import 'package:recycle/views/landing_screen.dart';

import 'utils/providers/login_state_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final appState = ref.watch(applicationStateProvider);

    // Remove the splash screen if the app is done loading
    if (!appState.loading) {
      FlutterNativeSplash.remove();
    }

    return MaterialApp.router(
      title: 'Gomiko',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(
      //       seedColor: Colors.blue, secondary: Colors.red),
      // ),
      // darkTheme: ThemeData.dark(),
      routerConfig: GoRouter(
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
      ),
    );
  }
}
