/// Opaque server challenge returned after accepting an invitation.
/// Kept in route arguments, never in URLs or persistent credential storage.
class InvitationVerification {
  const InvitationVerification({required this.challengeId});
  final String challengeId;
}

/// Proof returned only after a successful OTP verification. A real adapter must
/// obtain this proof from the server; local validation does not grant access.
class VerifiedInvitation {
  const VerifiedInvitation({required this.activationToken});
  final String activationToken;
}
