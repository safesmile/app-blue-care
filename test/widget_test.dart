import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_blue_care/core/app_routes.dart';
import 'package:app_blue_care/main.dart' as app;
import 'package:app_blue_care/features/meds/data/demo_meds_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      expect(find.text('Blue Care Meds'), findsOneWidget);
    },
  );
  testWidgets('Invitation, OTP, consent and activation go straight to home', (
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
    await tapText(tester, 'Ir al inicio');
    expect(find.text('Bienvenido a Blue Care.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('First launch offers onboarding and guest orders persist', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await app.main();
    await tester.pumpAndSettle();
    expect(find.text('CONOCE BLUE CARE'), findsOneWidget);
    expect(find.text('Iniciar sesión'), findsNothing);
    for (var step = 0; step < 3; step++) {
      await tapText(tester, 'Siguiente');
    }
    expect(find.text('Explora y haz tu pedido.'), findsOneWidget);
    await tapText(tester, 'Continuar');
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Tengo una invitación'), findsOneWidget);
    await tapText(tester, 'Explorar sin iniciar sesión');

    final addProduct = find.byKey(const ValueKey(MedsProduct.toothbrush));
    await tester.ensureVisible(addProduct);
    await tester.pumpAndSettle();
    await tester.tap(addProduct);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Ver carrito (1) · Q28'),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await tapText(tester, 'Ver carrito (1) · Q28');
    expect(find.text('1 × Cepillo dental suave'), findsOneWidget);
    await tapText(tester, 'Crear pedido de prueba');
    expect(find.text('Ver carrito (0) · Q0'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await app.main();
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('CONOCE BLUE CARE'), findsNothing);
    await tapText(tester, 'Explorar sin iniciar sesión');
    await tapText(tester, 'Ver pedidos de prueba');
    expect(find.text('1 × Cepillo dental suave'), findsOneWidget);
    expect(find.text('Total de prueba Q28'), findsOneWidget);
  });

  testWidgets('Skipping onboarding is remembered', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await app.main();
    await tester.pumpAndSettle();
    await tapText(tester, 'Omitir');
    expect(find.text('Tengo una invitación'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await app.main();
    await tester.pumpAndSettle();
    expect(find.text('Tengo una invitación'), findsOneWidget);
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
