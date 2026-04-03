import 'package:flutter/material.dart';
import '../utils/theme.dart';

enum RiskLevel { low, medium, high }

class FollowUpQuestion {
  final String question;
  final List<String> options;
  final String type; // 'choice' | 'scale' | 'multiSelect'
  final bool multiSelect;

  const FollowUpQuestion({
    required this.question,
    this.options = const [],
    this.type = 'choice',
    this.multiSelect = false,
  });

  factory FollowUpQuestion.fromMap(Map<String, dynamic> m) => FollowUpQuestion(
        question: m['question'] ?? '',
        options: List<String>.from(m['options'] ?? []),
        type: m['type'] ?? 'choice',
        multiSelect: m['multiSelect'] ?? false,
      );

  Map<String, dynamic> toMap() => {
        'question': question,
        'options': options,
        'type': type,
        'multiSelect': multiSelect,
      };
}

class Assessment {
  final String id;
  final List<String> symptoms;
  final List<String> muscleIds;
  final RiskLevel riskLevel;
  final double confidence;
  final String guidance;
  final String explanation;
  final DateTime timestamp;
  final List<FollowUpQuestion> followUpQuestions;
  final bool resolved;
  final bool synced;

  const Assessment({
    required this.id,
    required this.symptoms,
    this.muscleIds = const [],
    required this.riskLevel,
    required this.confidence,
    required this.guidance,
    required this.explanation,
    required this.timestamp,
    this.followUpQuestions = const [],
    this.resolved = false,
    this.synced = false,
  });

  Color get riskColor {
    switch (riskLevel) {
      case RiskLevel.low:
        return AppTheme.kLow;
      case RiskLevel.medium:
        return AppTheme.kMedium;
      case RiskLevel.high:
        return AppTheme.kHigh;
    }
  }

  IconData get riskIcon {
    switch (riskLevel) {
      case RiskLevel.low:
        return Icons.check_circle_rounded;
      case RiskLevel.medium:
        return Icons.warning_rounded;
      case RiskLevel.high:
        return Icons.error_rounded;
    }
  }

  String get riskLabel {
    switch (riskLevel) {
      case RiskLevel.low:
        return 'LOW RISK';
      case RiskLevel.medium:
        return 'MEDIUM RISK';
      case RiskLevel.high:
        return 'HIGH RISK';
    }
  }

  factory Assessment.fromMap(Map<String, dynamic> m) {
    RiskLevel level;
    switch (m['riskLevel']) {
      case 'high':
        level = RiskLevel.high;
        break;
      case 'medium':
        level = RiskLevel.medium;
        break;
      default:
        level = RiskLevel.low;
    }
    return Assessment(
      id: m['id'] ?? '',
      symptoms: List<String>.from(m['symptoms'] ?? []),
      muscleIds: List<String>.from(m['muscleIds'] ?? []),
      riskLevel: level,
      confidence: (m['confidence'] ?? 0.6).toDouble(),
      guidance: m['guidance'] ?? '',
      explanation: m['explanation'] ?? '',
      timestamp: m['timestamp'] is DateTime
          ? m['timestamp']
          : DateTime.tryParse(m['timestamp']?.toString() ?? '') ??
              DateTime.now(),
      followUpQuestions: (m['followUpQuestions'] as List? ?? [])
          .map((q) => FollowUpQuestion.fromMap(Map<String, dynamic>.from(q)))
          .toList(),
      resolved: m['resolved'] ?? false,
      synced: m['synced'] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'symptoms': symptoms,
        'muscleIds': muscleIds,
        'riskLevel': riskLevel.name,
        'confidence': confidence,
        'guidance': guidance,
        'explanation': explanation,
        'timestamp': timestamp.toIso8601String(),
        'followUpQuestions': followUpQuestions.map((q) => q.toMap()).toList(),
        'resolved': resolved,
        'synced': synced,
      };

  Assessment copyWith({bool? resolved, bool? synced}) => Assessment(
        id: id,
        symptoms: symptoms,
        muscleIds: muscleIds,
        riskLevel: riskLevel,
        confidence: confidence,
        guidance: guidance,
        explanation: explanation,
        timestamp: timestamp,
        followUpQuestions: followUpQuestions,
        resolved: resolved ?? this.resolved,
        synced: synced ?? this.synced,
      );
}

class HealthTrends {
  final int totalAssessments;
  final int monthlyCount;
  final Map<String, int> riskDistribution;
  final Map<String, int> commonSymptoms;
  final List<Map<String, dynamic>> timeline;

  const HealthTrends({
    required this.totalAssessments,
    required this.monthlyCount,
    required this.riskDistribution,
    required this.commonSymptoms,
    required this.timeline,
  });

  factory HealthTrends.empty() => const HealthTrends(
        totalAssessments: 0,
        monthlyCount: 0,
        riskDistribution: {'low': 0, 'medium': 0, 'high': 0},
        commonSymptoms: {},
        timeline: [],
      );

  factory HealthTrends.fromMap(Map<String, dynamic> m) => HealthTrends(
        totalAssessments: m['totalAssessments'] ?? 0,
        monthlyCount: m['monthlyCount'] ?? 0,
        riskDistribution: Map<String, int>.from(
            m['riskDistribution'] ?? {'low': 0, 'medium': 0, 'high': 0}),
        commonSymptoms: Map<String, int>.from(m['commonSymptoms'] ?? {}),
        timeline: List<Map<String, dynamic>>.from(m['timeline'] ?? []),
      );
}
