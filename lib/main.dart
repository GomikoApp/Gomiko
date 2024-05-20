import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
