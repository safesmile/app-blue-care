abstract final class AppRoutes {
  static const welcome = '/';
  static const login = '/auth/login';
  static const invitationRequest = '/auth/invitation/request';
  static const invitation = '/auth/invitation';
  static const verify = '/auth/verify';
  static const createPassword = '/auth/create-password';
  static const activated = '/auth/activated';
  static const expired = '/auth/invitation/expired';
  static const forgotPassword = '/auth/forgot-password';
  static const checkEmail = '/auth/check-email';
  static const resetPassword = '/auth/reset-password';
  static const passwordUpdated = '/auth/password-updated';
  static const plan = '/onboarding/plan';
  static const prevention = '/onboarding/prevention';
  static const benefits = '/onboarding/benefits';
  static const onboardingMeds = '/onboarding/meds';
  static const meds = '/meds';
  static const notifications = '/onboarding/notifications';
  static const homePreview = '/preview/home';
  static const explore = '/explore';
  static const notFound = '/not-found';
  static const all = [
    welcome,
    login,
    invitationRequest,
    invitation,
    verify,
    createPassword,
    activated,
    expired,
    forgotPassword,
    checkEmail,
    resetPassword,
    passwordUpdated,
    plan,
    prevention,
    benefits,
    onboardingMeds,
    meds,
    notifications,
    homePreview,
    explore,
  ];
}
