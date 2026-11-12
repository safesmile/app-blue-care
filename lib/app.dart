import 'package:flutter/material.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';
import 'features/auth/data/preview_auth_repository.dart';
import 'features/auth/domain/auth_repository.dart';
import 'core/presentation/not_found_screen.dart';
import 'features/auth/presentation/activated_screen.dart';
import 'features/auth/presentation/check_email_screen.dart';
import 'features/auth/presentation/expired_invitation_screen.dart';
import 'features/auth/presentation/forgot_password_screen.dart';
import 'features/auth/presentation/invitation_request_screen.dart';
import 'features/auth/presentation/invitation_screen.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/password_screen.dart';
import 'features/auth/presentation/password_updated_screen.dart';
import 'features/auth/presentation/verification_screen.dart';
import 'features/explore/presentation/explore_screen.dart';
import 'features/onboarding/presentation/notifications_screen.dart';
import 'features/onboarding/presentation/onboarding_screen.dart';
import 'features/welcome/presentation/welcome_screen.dart';

class BlueCareApp extends StatelessWidget {
  const BlueCareApp({
    super.key,
    this.repository,
    this.themeMode = ThemeMode.system,
    this.initialRoute = AppRoutes.welcome,
    this.initialArguments,
  });
  final AuthRepository? repository;
  final ThemeMode themeMode;
  final String initialRoute;
  final Object? initialArguments;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Blue Care',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: themeMode,
    initialRoute: initialRoute,
    onGenerateInitialRoutes: (name) => [
      buildRoute(RouteSettings(name: name, arguments: initialArguments)),
    ],
    onGenerateRoute: buildRoute,
  );

  Route<void> buildRoute(RouteSettings settings) {
    final uri = Uri.tryParse(settings.name ?? '') ?? Uri(path: '/');
    final repo = repository ?? const PreviewAuthRepository();
    final arguments = settings.arguments;
    final token = uri.queryParameters['token'];
    final Widget screen = switch (uri.path) {
      AppRoutes.welcome => const WelcomeScreen(),
      AppRoutes.login => LoginScreen(repository: repo),
      AppRoutes.invitationRequest => InvitationRequestScreen(repository: repo),
      AppRoutes.invitation => InvitationScreen(repository: repo, token: token),
      AppRoutes.verify =>
        arguments is InvitationVerification
            ? VerificationScreen(repository: repo, verification: arguments)
            : ExpiredInvitationScreen(repository: repo),
      AppRoutes.createPassword =>
        arguments is VerifiedInvitation
            ? PasswordScreen.create(repository: repo, verification: arguments)
            : ExpiredInvitationScreen(repository: repo),
      AppRoutes.activated => const ActivatedScreen(),
      AppRoutes.expired => ExpiredInvitationScreen(repository: repo),
      AppRoutes.forgotPassword => ForgotPasswordScreen(repository: repo),
      AppRoutes.checkEmail => const CheckEmailScreen(),
      AppRoutes.resetPassword => PasswordScreen.reset(
        repository: repo,
        token: token,
      ),
      AppRoutes.passwordUpdated => const PasswordUpdatedScreen(),
      AppRoutes.plan => const OnboardingScreen(step: OnboardingStep.plan),
      AppRoutes.prevention => const OnboardingScreen(
        step: OnboardingStep.prevention,
      ),
      AppRoutes.benefits => const OnboardingScreen(
        step: OnboardingStep.benefits,
      ),
      AppRoutes.notifications => const NotificationsScreen(),
      AppRoutes.homePreview => const ExploreScreen(exploring: false),
      AppRoutes.explore => const ExploreScreen(),
      _ => const NotFoundScreen(),
    };
    return MaterialPageRoute<void>(settings: settings, builder: (_) => screen);
  }
}
