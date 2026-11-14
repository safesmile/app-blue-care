import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';

class ActivatedScreen extends StatelessWidget {
  const ActivatedScreen({super.key});

  @override
  Widget build(BuildContext context) => PageFrame(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SuccessIcon(Icons.check_circle_outline),
          const SizedBox(height: 26),
          PageHeading('Ya eres parte.'),
          PageBody(
            'Tu cuenta está vinculada. Ahora puedes consultar tu membresía y tus beneficios.',
          ),
          const SizedBox(height: 24),
          const InfoNote(
            'Acceso activado correctamente.',
            icon: Icons.verified_outlined,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            'Ir al inicio',
            () => navigateTo(context, AppRoutes.homePreview, clear: true),
          ),
        ],
      ),
    ],
  );
}
