import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recycle/utils/app_state.dart';

// Provider for application state
final applicationStateProvider =
    ChangeNotifierProvider<ApplicationState>((ref) {
  return ApplicationState();
});
