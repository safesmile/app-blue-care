import 'package:flutter/material.dart';
import 'app.dart';
import 'core/app_routes.dart';
import 'features/auth/domain/invitation_verification.dart';

/// Explicit sample contexts for the development gallery and visual checks.
Object? previewArgumentsForRoute(String route) => switch (route) {
  AppRoutes.verify => const InvitationVerification(
    challengeId: 'preview-challenge',
  ),
  AppRoutes.createPassword => const VerifiedInvitation(
    activationToken: 'preview-activation',
  ),
  _ => null,
};

/// Development-only entry point, not the production app.
void main() => runApp(const MaterialApp(home: PreviewGallery()));

class PreviewGallery extends StatelessWidget {
  const PreviewGallery({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Blue Care · Revisión de pantallas')),
    body: ListView(
      children: [
        for (final route in AppRoutes.all)
          ListTile(
            title: Text(route),
            trailing: Wrap(
              children: [
                for (final mode in [ThemeMode.light, ThemeMode.dark])
                  IconButton(
                    tooltip: mode == ThemeMode.light
                        ? 'Tema claro'
                        : 'Tema oscuro',
                    icon: Icon(
                      mode == ThemeMode.light
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => BlueCareApp(
                          initialRoute: route,
                          initialArguments: previewArgumentsForRoute(route),
                          themeMode: mode,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    ),
  );
}
