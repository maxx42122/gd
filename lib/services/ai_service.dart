import '../models/assessment_model.dart';
import '../models/user_model.dart';
import '../muscle_diagnosis.dart';
import '../utils/constants.dart';
import 'package:uuid/uuid.dart';

/// Local AI engine — runs entirely on-device, no network required.
/// Mirrors the Cloud Function logic so offline mode is fully functional.
class AiService {
  static const _uuid = Uuid();

  // ── Symptom weight table ──────────────────────────────────────────────────
  static const Map<String, int> _weights = {
    // Critical
    'chest pain': 10,
    'difficulty breathing': 10,
    'shortness of breath': 10,
    'severe bleeding': 10,
    'loss of consciousness': 10,
    'severe headache': 8,
    'stroke': 10,
    'heart attack': 10,
    // Moderate-high
    'high fever': 6,
    'persistent cough': 5,
    'severe pain': 7,
    'vomiting blood': 9,
    'seizure': 9,
    'paralysis': 9,
    // Moderate
    'fever': 5,
    'cough': 3,
    'back pain': 4,
    'joint pain': 4,
    'muscle pain': 3,
    'abdominal pain': 5,
    'dizziness': 4,
    'nausea': 3,
    'vomiting': 4,
    // Mild
    'mild headache': 2,
    'fatigue': 3,
    'sore throat': 3,
    'runny nose': 2,
    'sneezing': 1,
    'mild pain': 2,
  };

  Assessment analyze({
    required List<String> symptoms,
    required List<String> muscleIds,
    required UserProfile profile,
  }) {
    // Score from typed symptoms
    double score = 0;
    final matched = <String>[];

    for (final s in symptoms) {
      final lower = s.toLowerCase();
      int best = 2;
      for (final entry in _weights.entries) {
        if (lower.contains(entry.key) || entry.key.contains(lower)) {
          if (entry.value > best) best = entry.value;
        }
      }
      score += best;
      matched.add(s);
    }

    // Score from muscle conditions
    final conditions = getConditionsForMuscles(muscleIds.toSet());
    for (final c in conditions) {
      switch (c.impact) {
        case ImpactLevel.high:
          score += 5;
          break;
        case ImpactLevel.moderate:
          score += 3;
          break;
        case ImpactLevel.low:
          score += 1;
          break;
      }
    }

    // Age modifier
    if (profile.age > 65) score *= 1.2;
    if (profile.age < 5) score *= 1.15;
    if (profile.medicalHistory.isNotEmpty) score *= 1.1;

    // Risk level
    RiskLevel level;
    String guidance;
    String explanation;

    if (score >= AppConstants.highRiskThreshold) {
      level = RiskLevel.high;
      guidance =
          'Seek immediate medical attention. Call emergency services (911) or go to the nearest emergency room now.';
      explanation =
          'Your symptoms indicate a potentially serious condition requiring urgent evaluation by a medical professional.';
    } else if (score >= AppConstants.mediumRiskThreshold) {
      level = RiskLevel.medium;
      guidance =
          'Consult a healthcare provider within 24 hours. Monitor your symptoms closely and seek emergency care if they worsen.';
      explanation =
          'Your symptoms suggest a condition that should be evaluated by a medical professional soon.';
    } else {
      level = RiskLevel.low;
      guidance =
          'Monitor your symptoms. Home care may be appropriate. Consult a doctor if symptoms worsen or persist beyond 3 days.';
      explanation =
          'Your symptoms appear mild. Rest, hydration, and over-the-counter remedies may help.';
    }

    final confidence = _confidence(matched.length + muscleIds.length);
    final followUp = _generateFollowUp(symptoms);

    return Assessment(
      id: _uuid.v4(),
      symptoms: symptoms,
      muscleIds: muscleIds,
      riskLevel: level,
      confidence: confidence,
      guidance: guidance,
      explanation: explanation,
      timestamp: DateTime.now(),
      followUpQuestions: followUp,
    );
  }

  double _confidence(int count) {
    if (count >= 5) return AppConstants.highConfidence;
    if (count >= 3) return AppConstants.mediumConfidence;
    return AppConstants.lowConfidence;
  }

  List<FollowUpQuestion> _generateFollowUp(List<String> symptoms) {
    final questions = <FollowUpQuestion>[];
    final lower = symptoms.map((s) => s.toLowerCase()).toList();

    if (lower.any((s) => s.contains('fever'))) {
      questions.add(const FollowUpQuestion(
        question: 'How high is your temperature?',
        options: ['Below 100°F (37.8°C)', '100–102°F', 'Above 102°F (38.9°C)'],
      ));
    }
    if (lower.any((s) => s.contains('pain'))) {
      questions.add(const FollowUpQuestion(
        question: 'How severe is the pain on a scale of 1–10?',
        options: ['1–3 (Mild)', '4–6 (Moderate)', '7–10 (Severe)'],
      ));
    }
    if (lower.any((s) => s.contains('cough'))) {
      questions.add(const FollowUpQuestion(
        question: 'What accompanies the cough?',
        options: ['Mucus', 'Blood', 'Chest tightness', 'Nothing'],
        multiSelect: true,
      ));
    }
    if (lower.any((s) => s.contains('breath'))) {
      questions.add(const FollowUpQuestion(
        question: 'When does breathing difficulty occur?',
        options: [
          'At rest',
          'With activity',
          'When lying down',
          'All the time'
        ],
      ));
    }
    return questions;
  }

  /// Compute trends from a list of local assessments
  HealthTrends computeTrends(List<Assessment> assessments) {
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 30));
    final monthly =
        assessments.where((a) => a.timestamp.isAfter(monthAgo)).toList();

    final dist = {'low': 0, 'medium': 0, 'high': 0};
    final symptoms = <String, int>{};
    final timeline = <Map<String, dynamic>>[];

    for (final a in assessments) {
      dist[a.riskLevel.name] = (dist[a.riskLevel.name] ?? 0) + 1;
      for (final s in a.symptoms) {
        symptoms[s] = (symptoms[s] ?? 0) + 1;
      }
      timeline.add({
        'date': a.timestamp.toIso8601String(),
        'riskLevel': a.riskLevel.name
      });
    }

    return HealthTrends(
      totalAssessments: assessments.length,
      monthlyCount: monthly.length,
      riskDistribution: dist,
      commonSymptoms: symptoms,
      timeline: timeline,
    );
  }
}
