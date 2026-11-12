import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.password = false,
    this.validator,
  });
  final String label, hint;
  final TextEditingController controller;
  final bool password;
  final String? Function(String?)? validator;
  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool hidden = true;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            letterSpacing: 0,
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: widget.password && hidden,
          autocorrect: false,
          enableSuggestions: !widget.password,
          keyboardType: widget.password
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          autofillHints: [
            widget.password ? AutofillHints.password : AutofillHints.email,
          ],
          style: TextStyle(
            letterSpacing: 0,
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: Icon(
              widget.password ? Icons.lock_outline : Icons.mail_outline,
              size: 21,
            ),
            suffixIcon: widget.password
                ? IconButton(
                    tooltip: hidden
                        ? 'Mostrar contraseña'
                        : 'Ocultar contraseña',
                    icon: Icon(
                      hidden
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    onPressed: () => setState(() => hidden = !hidden),
                  )
                : null,
          ),
        ),
      ],
    ),
  );
}
