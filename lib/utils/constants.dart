class AppConstants {
  static const appName = 'HealthAI Triage';
  static const appVersion = '1.0.0';

  // Firestore collections
  static const usersCol = 'users';
  static const assessmentsCol = 'assessments';
  static const profileDoc = 'profile';

  // Hive boxes
  static const assessmentsBox = 'assessments_local';
  static const userBox = 'user_local';
  static const settingsBox = 'settings';

  // Risk thresholds
  static const highRiskThreshold = 15;
  static const mediumRiskThreshold = 8;

  // Confidence levels
  static const highConfidence = 0.85;
  static const mediumConfidence = 0.70;
  static const lowConfidence = 0.60;
}
