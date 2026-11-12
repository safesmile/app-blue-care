import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';
import '../domain/auth_repository.dart';
import '../application/auth_operation.dart';
import 'auth_form.dart';
import 'auth_widgets.dart';
import 'auth_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.repository});
  final AuthRepository repository;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final operation = AuthOperation();
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    operation.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = widget.repository;

    return AuthForm(
      operation: operation,
      formKey: form,
      builder: (context) => [
        PageHeading('Qué bueno verte.'),
        PageBody(
          'Ingresa para consultar tu membresía y continuar cuidando de ti.',
        ),
        const SizedBox(height: 18),
        AuthField(
          label: 'Correo electrónico',
          hint: 'nombre@correo.com',
          controller: email,
          validator: validEmail,
        ),
        AuthField(
          label: 'Contraseña',
          hint: 'Ingresa tu contraseña',
          controller: password,
          password: true,
          validator: (v) =>
              (v?.isNotEmpty ?? false) ? null : 'Ingresa tu contraseña.',
        ),
        LinkButton(
          'Olvidé mi contraseña',
          () => navigateTo(context, AppRoutes.forgotPassword),
        ),
        const SizedBox(height: 2),
        PrimaryButton(
          'Iniciar sesión',
          () => submitAuth(
            context,
            operation,
            () =>
                repo.signIn(email: email.text.trim(), password: password.text),
            AppRoutes.homePreview,
            form: form,
            clear: true,
          ),
          busy: operation.busy,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Divider(color: Theme.of(context).colorScheme.outline),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('o'),
              ),
              Expanded(
                child: Divider(color: Theme.of(context).colorScheme.outline),
              ),
            ],
          ),
        ),
        SecondaryButton(
          'Continuar con Google',
          () => submitAuth(
            context,
            operation,
            repo.signInWithGoogle,
            AppRoutes.homePreview,
            clear: true,
          ),
        ),
        const SizedBox(height: 16),
        const InfoNote(
          'Acceso solo por invitación. Usa el correo al que te invitó tu clínica.',
        ),
        const SizedBox(height: 2),
        LinkButton(
          'Tengo una invitación',
          () => navigateTo(context, AppRoutes.invitationRequest),
        ),
        LinkButton(
          'Continuar sin iniciar sesión',
          () => navigateTo(context, AppRoutes.explore),
        ),
      ],
    );
  }
}
