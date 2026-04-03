import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/assessment_model.dart';
import '../../utils/theme.dart';
import '../../widgets/risk_indicator.dart';

class AssessmentResultScreen extends ConsumerStatefulWidget {
  final Assessment assessment;
  const AssessmentResultScreen({super.key, required this.assessment});
  @override
  ConsumerState<AssessmentResultScreen> createState() =>
      _AssessmentResultScreenState();
}

class _AssessmentResultScreenState
    extends ConsumerState<AssessmentResultScreen> {
  int? _answeredIndex;
  String? _selectedAnswer;

  void _share() {
    final a = widget.assessment;
    final text = '''
HealthAI Triage Report
Risk Level: ${a.riskLabel}
Confidence: ${(a.confidence * 100).toStringAsFixed(0)}%
Symptoms: ${a.symptoms.join(', ')}

Guidance: ${a.guidance}

⚠️ This is for informational purposes only. Always consult a healthcare professional.
''';
    Share.share(text);
  }

  Future<void> _callEmergency() async {
    final uri = Uri.parse('tel:911');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _findClinic() async {
    final uri = Uri.parse('https://www.google.com/maps/search/clinic+near+me');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.assessment;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: _share,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Risk indicator hero
            RiskIndicatorCard(assessment: a)
                .animate()
                .scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),

            // Confidence bar
            _ConfidenceCard(confidence: a.confidence, color: a.riskColor)
                .animate()
                .fadeIn(delay: 200.ms),
            const SizedBox(height: 16),

            // Guidance
            _GuidanceCard(assessment: a).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 16),

            // Explanation
            _ExplanationCard(explanation: a.explanation)
                .animate()
                .fadeIn(delay: 400.ms),
            const SizedBox(height: 16),

            // Symptoms summary
            _SymptomsCard(symptoms: a.symptoms, muscleIds: a.muscleIds)
                .animate()
                .fadeIn(delay: 500.ms),

            // Follow-up questions
            if (a.followUpQuestions.isNotEmpty) ...[
              const SizedBox(height: 16),
              _FollowUpCard(
                questions: a.followUpQuestions,
                answeredIndex: _answeredIndex,
                selectedAnswer: _selectedAnswer,
                onAnswer: (i, ans) => setState(() {
                  _answeredIndex = i;
                  _selectedAnswer = ans;
                }),
              ).animate().fadeIn(delay: 600.ms),
            ],

            const SizedBox(height: 24),

            // Action buttons
            if (a.riskLevel == RiskLevel.high)
              _ActionButton(
                icon: Icons.phone_rounded,
                label: 'Call Emergency Services',
                color: AppTheme.kHigh,
                onTap: _callEmergency,
              ).animate().fadeIn(delay: 700.ms),
            const SizedBox(height: 10),
            _ActionButton(
              icon: Icons.location_on_rounded,
              label: 'Find Nearby Clinic',
              color: AppTheme.kAccent,
              outlined: true,
              onTap: _findClinic,
            ).animate().fadeIn(delay: 750.ms),
            const SizedBox(height: 10),
            _ActionButton(
              icon: Icons.home_rounded,
              label: 'Back to Dashboard',
              color: AppTheme.kTextSecondary,
              outlined: true,
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (_) => false),
            ).animate().fadeIn(delay: 800.ms),

            const SizedBox(height: 24),
            // Disclaimer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.kCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.kBorder),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.kAccent, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This report is for informational purposes only. Always consult a qualified healthcare professional.',
                      style:
                          TextStyle(color: AppTheme.kTextMuted, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 850.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _ConfidenceCard extends StatelessWidget {
  final double confidence;
  final Color color;
  const _ConfidenceCard({required this.confidence, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('AI Confidence',
                  style: TextStyle(
                      color: AppTheme.kTextSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              Text(
                '${(confidence * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                    color: color, fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: confidence,
              backgroundColor: AppTheme.kBorder,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  final Assessment assessment;
  const _GuidanceCard({required this.assessment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: assessment.riskColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: assessment.riskColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.health_and_safety_rounded,
                  color: assessment.riskColor, size: 20),
              const SizedBox(width: 8),
              const Text('Recommended Action',
                  style: TextStyle(
                      color: AppTheme.kTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            assessment.guidance,
            style: const TextStyle(
                color: AppTheme.kTextPrimary, fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  final String explanation;
  const _ExplanationCard({required this.explanation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.kAccent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.kAccent.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppTheme.kAccent, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Why this assessment?',
                    style: TextStyle(
                        color: AppTheme.kAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                const SizedBox(height: 6),
                Text(explanation,
                    style: const TextStyle(
                        color: AppTheme.kTextSecondary,
                        fontSize: 13,
                        height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SymptomsCard extends StatelessWidget {
  final List<String> symptoms;
  final List<String> muscleIds;
  const _SymptomsCard({required this.symptoms, required this.muscleIds});

  @override
  Widget build(BuildContext context) {
    if (symptoms.isEmpty && muscleIds.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reported Symptoms',
              style: TextStyle(
                  color: AppTheme.kTextPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              ...symptoms.map((s) => _tag(s, AppTheme.kAccent)),
              if (muscleIds.isNotEmpty)
                _tag(
                    '${muscleIds.length} muscle area${muscleIds.length > 1 ? "s" : ""}',
                    AppTheme.kAccentOrange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tag(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(label,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.w500)),
      );
}

class _FollowUpCard extends StatelessWidget {
  final List<FollowUpQuestion> questions;
  final int? answeredIndex;
  final String? selectedAnswer;
  final void Function(int, String) onAnswer;

  const _FollowUpCard({
    required this.questions,
    required this.answeredIndex,
    required this.selectedAnswer,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.kCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.quiz_rounded, color: AppTheme.kAccentOrange, size: 18),
              SizedBox(width: 8),
              Text('Follow-up Questions',
                  style: TextStyle(
                      color: AppTheme.kTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          ...questions.indexed.map((entry) {
            final i = entry.$1;
            final q = entry.$2;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${i + 1}. ${q.question}',
                      style: const TextStyle(
                          color: AppTheme.kTextSecondary, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: q.options.map((opt) {
                      final sel = answeredIndex == i && selectedAnswer == opt;
                      return GestureDetector(
                        onTap: () => onAnswer(i, opt),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppTheme.kAccent.withValues(alpha: 0.2)
                                : AppTheme.kSurface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: sel ? AppTheme.kAccent : AppTheme.kBorder,
                            ),
                          ),
                          child: Text(opt,
                              style: TextStyle(
                                  color: sel
                                      ? AppTheme.kAccent
                                      : AppTheme.kTextSecondary,
                                  fontSize: 12,
                                  fontWeight: sel
                                      ? FontWeight.w600
                                      : FontWeight.normal)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool outlined;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: outlined
          ? OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18),
              label: Text(label),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
    );
  }
}
