import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_blue_care/core/app_routes.dart';

import 'support/widget_helpers.dart';

void main() {
  testWidgets('All designs render in both themes and on compact screens', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final size in [const Size(402, 884), const Size(320, 568)]) {
      for (final mode in [ThemeMode.light, ThemeMode.dark]) {
        for (final route in AppRoutes.all) {
          await open(tester, route, mode: mode, size: size);
          expect(
            tester.takeException(),
            isNull,
            reason: '$route / $mode / $size',
          );
        }
      }
    }
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'Welcome, login validation, password recovery and guest navigation',
    (tester) async {
      await open(tester, AppRoutes.welcome);
      await tapText(tester, 'Iniciar sesión');
      expect(find.text('Qué bueno verte.'), findsOneWidget);
      await tapText(tester, 'Iniciar sesión');
      expect(find.text('Ingresa un correo válido.'), findsOneWidget);
      await tapText(tester, 'Olvidé mi contraseña');
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tapText(tester, 'Enviar instrucciones');
      expect(find.text('Revisa tu correo.'), findsOneWidget);
      await tapText(tester, 'Volver a iniciar sesión');
      await tapText(tester, 'Continuar sin iniciar sesión');
      expect(find.text('Explora Blue Care.'), findsOneWidget);
    },
  );
  testWidgets('Invitation, OTP, consent, activation and onboarding journey', (
    tester,
  ) async {
    await open(tester, AppRoutes.invitation);
    await tapText(tester, 'Aceptar invitación');
    await tester.enterText(find.byType(TextFormField).first, '123456');
    await tapText(tester, 'Verificar correo');
    expect(find.text('Protege tu cuenta.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'BlueCare2026!');
    await tester.enterText(find.byType(TextFormField).at(1), 'BlueCare2026!');
    await tester.tap(find.byType(Checkbox));
    await tapText(tester, 'Activar mi cuenta');
    expect(find.text('Ya eres parte.'), findsOneWidget);
    await tapText(tester, 'Conocer mi Blue Care');
    await tapText(tester, 'Siguiente');
    await tapText(tester, 'Siguiente');
    await tapText(tester, 'Continuar');
    await tapText(tester, 'Ahora no · Ir al inicio');
    expect(find.text('Bienvenido a Blue Care.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('Password reset, unknown routes, and Google preview', (
    tester,
  ) async {
    await open(tester, '${AppRoutes.resetPassword}?token=preview');
    await tester.enterText(find.byType(TextFormField).at(0), 'BlueCare2026!');
    await tester.enterText(find.byType(TextFormField).at(1), 'BlueCare2026!');
    await tapText(tester, 'Guardar contraseña');
    expect(find.text('Todo listo.'), findsOneWidget);
    await open(tester, '/missing');
    expect(find.text('No encontramos esta pantalla.'), findsOneWidget);
    await open(tester, AppRoutes.login);
    await tapText(tester, 'Continuar con Google');
    expect(find.text('Bienvenido a Blue Care.'), findsOneWidget);
  });
}
