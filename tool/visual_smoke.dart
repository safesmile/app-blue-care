import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:app_blue_care/app.dart';
import 'package:app_blue_care/core/app_routes.dart';
import 'package:app_blue_care/core/presentation/page_widgets.dart';
import 'package:app_blue_care/preview.dart' show previewArgumentsForRoute;

class ReviewBinding extends WidgetsFlutterBinding {
  @override
  ViewConfiguration createViewConfigurationFor(RenderView renderView) =>
      const ViewConfiguration(
        logicalConstraints: BoxConstraints.tightFor(width: 800, height: 1000),
        physicalConstraints: BoxConstraints.tightFor(width: 800, height: 1000),
        devicePixelRatio: 1,
      );
}

// Standalone rendering check for environments that block test-runner sockets.
Future<void> main() async {
  ReviewBinding();
  var failures = 0;
  FlutterError.onError = (details) {
    failures++;
    stderr.writeln(details);
  };
  for (final width in [402.0, 320.0]) {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      for (final route in AppRoutes.all) {
        final key = GlobalKey();
        runApp(
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              height: 884,
              child: RepaintBoundary(
                key: key,
                child: MediaQuery(
                  data: MediaQueryData(
                    size: Size(width, 884),
                    padding: const EdgeInsets.only(top: 44, bottom: 24),
                  ),
                  child: BlueCareApp(
                    key: UniqueKey(),
                    initialRoute: route,
                    initialArguments: previewArgumentsForRoute(route),
                    themeMode: mode,
                  ),
                ),
              ),
            ),
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 180));
        await WidgetsBinding.instance.endOfFrame;
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await boundary.toImage();
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File(
          'build/review/${width.toInt()}_${mode.name}_${route.replaceAll('/', '_')}.png',
        );
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes!.buffer.asUint8List());
        image.dispose();
        stdout.writeln('RENDERED ${width.toInt()} ${mode.name} $route');
      }
    }
  }
  await checkJourneys();
  stdout.writeln('RENDER ERRORS: $failures');
  exit(failures == 0 ? 0 : 1);
}

Future<void> settle() async {
  await Future<void>.delayed(const Duration(milliseconds: 400));
  await WidgetsBinding.instance.endOfFrame;
}

List<Element> visibleElements() {
  final screens = <Element>[];
  void findScreens(Element element) {
    if (element.widget is PageFrame) screens.add(element);
    element.visitChildren(findScreens);
  }

  findScreens(WidgetsBinding.instance.rootElement!);
  final result = <Element>[];
  void visit(Element element) {
    result.add(element);
    element.visitChildren(visit);
  }

  visit(screens.last);
  return result;
}

void checkText(String label) {
  if (!visibleElements().any(
    (e) => e.widget is Text && (e.widget as Text).data == label,
  )) {
    stderr.writeln(
      visibleElements()
          .where((e) => e.widget is Text)
          .map((e) => (e.widget as Text).data)
          .toList(),
    );
    throw StateError('Missing screen text: $label');
  }
}

Future<void> press(String label) async {
  final element = visibleElements().lastWhere(
    (e) => e.widget is Text && (e.widget as Text).data == label,
  );
  VoidCallback? action;
  element.visitAncestorElements((e) {
    if (e.widget is ButtonStyleButton) {
      action = (e.widget as ButtonStyleButton).onPressed;
      return false;
    }
    return true;
  });
  if (action == null) throw StateError('Button unavailable: $label');
  action!();
  await settle();
}

void fill(int index, String text) {
  final field = visibleElements()
      .where((e) => e.widget is TextFormField)
      .map((e) => e.widget as TextFormField)
      .toList()[index];
  field.controller!.text = text;
  field.onChanged?.call(text);
}

Future<void> startAt(String route) async {
  runApp(BlueCareApp(key: UniqueKey(), initialRoute: route));
  await settle();
}

Future<void> checkJourneys() async {
  await startAt(AppRoutes.welcome);
  await press('Iniciar sesión');
  await press('Iniciar sesión');
  checkText('Ingresa un correo válido.');
  await press('Olvidé mi contraseña');
  fill(0, 'test@example.com');
  await settle();
  await press('Enviar instrucciones');
  checkText('Revisa tu correo.');
  await press('Volver a iniciar sesión');
  await press('Continuar sin iniciar sesión');
  checkText('Blue Care Meds');
  stdout.writeln('PASS login validation, recovery, guest');
  await startAt(AppRoutes.invitation);
  await press('Aceptar invitación');
  fill(0, '123456');
  await press('Verificar correo');
  checkText('Protege tu cuenta.');
  fill(0, 'BlueCare2026!');
  fill(1, 'BlueCare2026!');
  final checkbox =
      visibleElements().firstWhere((e) => e.widget is Checkbox).widget
          as Checkbox;
  checkbox.onChanged!(true);
  await settle();
  await press('Activar mi cuenta');
  checkText('Ya eres parte.');
  await press('Ir al inicio');
  checkText('Bienvenido a Blue Care.');
  stdout.writeln('PASS invitation, verification, activation');
  await startAt('${AppRoutes.resetPassword}?token=preview');
  fill(0, 'BlueCare2026!');
  fill(1, 'BlueCare2026!');
  await press('Guardar contraseña');
  checkText('Todo listo.');
  await press('Iniciar sesión');
  await press('Continuar con Google');
  checkText('Bienvenido a Blue Care.');
  await startAt('/missing');
  checkText('No encontramos esta pantalla.');
  stdout.writeln('PASS reset, Google preview, missing route');
}
