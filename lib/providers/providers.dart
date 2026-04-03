import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/assessment_model.dart';
import '../models/user_model.dart';
import '../services/ai_service.dart';
import '../services/firebase_service.dart';
import '../services/local_storage_service.dart';
import '../services/voice_service.dart';

// ── Services ──────────────────────────────────────────────────────────────────

final aiServiceProvider = Provider((_) => AiService());
final firebaseServiceProvider = Provider((_) => FirebaseService.instance);
final localStorageProvider = Provider((_) => LocalStorageService.instance);
final voiceServiceProvider = Provider((_) => VoiceService.instance);

// ── Auth ──────────────────────────────────────────────────────────────────────

final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseService.instance.authState,
);

// ── User Profile ──────────────────────────────────────────────────────────────

class UserProfileNotifier extends StateNotifier<UserProfile?> {
  UserProfileNotifier() : super(null) {
    _load();
  }

  void _load() {
    final local = LocalStorageService.instance.getProfile();
    if (local != null) state = local;
  }

  Future<void> save(UserProfile profile) async {
    state = profile;
    await LocalStorageService.instance.saveProfile(profile);
    await FirebaseService.instance.saveProfile(profile);
  }

  Future<void> loadFromFirebase() async {
    final remote = await FirebaseService.instance.getProfile();
    if (remote != null) {
      state = remote;
      await LocalStorageService.instance.saveProfile(remote);
    }
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile?>(
  (_) => UserProfileNotifier(),
);

// ── Assessments ───────────────────────────────────────────────────────────────

class AssessmentsNotifier extends StateNotifier<List<Assessment>> {
  AssessmentsNotifier() : super([]) {
    _loadLocal();
  }

  void _loadLocal() {
    state = LocalStorageService.instance.getAssessments();
  }

  Future<Assessment> analyze({
    required List<String> symptoms,
    required List<String> muscleIds,
    required UserProfile profile,
    required AiService ai,
  }) async {
    final assessment = ai.analyze(
      symptoms: symptoms,
      muscleIds: muscleIds,
      profile: profile,
    );

    // Save locally first (offline-first)
    await LocalStorageService.instance.saveAssessment(assessment);
    state = [assessment, ...state];

    // Try to sync to Firebase
    try {
      await FirebaseService.instance.saveAssessment(assessment);
      await LocalStorageService.instance.markSynced(assessment.id);
    } catch (_) {
      // Will sync later when online
    }

    return assessment;
  }

  Future<void> syncPending() async {
    final unsynced = LocalStorageService.instance.getUnsynced();
    for (final a in unsynced) {
      try {
        await FirebaseService.instance.saveAssessment(a);
        await LocalStorageService.instance.markSynced(a.id);
      } catch (_) {}
    }
  }

  void refresh() => _loadLocal();
}

final assessmentsProvider =
    StateNotifierProvider<AssessmentsNotifier, List<Assessment>>(
  (_) => AssessmentsNotifier(),
);

// ── Health Trends ─────────────────────────────────────────────────────────────

final healthTrendsProvider = Provider<HealthTrends>((ref) {
  final assessments = ref.watch(assessmentsProvider);
  return AiService().computeTrends(assessments);
});

// ── Voice State ───────────────────────────────────────────────────────────────

final isListeningProvider = StateProvider<bool>((_) => false);
final voicePartialProvider = StateProvider<String>((_) => '');

// ── Selected Symptoms ─────────────────────────────────────────────────────────

final selectedSymptomsProvider = StateProvider<List<String>>((_) => []);
