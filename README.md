# Blue Care · Autenticación

Prototipo Flutter basado en los mockups originales con temas claro y oscuro, navegación y validaciones locales. La autenticación y los pedidos funcionan en modo de demostración.

## Ubicación de trabajo

La refactorización se aplica directamente en `C:\Users\jorge\Documents\dentalApp\blue\app_blue_care`.

## Ejecutar

Desde la carpeta de esta app, con Flutter 3.38 / Dart 3.10 o compatible:

```powershell
flutter pub get
flutter run
```

Para revisar todas las pantallas y ambos temas, incluyendo rutas que normalmente llegarían por correo:

```powershell
flutter run -t lib/preview.dart
```

La app normal sigue el tema del sistema. La galería permite elegir claro u oscuro por pantalla. Los datos de invitación y membresía son ejemplos del mockup.

## Recorridos

- Primer arranque → introducción de cuatro pasos, con opción de omitir → bienvenida. La app recuerda en el dispositivo si ya se vio u omitió la introducción.
- Bienvenida → inicio de sesión → destino provisional de inicio.
- Bienvenida → tengo una invitación → aceptación → verificación → contraseña y consentimiento → cuenta activada → destino provisional de inicio.
- Inicio de sesión → tengo una invitación → recuperación de invitación.
- Inicio de sesión → olvidé mi contraseña → solicitud → revisa tu correo.
- Nueva contraseña → contraseña actualizada → inicio de sesión.
- Invitación vencida → solicitar nuevo enlace o contactar a la clínica.
- Explorar sin iniciar sesión → catálogo de Blue Care Meds → carrito → pedido de prueba guardado en el dispositivo.

El catálogo muestra productos y precios de ejemplo. Los pedidos de prueba se pueden consultar en el mismo dispositivo y quedan fuera de los sistemas de cobro y entrega. El inicio de membresía y el acceso con Google siguen en modo de demostración.

En la demostración puedes usar cualquier correo válido, una contraseña de al menos 12 caracteres con letras y números, y cualquier código de seis dígitos. Esas comprobaciones no validan identidad. No se guardan credenciales.

## Estructura

- `lib/app.dart`: composición, inyección de `AuthRepository`, resolución de rutas y tema.
- `lib/core/app_routes.dart`: rutas centralizadas, incluida ruta desconocida.
- `lib/core/app_theme.dart`: colores, tipografía, campos y botones.
- `lib/features/auth/domain/auth_repository.dart`: contrato asíncrono y error de autenticación.
- `lib/features/auth/domain/invitation_verification.dart`: desafío de verificación y prueba de activación tipados.
- `lib/features/auth/data/preview_auth_repository.dart`: adaptador de demostración, sin red.
- `lib/features/auth/application/auth_operation.dart`: carga, errores, exclusión de operaciones duplicadas y finalización después de salir de la pantalla.
- `lib/features/auth/presentation/`: pantallas por responsabilidad; cada formulario posee y libera únicamente sus controladores. Creación y recuperación comparten un formulario de contraseña con constructores explícitos.
- `lib/core/presentation/page_widgets.dart`: contenedor, títulos, botones y tarjetas reutilizables con parámetros explícitos.
- `lib/features/welcome/`, `lib/features/onboarding/` y `lib/features/explore/`: funcionalidades independientes de autenticación.
- `lib/preview.dart`: galería exclusiva para desarrollo.
- `assets/images/`: logos originales claro/oscuro.
- `assets/fonts/`: Inter local y licencia OFL. Pesos 400, 600 y 700 obtenidos de la fuente variable oficial de google/fonts.

La interfaz permite carga y error de operaciones asíncronas y evita envíos duplicados. Mientras hay una operación pendiente, el formulario bloquea interacción y foco. Los formularios tienen validación, contraseñas visibles/ocultas, confirmación y consentimiento. El código admite pegar seis dígitos y reenvío con espera de 30 segundos. El contador se reinicia únicamente después de un reenvío exitoso; un error permite reintentar inmediatamente. Los campos se liberan al salir; el temporizador se cancela al destruir la pantalla. El contenido puede desplazarse con teclado abierto o en dispositivos pequeños.

## Siguiente etapa: API

Inyectar una implementación real de `AuthRepository` en `BlueCareApp(repository: ...)`. El contrato no presupone URLs ni un proveedor de identidad. La secuencia explícita es:

1. `acceptInvitation(token)` devuelve `InvitationVerification(challengeId: ...)`.
2. Verificación y reenvío reciben ese mismo desafío. `verifyEmail(verification: ..., code: ...)` devuelve `VerifiedInvitation(activationToken: ...)`.
3. `activateAccount(password: ..., verification: ...)` recibe la prueba devuelta por la verificación.

Ambos objetos viajan en `RouteSettings.arguments` y permanecen en memoria durante el flujo; no se agregan a las URL ni se guardan en disco. Abrir verificación o creación de contraseña sin el argumento correcto muestra la pantalla de enlace no disponible. Si se cierra la app, debe reiniciarse el flujo desde la invitación. La galería suministra contextos de ejemplo explícitos para poder revisar esas pantallas de forma independiente.

El adaptador real deberá obtener el desafío y la prueba del servidor, validar su vigencia, interpretar errores y devolver respuestas reales. Los objetos Dart y las guardas de navegación no sustituyen la autorización del servidor.

Las rutas `/auth/invitation?token=...` y `/auth/reset-password?token=...` ya extraen el parámetro para el adaptador. La asociación de enlaces de Android/iOS (App Links/Universal Links), el proveedor Google, almacenamiento seguro de sesión, renovación, guardas y revocación quedan pendientes de definir con la API. Las rutas actuales son de un prototipo; no son una frontera de autorización.

Antes de producción deben conectarse los datos del paciente y membresía, la verificación real del código y su expiración, la política de contraseñas del servidor, los documentos legales, los canales de soporte y los permisos de notificaciones. El acceso continúa siendo por invitación; no hay pantalla de registro libre.

## Validación

```powershell
flutter analyze
flutter test
```

La suite normal cubre ambos temas y pantallas pequeñas, validación, invitación/OTP/activación, introducción, recuperación, Google simulado y rutas desconocidas. Incluye errores esperados e inesperados, reintentos, bloqueo de operaciones simultáneas, finalización después de salir, propagación del contexto y reenvío OTP. No genera capturas.

Las capturas se ejecutan por separado y se escriben en `build/review/`:

```powershell
flutter test tool/capture_screens_test.dart
```

El programa alternativo de revisión independiente se compila con `flutter build bundle --debug -t tool/visual_smoke.dart`; produce capturas en `build/review/` y termina con un código de error si falla una comprobación. No es un punto de entrada de producción. Estas verificaciones no sustituyen pruebas táctiles en Android/iOS; no se generó un APK/IPA en esta refactorización.

Las barras de estado y navegación del teléfono pertenecen al sistema operativo: no se dibuja una hora ficticia ni una barra de inicio dentro de la aplicación.
