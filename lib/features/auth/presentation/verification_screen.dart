import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../../../core/app_routes.dart';
import '../../../core/presentation/page_widgets.dart';
import '../domain/auth_repository.dart';
import '../application/auth_operation.dart';
import 'auth_form.dart';
import 'clinic_support.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({
    super.key,
    required this.repository,
    required this.verification,
  });
  final AuthRepository repository;
  final InvitationVerification verification;
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final operation = AuthOperation();
  final form = GlobalKey<FormState>();
  final code = List.generate(6, (_) => TextEditingController());
  final focus = List.generate(6, (_) => FocusNode());
  int resendIn = 30;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    operation.dispose();
    timer?.cancel();
    for (final c in code) {
      c.dispose();
    }
    for (final f in focus) {
      f.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
    resendIn = 30;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => resendIn--);
      if (resendIn <= 0) t.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = widget.repository;

    return AuthForm(
      operation: operation,
      formKey: form,
      builder: (context) => [
        PageHeading('Verifica que eres tú.'),
        PageBody(
          'Ingresa el código de 6 dígitos que enviamos a s••••@correo.com.',
        ),
        const SizedBox(height: 24),
        Row(
          children: List.generate(
            6,
            (i) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 5 ? 7 : 0),
                child: TextFormField(
                  controller: code[i],
                  focusNode: focus[i],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  autofillHints: i == 0 ? [AutofillHints.oneTimeCode] : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: '—',
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    counterText: '',
                  ),
                  onChanged: (v) {
                    if (v.length > 1) {
                      for (var n = 0; n < v.length && i + n < 6; n++) {
                        code[i + n].text = v[n];
                      }
                      focus[(i + v.length).clamp(0, 5)].requestFocus();
                    } else if (v.isNotEmpty && i < 5) {
                      focus[i + 1].requestFocus();
                    } else if (v.isEmpty && i > 0) {
                      focus[i - 1].requestFocus();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        PageBody('El código tiene una vigencia limitada.'),
        const SizedBox(height: 24),
        PrimaryButton('Verificar correo', () {
          final otp = code.map((c) => c.text).join();
          if (otp.length != 6) {
            operation.showError('Ingresa los 6 dígitos del código.');
            return;
          }
          VerifiedInvitation? verified;
          submitAuth(
            context,
            operation,
            () async {
              verified = await repo.verifyEmail(
                verification: widget.verification,
                code: otp,
              );
            },
            AppRoutes.createPassword,
            arguments: () => verified,
          );
        }, busy: operation.busy),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: resendIn > 0 || operation.busy
                ? null
                : () async {
                    final success = await submitAuth(
                      context,
                      operation,
                      () => repo.resendCode(verification: widget.verification),
                      null,
                      message: 'Vista previa: código solicitado.',
                    );
                    if (success && mounted) setState(startTimer);
                  },
            child: Text(
              resendIn > 0
                  ? 'Reenviar código en 00:${resendIn.toString().padLeft(2, '0')}'
                  : 'Reenviar código',
            ),
          ),
        ),
        LinkButton(
          'No tengo acceso a este correo',
          () => showClinicSupport(context),
        ),
        const SizedBox(height: 12),
        const InfoNote('Nunca compartas este código con otras personas.'),
      ],
    );
  }
}
