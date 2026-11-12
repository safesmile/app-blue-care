import 'dart:async';
import 'package:app_blue_care/features/auth/data/preview_auth_repository.dart';
import 'package:app_blue_care/features/auth/domain/auth_repository.dart';

/// Controls the next network outcome without real delivery or credentials.
class ControlledAuthRepository extends PreviewAuthRepository {
  Future<void> Function()? onSignIn;
  Future<void> Function()? onResend;
  Future<void> Function()? onVerify;
  Future<void> Function()? onActivate;
  Future<void> Function()? onAccept;
  int signInCalls = 0,
      googleCalls = 0,
      resendCalls = 0,
      verifyCalls = 0,
      activationCalls = 0;
  String? invitationToken, resetToken, receivedCode, receivedEmail;
  InvitationVerification? verificationReceived, resendVerificationReceived;
  VerifiedInvitation? activationVerificationReceived;
  final challenge = const InvitationVerification(
    challengeId: 'server-challenge',
  );
  final proof = const VerifiedInvitation(activationToken: 'server-proof');

  @override
  Future<void> signIn({required String email, required String password}) async {
    signInCalls++;
    receivedEmail = email;
    await onSignIn?.call();
  }

  @override
  Future<void> signInWithGoogle() async {
    googleCalls++;
  }

  @override
  Future<InvitationVerification> acceptInvitation(String? token) async {
    invitationToken = token;
    await onAccept?.call();
    return challenge;
  }

  @override
  Future<VerifiedInvitation> verifyEmail({
    required InvitationVerification verification,
    required String code,
  }) async {
    verifyCalls++;
    verificationReceived = verification;
    receivedCode = code;
    await onVerify?.call();
    return proof;
  }

  @override
  Future<void> resendCode({
    required InvitationVerification verification,
  }) async {
    resendCalls++;
    resendVerificationReceived = verification;
    await onResend?.call();
  }

  @override
  Future<void> activateAccount({
    required String password,
    required VerifiedInvitation verification,
  }) async {
    activationCalls++;
    activationVerificationReceived = verification;
    await onActivate?.call();
  }

  @override
  Future<void> resetPassword({required String password, String? token}) async {
    resetToken = token;
  }
}
