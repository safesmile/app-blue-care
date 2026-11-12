import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';
import '../domain/auth_repository.dart';
import '../application/auth_operation.dart';
import 'auth_form.dart';
import 'auth_widgets.dart';
import 'auth_validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key, required this.repository});
  final AuthRepository repository;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
          child: Icon(Icons.key_outlined, size: 48, color: Color(0xFF00858C)),
        ),
        const SizedBox(height: 24),
        PageHeading('Recupera tu acceso.'),
        PageBody(
          'Ingresa el correo de tu cuenta. Te enviaremos instrucciones para crear una nueva contraseña.',
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
          'Enviar instrucciones',
          () => submitAuth(
            context,
            operation,
            () => repo.requestPasswordReset(email.text.trim()),
            AppRoutes.checkEmail,
            form: form,
          ),
          busy: operation.busy,
        ),
        const SizedBox(height: 10),
        LinkButton(
          'Volver a iniciar sesión',
          () => navigateTo(context, AppRoutes.login),
        ),
        const SizedBox(height: 12),
        const InfoNote(
          'Si ya no tienes acceso a tu correo, tu clínica puede ayudarte.',
          icon: Icons.support_outlined,
        ),
      ],
    );
  }
}
