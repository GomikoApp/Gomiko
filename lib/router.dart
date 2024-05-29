import 'package:go_router/go_router.dart';

import 'views/auth/forgot_password_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';
import 'views/features/home/widgets/home_scaffold.dart';
import 'views/landing_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
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

  GoRouter get router => _router;
}
