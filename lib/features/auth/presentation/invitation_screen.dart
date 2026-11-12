import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';
import '../domain/auth_repository.dart';
import '../application/auth_operation.dart';
import 'auth_form.dart';

class InvitationScreen extends StatefulWidget {
  const InvitationScreen({super.key, required this.repository, this.token});
  final AuthRepository repository;
  final String? token;
  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  final operation = AuthOperation();
  final form = GlobalKey<FormState>();

  @override
  void dispose() {
    operation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = widget.repository;
    InvitationVerification? verification;
    return AuthForm(
      operation: operation,
      formKey: form,
      builder: (context) => [
        PageHeading('Tu invitación\na Blue Care.'),
        PageBody(
          'Tu clínica te invita a activar tu acceso digital. Verifica tu identidad para continuar.',
        ),
        const SizedBox(height: 24),
        FeatureCard(
          children: [
            Icon(
              Icons.drafts_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 36,
            ),
            const SizedBox(height: 14),
            const Text(
              'Acceso para miembros',
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            PageBody('Enviada a s••••@correo.com'),
            const SizedBox(height: 14),
            PageBody(
              'Tu plan y tus beneficios aparecerán después de verificar tu correo.',
            ),
          ],
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          'Aceptar invitación',
          () => submitAuth(
            context,
            operation,
            () async {
              verification = await repo.acceptInvitation(widget.token);
            },
            AppRoutes.verify,
            arguments: () => verification,
          ),
          busy: operation.busy,
        ),
        const SizedBox(height: 10),
        LinkButton(
          'Ya tengo cuenta',
          () => navigateTo(context, AppRoutes.login),
        ),
        const SizedBox(height: 12),
        const InfoNote(
          '¿No reconoces esta invitación? Contacta a tu clínica.',
          icon: Icons.info_outline,
        ),
      ],
    );
  }
}
