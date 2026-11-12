String? validEmail(String? value) =>
    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value?.trim() ?? '')
    ? null
    : 'Ingresa un correo válido.';
String? validPassword(String? value) =>
    (value?.length ?? 0) >= 12 &&
        RegExp(r'[a-zA-Z]').hasMatch(value!) &&
        RegExp(r'[0-9]').hasMatch(value)
    ? null
    : 'Usa 12 caracteres, letras y números.';
