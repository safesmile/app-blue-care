import 'package:flutter/material.dart';
import '../../../core/navigation.dart';
import '../../../core/presentation/page_widgets.dart';
import '../application/auth_operation.dart';

class AuthForm extends StatelessWidget {
  const AuthForm({
    super.key,
    required this.operation,
    required this.formKey,
    required this.builder,
  });
  final AuthOperation operation;
  final GlobalKey<FormState> formKey;
  final List<Widget> Function(BuildContext) builder;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: operation,
    builder: (context, _) => PageFrame(
      children: [
        AbsorbPointer(
          absorbing: operation.busy,
          child: ExcludeFocus(
            excluding: operation.busy,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...builder(context),
                  if (operation.error != null) ...[
                    const SizedBox(height: 16),
                    Semantics(
                      liveRegion: true,
                      child: InfoNote(
                        operation.error!,
                        icon: Icons.error_outline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Future<bool> submitAuth(
  BuildContext context,
  AuthOperation operation,
  Future<void> Function() action,
  String? route, {
  GlobalKey<FormState>? form,
  Object? Function()? arguments,
  String? message,
  bool clear = false,
}) async {
  if (operation.busy ||
      (form != null && !(form.currentState?.validate() ?? false))) {
    return false;
  }
  final success = await operation.run(action);
  if (!success || !context.mounted) return false;
  if (route != null) {
    navigateTo(context, route, clear: clear, arguments: arguments?.call());
  }
  if (message != null) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
  return true;
}
