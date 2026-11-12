import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) => PageFrame(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeatureCard(
            children: [
              Icon(
                Icons.notifications_active_outlined,
                size: 42,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 18),
              const Text(
                'Un recordatorio para ti',
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              PageBody(
                'Tu próxima limpieza está cerca.\nConsulta tu plan para ver los detalles.',
              ),
            ],
          ),
          const SizedBox(height: 26),
          PageHeading('Que no se te pase\nlo importante.'),
          PageBody(
            'Recibe avisos de tus próximas limpiezas, tu membresía y beneficios por vencer.',
          ),
          const SizedBox(height: 24),
          const InfoNote(
            'Puedes cambiar esta preferencia cuando quieras desde tu perfil.',
            icon: Icons.tune,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            'Activar notificaciones',
            () => navigateTo(context, AppRoutes.homePreview, clear: true),
          ),
          const SizedBox(height: 10),
          LinkButton(
            'Ahora no · Ir al inicio',
            () => navigateTo(context, AppRoutes.homePreview, clear: true),
          ),
          const SizedBox(height: 4),
          Text(
            'Al continuar, tu dispositivo te pedirá permiso para recibir notificaciones.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ],
  );
}
