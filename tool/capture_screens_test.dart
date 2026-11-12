import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_blue_care/app.dart';
import 'package:app_blue_care/core/app_routes.dart';

void main() {
  testWidgets('Capture representative screens for visual review', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    await tester.runAsync(() async {
      final font = FontLoader('Inter');
      for (final weight in [400, 600, 700]) {
        font.addFont(rootBundle.load('assets/fonts/Inter-$weight.ttf'));
      }
      await font.load();
      await (FontLoader(
        'MaterialIcons',
      )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    });
    tester.view.physicalSize = const Size(402, 884);
    tester.view.devicePixelRatio = 1;
    tester.view.padding = FakeViewPadding(top: 44, bottom: 24);
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      for (final route in [
        AppRoutes.welcome,
        AppRoutes.login,
        AppRoutes.invitation,
        AppRoutes.plan,
      ]) {
        final key = GlobalKey();
        await tester.pumpWidget(
          RepaintBoundary(
            key: key,
            child: BlueCareApp(
              key: UniqueKey(),
              themeMode: mode,
              initialRoute: route,
            ),
          ),
        );
        await tester.pumpAndSettle();
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await boundary.toImage();
          try {
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            final file = File(
              'build/review/${mode.name}_${route.replaceAll('/', '_')}.png',
            );
            await file.parent.create(recursive: true);
            await file.writeAsBytes(bytes!.buffer.asUint8List());
          } finally {
            image.dispose();
          }
        });
      }
    }
  });
}
