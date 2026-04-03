import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/assessment_model.dart';
import '../../providers/providers.dart';
import '../../utils/theme.dart';
import '../../widgets/risk_indicator.dart';
import '../assessment_result/assessment_result_screen.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});
  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  RiskLevel? _filter;

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(assessmentsProvider);
    final filtered = _filter == null
        ? all
        : all.where((a) => a.riskLevel == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            color: AppTheme.kSurface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _filterChip(null, 'All', all.length),
                const SizedBox(width: 8),
                _filterChip(RiskLevel.high, 'High',
                    all.where((a) => a.riskLevel == RiskLevel.high).length),
                const SizedBox(width: 8),
                _filterChip(RiskLevel.medium, 'Medium',
                    all.where((a) => a.riskLevel == RiskLevel.medium).length),
                const SizedBox(width: 8),
                _filterChip(RiskLevel.low, 'Low',
                    all.where((a) => a.riskLevel == RiskLevel.low).length),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No assessments found',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) => _HistoryCard(
                      assessment: filtered[i],
                      onDelete: () => _delete(filtered[i].id),
                    )
                        .animate()
                        .fadeIn(delay: Duration(milliseconds: i * 40))
                        .slideX(begin: 0.05),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(RiskLevel? level, String label, int count) {
    final active = _filter == level;
    Color color;
    switch (level) {
      case RiskLevel.high:
        color = AppTheme.kHigh;
        break;
      case RiskLevel.medium:
        color = AppTheme.kMedium;
        break;
      case RiskLevel.low:
        color = AppTheme.kLow;
        break;
      default:
        color = AppTheme.kAccent;
    }
    return GestureDetector(
      onTap: () => setState(() => _filter = level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? color.withValues(alpha: 0.15) : AppTheme.kCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? color : AppTheme.kBorder),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            color: active ? color : AppTheme.kTextSecondary,
            fontSize: 12,
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Future<void> _delete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.kCard,
        title: const Text('Delete Assessment',
            style: TextStyle(color: AppTheme.kTextPrimary)),
        content: const Text('This cannot be undone.',
            style: TextStyle(color: AppTheme.kTextSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete',
                  style: TextStyle(color: AppTheme.kHigh))),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(localStorageProvider).deleteAssessment(id);
      ref.read(assessmentsProvider.notifier).refresh();
    }
  }
}

class _HistoryCard extends StatelessWidget {
  final Assessment assessment;
  final VoidCallback onDelete;
  const _HistoryCard({required this.assessment, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final a = assessment;
    return Dismissible(
      key: Key(a.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppTheme.kHigh.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppTheme.kHigh),
      ),
      confirmDismiss: (_) async {
        onDelete();
        return false;
      },
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AssessmentResultScreen(assessment: a)),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.kCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.kBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: a.riskColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(a.riskIcon, color: a.riskColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.symptoms.isNotEmpty
                          ? a.symptoms.join(', ')
                          : '${a.muscleIds.length} muscle areas',
                      style: const TextStyle(
                          color: AppTheme.kTextPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, MMM d · h:mm a').format(a.timestamp),
                      style: const TextStyle(
                          color: AppTheme.kTextMuted, fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      a.guidance,
                      style: const TextStyle(
                          color: AppTheme.kTextSecondary, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RiskBadge(level: a.riskLevel),
                  const SizedBox(height: 6),
                  Text(
                    '${(a.confidence * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                        color: AppTheme.kTextMuted, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
