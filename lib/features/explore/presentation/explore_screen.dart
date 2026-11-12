import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key, this.exploring = true});
  final bool exploring;
  @override
  Widget build(BuildContext context) => PageFrame(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeading(
            exploring ? 'Explora Blue Care.' : 'Bienvenido a Blue Care.',
          ),
          PageBody(
            'Las pantallas de esta sección estarán disponibles en la siguiente etapa.',
          ),
          const SizedBox(height: 24),
          const InfoNote(
            'Vista previa de navegación. No se ha iniciado una sesión ni se han solicitado permisos.',
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            'Volver al inicio',
            () => navigateTo(context, AppRoutes.welcome, clear: true),
          ),
        ],
      ),
    ],
  );
}
