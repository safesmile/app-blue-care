import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/app_routes.dart';

const onboardingCompletedKey = 'onboarding.completed';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initialRoute = AppRoutes.plan;
  try {
    final preferences = await SharedPreferences.getInstance();
    if (preferences.getBool(onboardingCompletedKey) ?? false) {
      initialRoute = AppRoutes.welcome;
    }
  } on Exception {
    // Keep the first-run flow available if preferences cannot be read.
  }

  runApp(
    BlueCareApp(
      initialRoute: initialRoute,
      onOnboardingCompleted: () async {
        final preferences = await SharedPreferences.getInstance();
        if (!await preferences.setBool(onboardingCompletedKey, true)) {
          throw StateError('Could not save onboarding progress.');
        }
      },
    ),
  );
}
