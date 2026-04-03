import 'package:hive_flutter/hive_flutter.dart';
import '../models/assessment_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static LocalStorageService get instance =>
      _instance ??= LocalStorageService._();
  LocalStorageService._();

  late Box _assessmentsBox;
  late Box _userBox;
  late Box _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _assessmentsBox = await Hive.openBox(AppConstants.assessmentsBox);
    _userBox = await Hive.openBox(AppConstants.userBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
  }

  // ── Assessments ───────────────────────────────────────────────────────────

  Future<void> saveAssessment(Assessment a) async {
    await _assessmentsBox.put(a.id, a.toMap());
  }

  List<Assessment> getAssessments() {
    return _assessmentsBox.values
        .map((v) => Assessment.fromMap(Map<String, dynamic>.from(v as Map)))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> deleteAssessment(String id) async {
    await _assessmentsBox.delete(id);
  }

  Future<void> markSynced(String id) async {
    final raw = _assessmentsBox.get(id);
    if (raw != null) {
      final map = Map<String, dynamic>.from(raw as Map);
      map['synced'] = true;
      await _assessmentsBox.put(id, map);
    }
  }

  List<Assessment> getUnsynced() {
    return _assessmentsBox.values
        .map((v) => Assessment.fromMap(Map<String, dynamic>.from(v as Map)))
        .where((a) => !a.synced)
        .toList();
  }

  // ── User Profile ──────────────────────────────────────────────────────────

  Future<void> saveProfile(UserProfile p) async {
    await _userBox.put('profile', p.toMap());
  }

  UserProfile? getProfile() {
    final raw = _userBox.get('profile');
    if (raw == null) return null;
    return UserProfile.fromMap(Map<String, dynamic>.from(raw as Map));
  }

  // ── Settings ──────────────────────────────────────────────────────────────

  T? getSetting<T>(String key) => _settingsBox.get(key) as T?;
  Future<void> setSetting(String key, dynamic value) =>
      _settingsBox.put(key, value);
}
