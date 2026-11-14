import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';

enum OnboardingStep {
  plan(AppRoutes.plan),
  prevention(AppRoutes.prevention),
  benefits(AppRoutes.benefits),
  meds(AppRoutes.onboardingMeds);

  const OnboardingStep(this.route);
  final String route;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.step, this.onCompleted});
  final OnboardingStep step;
  final Future<void> Function()? onCompleted;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool saving = false;

  Future<void> finish() async {
    if (saving) return;
    setState(() => saving = true);
    try {
      await widget.onCompleted?.call();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No pudimos recordar esta elección en el dispositivo.'),
        ),
      );
    }
    if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
    navigateTo(context, AppRoutes.welcome, clear: true);
  }

  @override
  Widget build(BuildContext context) {
    final index = widget.step.index;
    final steps = OnboardingStep.values;
    final isLast = index == steps.length - 1;
    return PageFrame(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'CONOCE BLUE CARE',
                    style: TextStyle(
                      letterSpacing: 0,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF00858C),
                    ),
                  ),
                ),
                Text(
                  '${index + 1} / ${steps.length}',
                  style: const TextStyle(
                    letterSpacing: 0,
                    fontSize: 10,
                    color: Color(0xFF00858C),
                  ),
                ),
                TextButton(
                  onPressed: saving ? null : finish,
                  child: const Text('Omitir'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (index == 0)
              FeatureCard(
                navy: true,
                height: 250,
                children: [
                  const Text(
                    'TU PLAN BLUE CARE+',
                    style: TextStyle(
                      letterSpacing: 0,
                      color: Color(0xFF7DE1E4),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FeatureTitle('Tu tranquilidad,\nsiempre a la mano.'),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Icon(
                        Icons.radio_button_checked,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Expanded(child: Text('Plan · Vigencia · Beneficios')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Conoce lo que tienes incluido.',
                    style: TextStyle(
                      letterSpacing: 0,
                      fontSize: 12,
                      color: Color(0xFFB9CFF0),
                    ),
                  ),
                ],
              ),
            if (index == 1)
              FeatureCard(
                height: 250,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.event_available_outlined,
                        size: 42,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Tu próxima\nlimpieza',
                          style: TextStyle(
                            letterSpacing: 0,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...[
                    'Cuidado realizado',
                    'Tu siguiente visita',
                    'Tu prevención continúa',
                  ].map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 20,
                            color: Color(0xFF00858C),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(s)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (index == 2)
              FeatureCard(
                height: 250,
                children: [
                  FeatureCard(
                    navy: true,
                    children: [
                      const Text(
                        'BLUE CARE+',
                        style: TextStyle(
                          letterSpacing: 0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Icon(
                        Icons.badge_outlined,
                        size: 30,
                        color: Color(0xFF50DDCF),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tu carné digital',
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Siempre contigo',
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 12,
                          color: Color(0xFFB9CFF0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Cupones y comercios aliados',
                    style: TextStyle(letterSpacing: 0, fontSize: 13),
                  ),
                ],
              ),
            if (widget.step == OnboardingStep.meds)
              FeatureCard(
                navy: true,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    size: 40,
                    color: Color(0xFF50DDCF),
                  ),
                  const SizedBox(height: 16),
                  FeatureTitle('Blue Care Meds'),
                  const SizedBox(height: 12),
                  const Text('Catálogo, carrito y pedidos'),
                ],
              ),
            const SizedBox(height: 26),
            PageHeading(
              [
                'Tu membresía,\nsiempre contigo.',
                'Cuida tu sonrisa,\na tiempo.',
                'Más beneficios\npara tu día a día.',
                'Explora y haz tu pedido.',
              ][index],
            ),
            PageBody(
              [
                'Consulta tu plan, su vigencia y los beneficios que aún tienes disponibles.',
                'Sigue tus limpiezas preventivas y conoce cuándo corresponde tu próximo cuidado.',
                'Lleva tu carné digital y descubre descuentos y cupones en nuestra red de aliados.',
                'Consulta el catálogo de Blue Care Meds y arma tu pedido sin crear una cuenta.',
              ][index],
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                steps.length,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == index ? 26 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              isLast ? 'Continuar' : 'Siguiente',
              isLast
                  ? finish
                  : () => navigateTo(context, steps[index + 1].route),
              busy: saving,
            ),
            if (index > 0)
              LinkButton(
                'Anterior',
                saving
                    ? null
                    : () => Navigator.of(context).canPop()
                          ? Navigator.pop(context)
                          : navigateTo(context, steps[index - 1].route),
              ),
          ],
        ),
      ],
    );
  }
}
