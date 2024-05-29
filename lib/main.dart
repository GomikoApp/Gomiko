import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';

// utils
import 'router.dart';
import 'utils/providers/login_state_provider.dart';

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
      routerDelegate: AppRouter().router.routerDelegate,
      routeInformationProvider: AppRouter().router.routeInformationProvider,
      routeInformationParser: AppRouter().router.routeInformationParser,
    );
  }
}
