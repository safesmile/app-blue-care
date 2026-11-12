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

class ExpiredInvitationScreen extends StatefulWidget {
  const ExpiredInvitationScreen({super.key, required this.repository});
  final AuthRepository repository;

  @override
  State<ExpiredInvitationScreen> createState() =>
      _ExpiredInvitationScreenState();
}

class _ExpiredInvitationScreenState extends State<ExpiredInvitationScreen> {
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
        const Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.link_off, size: 48, color: Color(0xFF00858C)),
        ),
        const SizedBox(height: 24),
        PageHeading('Este enlace\nya no está disponible.'),
        PageBody(
          'Puede haber vencido o haber sido utilizado. Solicita una nueva invitación para continuar.',
        ),
        const SizedBox(height: 24),
        AuthField(
          label: 'Correo registrado',
          hint: 'nombre@correo.com',
          controller: email,
          validator: validEmail,
        ),
        const SizedBox(height: 4),
        PrimaryButton(
          'Solicitar nuevo enlace',
          () => submitAuth(
            context,
            operation,
            () => repo.requestInvitation(email.text.trim()),
            AppRoutes.invitationRequest,
            form: form,
          ),
          busy: operation.busy,
        ),
        const SizedBox(height: 24),
        SecondaryButton(
          'Contactar a mi clínica',
          () => showClinicSupport(context),
        ),
        const SizedBox(height: 10),
        LinkButton(
          'Volver a iniciar sesión',
          () => navigateTo(context, AppRoutes.login, clear: true),
        ),
      ],
    );
  }
}
