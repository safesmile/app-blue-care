import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';

class PasswordUpdatedScreen extends StatelessWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  Widget build(BuildContext context) => PageFrame(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SuccessIcon(Icons.verified_user_outlined),
          const SizedBox(height: 26),
          PageHeading('Todo listo.'),
          PageBody(
            'Tu contraseña se actualizó. Inicia sesión con tu nueva contraseña para volver a Blue Care.',
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            'Iniciar sesión',
            () => navigateTo(context, AppRoutes.login, clear: true),
          ),
        ],
      ),
    ],
  );
}
