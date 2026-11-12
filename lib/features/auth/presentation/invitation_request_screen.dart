import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';
import '../domain/auth_repository.dart';
import '../application/auth_operation.dart';
import 'auth_form.dart';
import 'auth_widgets.dart';
import 'auth_validators.dart';
import 'clinic_support.dart';

class InvitationRequestScreen extends StatefulWidget {
  const InvitationRequestScreen({super.key, required this.repository});
  final AuthRepository repository;

  @override
  State<InvitationRequestScreen> createState() =>
      _InvitationRequestScreenState();
}

class _InvitationRequestScreenState extends State<InvitationRequestScreen> {
  final operation = AuthOperation();
  final form = GlobalKey<FormState>();
  final email = TextEditingController();

  @override
  void dispose() {
    operation.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = widget.repository;

    return AuthForm(
      operation: operation,
      formKey: form,
      builder: (context) => [
        PageHeading('Recupera tu invitación.'),
        PageBody(
          'Ingresa el correo al que te invitó tu clínica. Si tienes una invitación pendiente, te enviaremos un nuevo enlace.',
        ),
        const SizedBox(height: 24),
        AuthField(
          label: 'Correo electrónico',
          hint: 'nombre@correo.com',
          controller: email,
          validator: validEmail,
        ),
        const SizedBox(height: 4),
        PrimaryButton(
          'Reenviar mi invitación',
          () => submitAuth(
            context,
            operation,
            () => repo.requestInvitation(email.text.trim()),
            null,
            form: form,
            message:
                'Vista previa: aquí se confirmará la solicitud del nuevo enlace.',
          ),
          busy: operation.busy,
        ),
        const SizedBox(height: 24),
        const InfoNote(
          '¿Aún no tienes invitación? Solicítala directamente en tu clínica.',
          icon: Icons.verified_outlined,
        ),
        const SizedBox(height: 12),
        LinkButton(
          'No tengo acceso a ese correo',
          () => showClinicSupport(context),
        ),
        LinkButton(
          'Ya tengo cuenta · Iniciar sesión',
          () => navigateTo(context, AppRoutes.login),
        ),
      ],
    );
  }
}
