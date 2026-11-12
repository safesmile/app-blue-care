import 'package:flutter/material.dart';
import '../app_routes.dart';
import '../navigation.dart';
import 'page_widgets.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) => PageFrame(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeading('No encontramos esta pantalla.'),
          PageBody('Vuelve al inicio para continuar.'),
          const SizedBox(height: 24),
          PrimaryButton(
            'Ir al inicio',
            () => navigateTo(context, AppRoutes.welcome, clear: true),
          ),
        ],
      ),
    ],
  );
}
