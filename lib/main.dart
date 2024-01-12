import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recycle/pages/signup.dart';
import 'app_state.dart';

import '/pages/login.dart';
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
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      child: MaterialApp.router(
        title: 'Gomiko',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.blue, secondary: Colors.red),
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
      builder: (context, state) => const HomeScaffold(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) {
            return const LoginPage();
          }
        ),
        GoRoute(
          path: 'signup',
          builder: (context, state) {
            return const SignUpPage();
          }
        )
      ],
    ),
  ],
);
// end of GoRouter configuration