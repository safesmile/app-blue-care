import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeading('Bienvenido a Blue Care.'),
          const PageBody(
            'Aquí podrás consultar tu membresía cuando esté disponible.',
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            'Explorar Blue Care Meds',
            () => navigateTo(context, AppRoutes.meds),
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            'Volver al inicio',
            () => navigateTo(context, AppRoutes.welcome, clear: true),
          ),
        ],
      ),
    ],
  );
}
