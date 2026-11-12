import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_blue_care/core/app_routes.dart';
import 'package:app_blue_care/features/auth/domain/auth_repository.dart';
import 'package:app_blue_care/features/auth/presentation/verification_screen.dart';
import 'package:app_blue_care/features/auth/presentation/password_screen.dart';
import 'support/controlled_auth_repository.dart';
import 'support/widget_helpers.dart';

Future<void> fillLogin(WidgetTester tester) async {
  await tester.enterText(
    find.byType(TextFormField).at(0),
    'member@example.com',
  );
  await tester.enterText(find.byType(TextFormField).at(1), 'password');
}

Future<void> fillPassword(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).at(0), 'BlueCare2026!');
  await tester.enterText(find.byType(TextFormField).at(1), 'BlueCare2026!');
}

void main() {
  testWidgets('failed invitation retains its token for retry', (tester) async {
    final repo = ControlledAuthRepository()
      ..onAccept = () async {
        throw const AuthFailure('Invitación no disponible.');
      };
    await open(
      tester,
      '${AppRoutes.invitation}?token=original',
      repository: repo,
    );
    await tapText(tester, 'Aceptar invitación');
    expect(find.text('Invitación no disponible.'), findsOneWidget);
    expect(find.byType(VerificationScreen), findsNothing);
    repo.onAccept = null;
    await tapText(tester, 'Aceptar invitación');
    expect(repo.invitationToken, 'original');
    expect(find.byType(VerificationScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('login failure stays on the form and a retry succeeds', (
    tester,
  ) async {
    final repo = ControlledAuthRepository()
      ..onSignIn = () async {
        throw const AuthFailure('Credenciales incorrectas.');
      };
    await open(tester, AppRoutes.login, repository: repo);
    await fillLogin(tester);
    await tapText(tester, 'Iniciar sesión');
    expect(find.text('Credenciales incorrectas.'), findsOneWidget);
    expect(find.text('Qué bueno verte.'), findsOneWidget);
    repo.onSignIn = null;
    await tapText(tester, 'Iniciar sesión');
    expect(repo.signInCalls, 2);
    expect(repo.receivedEmail, 'member@example.com');
    expect(find.text('Bienvenido a Blue Care.'), findsOneWidget);
  });

  testWidgets('pending login disables submissions and competing navigation', (
    tester,
  ) async {
    final pending = Completer<void>();
    final repo = ControlledAuthRepository()..onSignIn = () => pending.future;
    await open(tester, AppRoutes.login, repository: repo);
    await fillLogin(tester);
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    // Invoke the competing callback as well as checking pointer blocking. The
    // operation must reject duplicates even before the next frame rebuilds.
    final google = tester.widget<OutlinedButton>(find.byType(OutlinedButton));
    google.onPressed!();
    expect(repo.signInCalls, 1);
    expect(repo.googleCalls, 0);
    pending.complete();
    await tester.pumpAndSettle();
    expect(find.text('Bienvenido a Blue Care.'), findsOneWidget);
  });

  for (final fail in [false, true]) {
    testWidgets('leaving a pending login ignores completion (failure: $fail)', (
      tester,
    ) async {
      final pending = Completer<void>();
      final repo = ControlledAuthRepository()..onSignIn = () => pending.future;
      await open(tester, AppRoutes.welcome, repository: repo);
      await tapText(tester, 'Iniciar sesión');
      await fillLogin(tester);
      await tester.tap(find.text('Iniciar sesión'));
      await tester.pump();
      Navigator.of(tester.element(find.byType(TextFormField).first)).pop();
      await tester.pumpAndSettle();
      if (fail) {
        pending.completeError(const AuthFailure('Too late'));
      } else {
        pending.complete();
      }
      await tester.pumpAndSettle();
      expect(find.text('Todo tu cuidado,\nen un solo lugar.'), findsOneWidget);
      expect(find.text('Bienvenido a Blue Care.'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('invitation context reaches OTP, resend and activation', (
    tester,
  ) async {
    final repo = ControlledAuthRepository();
    await open(
      tester,
      '${AppRoutes.invitation}?token=invite%2B123',
      repository: repo,
    );
    await tapText(tester, 'Aceptar invitación');
    expect(repo.invitationToken, 'invite+123');
    expect(
      tester
          .widget<VerificationScreen>(find.byType(VerificationScreen))
          .verification,
      same(repo.challenge),
    );
    await tester.pump(const Duration(seconds: 31));
    await tapText(tester, 'Reenviar código');
    expect(repo.resendVerificationReceived, same(repo.challenge));
    await tester.enterText(find.byType(TextFormField).first, '123456');
    await tapText(tester, 'Verificar correo');
    expect(repo.receivedCode, '123456');
    expect(repo.verificationReceived, same(repo.challenge));
    expect(
      tester.widget<PasswordScreen>(find.byType(PasswordScreen)).verification,
      same(repo.proof),
    );
    await fillPassword(tester);
    await tester.tap(find.byType(Checkbox));
    await tapText(tester, 'Activar mi cuenta');
    expect(repo.activationVerificationReceived, same(repo.proof));
    expect(find.text('Ya eres parte.'), findsOneWidget);
    expect(find.byType(VerificationScreen), findsNothing);
  });

  testWidgets(
    'resend failure allows immediate retry; cooldown starts on success only',
    (tester) async {
      final pending = Completer<void>();
      final repo = ControlledAuthRepository()..onResend = () => pending.future;
      await open(
        tester,
        AppRoutes.verify,
        repository: repo,
        arguments: repo.challenge,
      );
      expect(find.text('Reenviar código en 00:30'), findsOneWidget);
      await tester.pump(const Duration(seconds: 31));
      await tester.ensureVisible(find.text('Reenviar código'));
      await tester.tap(find.text('Reenviar código'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));
      expect(repo.resendCalls, 1);
      expect(find.textContaining('Reenviar código en'), findsNothing);
      pending.completeError(const AuthFailure('No se pudo reenviar.'));
      await tester.pumpAndSettle();
      expect(find.text('No se pudo reenviar.'), findsOneWidget);
      expect(find.textContaining('Reenviar código en'), findsNothing);
      expect(find.text('Vista previa: código solicitado.'), findsNothing);
      repo.onResend = null;
      await tapText(tester, 'Reenviar código');
      expect(repo.resendCalls, 2);
      expect(find.textContaining('Reenviar código en'), findsOneWidget);
      expect(find.text('No se pudo reenviar.'), findsNothing);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 31));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'invalid OTP, verification error and activation error permit correction',
    (tester) async {
      final repo = ControlledAuthRepository()
        ..onVerify = () async {
          throw const AuthFailure('Código incorrecto.');
        };
      await open(
        tester,
        AppRoutes.verify,
        repository: repo,
        arguments: repo.challenge,
      );
      await tapText(tester, 'Verificar correo');
      expect(repo.verifyCalls, 0);
      expect(find.text('Ingresa los 6 dígitos del código.'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).first, '123456');
      await tapText(tester, 'Verificar correo');
      expect(find.text('Código incorrecto.'), findsOneWidget);
      repo.onVerify = null;
      await tapText(tester, 'Verificar correo');
      await fillPassword(tester);
      await tapText(tester, 'Activar mi cuenta');
      expect(repo.activationCalls, 0);
      expect(
        find.text('Debes aceptar los términos para continuar.'),
        findsOneWidget,
      );
      await tester.tap(find.byType(Checkbox));
      repo.onActivate = () async {
        throw const AuthFailure('Activación pendiente.');
      };
      await tapText(tester, 'Activar mi cuenta');
      expect(find.text('Activación pendiente.'), findsOneWidget);
      repo.onActivate = null;
      await tapText(tester, 'Activar mi cuenta');
      expect(repo.activationCalls, 2);
      expect(repo.activationVerificationReceived, same(repo.proof));
      expect(find.text('Ya eres parte.'), findsOneWidget);
    },
  );

  testWidgets('missing or wrong verification contexts cannot advance', (
    tester,
  ) async {
    final repo = ControlledAuthRepository();
    for (final route in [AppRoutes.verify, AppRoutes.createPassword]) {
      await open(tester, route, repository: repo, previewContext: false);
      expect(find.text('Este enlace\nya no está disponible.'), findsOneWidget);
      await open(
        tester,
        route,
        repository: repo,
        arguments: 'invalid',
        previewContext: false,
      );
      expect(find.text('Este enlace\nya no está disponible.'), findsOneWidget);
    }
    expect(repo.verifyCalls, 0);
    expect(repo.activationCalls, 0);
  });

  testWidgets('reset preserves its deep link token', (tester) async {
    final repo = ControlledAuthRepository();
    await open(
      tester,
      '${AppRoutes.resetPassword}?token=reset%2B123',
      repository: repo,
    );
    await fillPassword(tester);
    await tapText(tester, 'Guardar contraseña');
    expect(repo.resetToken, 'reset+123');
    expect(find.text('Todo listo.'), findsOneWidget);
  });
}
