import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recycle/utils/firebase_options.dart';

import 'router/routes.dart';
import 'utils/providers/login_state_provider.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Load environment variables
  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );
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
  final router = AppRouter();

  @override
  void initState() {
    super.initState();

    // Check if the user is logged in
    var auth = FirebaseAuth.instance; // Firebase Auth instance
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        // navigate to home page
        router.goRouter.go('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final appState = ref.watch(applicationStateProvider);
    if (!appState.loading) {
      FlutterNativeSplash.remove();
    }

    return MaterialApp.router(
      title: 'Gomiko',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          //colorScheme:
          //    ColorScheme.fromSeed(seedColor: Colors.blue, secondary: Colors.red),
          ),
      darkTheme: ThemeData.dark(),
      routerDelegate: router.goRouter.routerDelegate,
      routeInformationParser: router.goRouter.routeInformationParser,
      routeInformationProvider: router.goRouter.routeInformationProvider,
    );
  }
}
