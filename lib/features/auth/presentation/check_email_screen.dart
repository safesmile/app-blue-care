import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context) => PageFrame(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SuccessIcon(Icons.mark_email_read_outlined, blue: true),
          const SizedBox(height: 26),
          PageHeading('Revisa tu correo.'),
          PageBody(
            'Si hay una cuenta asociada a ese correo, recibirás un enlace para restablecer tu contraseña.',
          ),
          const SizedBox(height: 24),
          PageBody(
            'Revisa también la carpeta de spam. El enlace solo se puede usar una vez.',
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            'Volver a iniciar sesión',
            () => navigateTo(context, AppRoutes.login, clear: true),
          ),
          const SizedBox(height: 10),
          LinkButton(
            'Reenviar instrucciones',
            () => navigateTo(context, AppRoutes.forgotPassword),
          ),
          LinkButton(
            'Usar otro correo',
            () => navigateTo(context, AppRoutes.forgotPassword),
          ),
        ],
      ),
    ],
  );
}
