import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => PageFrame(
    headerGap: 14,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FeatureCard(
            navy: true,
            height: 225,
            children: [
              const Text(
                'TU MEMBRESÍA, CONTIGO',
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7DE1E4),
                ),
              ),
              const SizedBox(height: 24),
              FeatureTitle('BLUE CARE+'),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Icon(
                    Icons.event_available_outlined,
                    color: Color(0xFF50DDCF),
                    size: 32,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Tu próxima limpieza\nTus beneficios disponibles',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'PREVENCIÓN · BENEFICIOS · BIENESTAR',
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 10,
                  color: Color(0xFFB9CFF0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          PageHeading('Todo tu cuidado,\nen un solo lugar.'),
          PageBody(
            'Consulta tu membresía o explora el catálogo de Blue Care Meds como invitado.',
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            'Iniciar sesión',
            () => navigateTo(context, AppRoutes.login),
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            'Tengo una invitación',
            () => navigateTo(context, AppRoutes.invitation),
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            'Explorar sin iniciar sesión',
            () => navigateTo(context, AppRoutes.explore),
          ),
        ],
      ),
    ],
  );
}
