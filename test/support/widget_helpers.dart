import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_blue_care/app.dart';
import 'package:app_blue_care/features/auth/domain/auth_repository.dart';
import 'package:app_blue_care/preview.dart' show previewArgumentsForRoute;

Future<void> open(
  WidgetTester tester,
  String route, {
  ThemeMode mode = ThemeMode.light,
  Size size = const Size(402, 884),
  AuthRepository? repository,
  Object? arguments,
  bool previewContext = true,
}) async {
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPadding);
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.view.padding = FakeViewPadding(top: 44, bottom: 24);
  await tester.pumpWidget(
    BlueCareApp(
      key: UniqueKey(),
      initialRoute: route,
      themeMode: mode,
      repository: repository,
      initialArguments:
          arguments ??
          (previewContext ? previewArgumentsForRoute(route) : null),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> tapText(WidgetTester tester, String text) async {
  final finder = find.text(text).last;
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}
