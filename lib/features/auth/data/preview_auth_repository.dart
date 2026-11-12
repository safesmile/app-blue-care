import '../domain/auth_repository.dart';

/// No HTTP, credential storage, Google SDK, email delivery, or session creation.
class PreviewAuthRepository implements AuthRepository {
  const PreviewAuthRepository();
  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {}
  @override
  Future<void> signInWithGoogle() async {}
  @override
  Future<void> requestInvitation(String email) async {}
  @override
  Future<InvitationVerification> acceptInvitation(String? token) async =>
      const InvitationVerification(challengeId: 'preview-challenge');
  @override
  Future<VerifiedInvitation> verifyEmail({
    required InvitationVerification verification,
    required String code,
  }) async => const VerifiedInvitation(activationToken: 'preview-activation');
  @override
  Future<void> resendCode({
    required InvitationVerification verification,
  }) async {}
  @override
  Future<void> activateAccount({
    required String password,
    required VerifiedInvitation verification,
  }) async {}
  @override
  Future<void> requestPasswordReset(String email) async {}
  @override
  Future<void> resetPassword({required String password, String? token}) async {}
}
