import 'invitation_verification.dart';
export 'invitation_verification.dart';

/// Contract for the future API adapter. The preview does not create sessions.
abstract interface class AuthRepository {
  Future<void> signIn({required String email, required String password});
  Future<void> signInWithGoogle();
  Future<void> requestInvitation(String email);
  Future<InvitationVerification> acceptInvitation(String? token);
  Future<VerifiedInvitation> verifyEmail({
    required InvitationVerification verification,
    required String code,
  });
  Future<void> resendCode({required InvitationVerification verification});
  Future<void> activateAccount({
    required String password,
    required VerifiedInvitation verification,
  });
  Future<void> requestPasswordReset(String email);
  Future<void> resetPassword({required String password, String? token});
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;
}
