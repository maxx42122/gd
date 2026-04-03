import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/assessment_model.dart';
import '../../providers/providers.dart';
import '../../utils/theme.dart';
import '../../widgets/risk_indicator.dart';
import '../assessment_result/assessment_result_screen.dart';
import '../symptom_input/symptom_input_screen.dart';
import '../../body_selector.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trends = ref.watch(healthTrendsProvider);
    final assessments = ref.watch(assessmentsProvider);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('HealthAI Triage',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            if (profile != null && profile.name.isNotEmpty)
              Text('Hi, ${profile.name}',
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.kTextSecondary,
                      fontWeight: FontWeight.normal)),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.kAccent,
        backgroundColor: AppTheme.kCard,
        onRefresh: () async {
          ref.read(assessmentsProvider.notifier).refresh();
          await ref.read(assessmentsProvider.notifier).syncPending();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Quick stats
              _QuickStats(trends: trends).animate().fadeIn(),
              const SizedBox(height: 20),

              // Start assessment CTA
              _AssessmentCTA(
                onBodyMap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BodySelectorScreen()),
                ),
                onSymptoms: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SymptomInputScreen()),
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 20),

              // Risk distribution chart
              if (trends.totalAssessments > 0) ...[
                _RiskChart(trends: trends).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 20),
              ],

              // Recent assessments
              if (assessments.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Assessments',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/history'),
                      child: const Text('See all',
                          style:
                              TextStyle(color: AppTheme.kAccent, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...assessments.take(5).indexed.map((entry) {
                  final i = entry.$1;
                  final a = entry.$2;
                  return _AssessmentTile(assessment: a)
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 300 + i * 60))
                      .slideX(begin: 0.05);
                }),
              ] else ...[
                _EmptyState().animate().fadeIn(delay: 200.ms),
              ],
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick Stats ───────────────────────────────────────────────────────────────

class _QuickStats extends StatelessWidget {
  final HealthTrends trends;
  const _QuickStats({required this.trends});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _StatCard(
          label: 'Total Checks',
          value: '${trends.totalAssessments}',
          icon: Icons.assessment_rounded,
          color: AppTheme.kAccent,
        )),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(
          label: 'This Month',
          value: '${trends.monthlyCount}',
          icon: Icons.calendar_today_rounded,
          color: AppTheme.kAccentGreen,
        )),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(
          label: 'High Risk',
          value: '${trends.riskDistribution['high'] ?? 0}',
          icon: Icons.warning_rounded,
          color: AppTheme.kHigh,
        )),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 24, fontWeight: FontWeight.w800)),
          Text(label,
              style: const TextStyle(
                  color: AppTheme.kTextSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}

// ── Assessment CTA ────────────────────────────────────────────────────────────

class _AssessmentCTA extends StatelessWidget {
  final VoidCallback onBodyMap;
  final VoidCallback onSymptoms;
  const _AssessmentCTA({required this.onBodyMap, required this.onSymptoms});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F3A5F), Color(0xFF0D2137)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.kAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Start New Assessment',
              style: TextStyle(
                  color: AppTheme.kTextPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16)),
          const SizedBox(height: 4),
          const Text('Choose how to describe your symptoms',
              style: TextStyle(color: AppTheme.kTextSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _CTAButton(
                  icon: Icons.accessibility_new_rounded,
                  label: 'Body Map',
                  subtitle: 'Tap muscles',
                  color: AppTheme.kAccent,
                  onTap: onBodyMap,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CTAButton(
                  icon: Icons.edit_note_rounded,
                  label: 'Symptoms',
                  subtitle: 'Type or speak',
                  color: AppTheme.kAccentGreen,
                  onTap: onSymptoms,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CTAButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _CTAButton(
      {required this.icon,
      required this.label,
      required this.subtitle,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                Text(subtitle,
                    style: const TextStyle(
                        color: AppTheme.kTextMuted, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Risk Chart ────────────────────────────────────────────────────────────────

class _RiskChart extends StatefulWidget {
  final HealthTrends trends;
  const _RiskChart({required this.trends});
  @override
  State<_RiskChart> createState() => _RiskChartState();
}

class _RiskChartState extends State<_RiskChart> {
  int _touched = -1;

  @override
  Widget build(BuildContext context) {
    final dist = widget.trends.riskDistribution;
    final low = (dist['low'] ?? 0).toDouble();
    final med = (dist['medium'] ?? 0).toDouble();
    final high = (dist['high'] ?? 0).toDouble();
    final total = low + med + high;
    if (total == 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.kCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Risk Distribution',
              style: TextStyle(
                  color: AppTheme.kTextPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 15)),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                height: 160,
                width: 160,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (e, r) => setState(() => _touched =
                          r?.touchedSection?.touchedSectionIndex ?? -1),
                    ),
                    sectionsSpace: 3,
                    centerSpaceRadius: 40,
                    sections: [
                      _section(low, AppTheme.kLow, 'Low', 0),
                      _section(med, AppTheme.kMedium, 'Med', 1),
                      _section(high, AppTheme.kHigh, 'High', 2),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legend(AppTheme.kLow, 'Low Risk', low.toInt()),
                    const SizedBox(height: 10),
                    _legend(AppTheme.kMedium, 'Medium Risk', med.toInt()),
                    const SizedBox(height: 10),
                    _legend(AppTheme.kHigh, 'High Risk', high.toInt()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  PieChartSectionData _section(double val, Color color, String title, int i) {
    final isTouched = i == _touched;
    return PieChartSectionData(
      value: val,
      color: color,
      radius: isTouched ? 60 : 50,
      title: val > 0 ? '${val.toInt()}' : '',
      titleStyle: const TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
    );
  }

  Widget _legend(Color color, String label, int count) => Row(
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: AppTheme.kTextSecondary, fontSize: 12))),
          Text('$count',
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      );
}

// ── Assessment Tile ───────────────────────────────────────────────────────────

class _AssessmentTile extends StatelessWidget {
  final Assessment assessment;
  const _AssessmentTile({required this.assessment});

  @override
  Widget build(BuildContext context) {
    final a = assessment;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AssessmentResultScreen(assessment: a)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.kCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.kBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: a.riskColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(a.riskIcon, color: a.riskColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.symptoms.isNotEmpty
                        ? a.symptoms.take(3).join(', ')
                        : '${a.muscleIds.length} muscle areas',
                    style: const TextStyle(
                        color: AppTheme.kTextPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    DateFormat('MMM d, yyyy · h:mm a').format(a.timestamp),
                    style: const TextStyle(
                        color: AppTheme.kTextMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
            RiskBadge(level: a.riskLevel),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                color: AppTheme.kTextMuted, size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.kAccent.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.health_and_safety_outlined,
                color: AppTheme.kAccent, size: 40),
          ),
          const SizedBox(height: 16),
          const Text('No assessments yet',
              style: TextStyle(
                  color: AppTheme.kTextPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
          const SizedBox(height: 8),
          const Text(
            'Start your first symptom assessment\nusing the body map or symptom input.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.kTextSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
