import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';
import '../domain/auth_repository.dart';
import '../application/auth_operation.dart';
import 'auth_form.dart';
import 'auth_widgets.dart';
import 'auth_validators.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen.create({
    super.key,
    required this.repository,
    required VerifiedInvitation this.verification,
  }) : token = null;
  const PasswordScreen.reset({super.key, required this.repository, this.token})
    : verification = null;
  final AuthRepository repository;
  final VerifiedInvitation? verification;
  final String? token;
  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final operation = AuthOperation();
  final form = GlobalKey<FormState>();
  final password = TextEditingController();
  final confirmation = TextEditingController();
  bool consent = false;

  @override
  void dispose() {
    operation.dispose();
    password.dispose();
    confirmation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = widget.repository;
    final creating = widget.verification != null;
    return AuthForm(
      operation: operation,
      formKey: form,
      builder: (context) => [
        PageHeading(creating ? 'Protege tu cuenta.' : 'Un nuevo comienzo.'),
        PageBody(
          creating
              ? 'Tu correo ya está verificado. Crea una contraseña para ingresar a Blue Care.'
              : 'Crea una contraseña diferente a la anterior para proteger tu cuenta.',
        ),
        const SizedBox(height: 24),
        AuthField(
          label: creating ? 'Contraseña' : 'Nueva contraseña',
          hint: 'Crea una contraseña',
          controller: password,
          password: true,
          validator: validPassword,
        ),
        AuthField(
          label: 'Confirmar contraseña',
          hint: 'Repite tu contraseña',
          controller: confirmation,
          password: true,
          validator: (v) =>
              v == password.text ? null : 'Las contraseñas no coinciden.',
        ),
        if (creating) ...[
          Text(
            'Usa al menos 12 caracteres, incluyendo letras y números.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                height: 28,
                child: Checkbox(
                  value: consent,
                  onChanged: (v) => setState(() => consent = v ?? false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => consent = !consent),
                  child: Text(
                    'Acepto los Términos y condiciones y he leído el Aviso de privacidad.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
        if (!creating) ...[
          const InfoNote(
            'Combina letras y números. Evita usar tu nombre o fecha de nacimiento.',
            icon: Icons.lock_outline,
          ),
          const SizedBox(height: 24),
        ],
        PrimaryButton(
          creating ? 'Activar mi cuenta' : 'Guardar contraseña',
          () {
            if (creating && !consent) {
              operation.showError('Debes aceptar los términos para continuar.');
              return;
            }
            submitAuth(
              context,
              operation,
              () => creating
                  ? repo.activateAccount(
                      password: password.text,
                      verification: widget.verification!,
                    )
                  : repo.resetPassword(
                      password: password.text,
                      token: widget.token,
                    ),
              creating ? AppRoutes.activated : AppRoutes.passwordUpdated,
              form: form,
              clear: true,
            );
          },
          busy: operation.busy,
        ),
        if (!creating) ...[
          const SizedBox(height: 10),
          LinkButton(
            'Volver a iniciar sesión',
            () => navigateTo(context, AppRoutes.login, clear: true),
          ),
        ],
      ],
    );
  }
}
