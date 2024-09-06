import 'package:go_router/go_router.dart';

import '../views/auth/forgot_password_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/signup_screen.dart';
import '../views/features/widgets/home_scaffold.dart';
import '../views/landing_screen.dart';

class AppRouter {
  static const String landing = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';

  final GoRouter goRouter;
  AppRouter() : goRouter = _router;

  static GoRouter get _router => GoRouter(
        initialLocation: landing,
        routes: [
          GoRoute(
            path: landing,
            builder: (context, state) {
              return const LandingPage();
            },
          ),
          GoRoute(
            path: login,
            builder: (context, state) {
              return const LoginPage();
            },
          ),
          GoRoute(
            path: signup,
            builder: (context, state) {
              return const SignUpPage();
            },
          ),
          GoRoute(
            path: forgotPassword,
            builder: (context, state) {
              return const ForgotPasswordPage();
            },
          ),
          GoRoute(
            path: home,
            builder: (context, state) {
              return const HomeScaffold();
            },
          ),
        ],
      );
}
