import 'package:flutter/material.dart';

void showClinicSupport(BuildContext context) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('Contacta a tu clínica'),
    content: const Text(
      'Comunícate con la clínica que te invitó a Blue Care para actualizar tu correo o solicitar una nueva invitación.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Entendido'),
      ),
    ],
  ),
);
