import 'package:flutter/material.dart';
import 'muscle_diagnosis.dart';
import 'muscle_group.dart';

class ReportScreen extends StatelessWidget {
  final Set<String> selectedMuscles;
  const ReportScreen({super.key, required this.selectedMuscles});

  @override
  Widget build(BuildContext context) {
    final conditions = getConditionsForMuscles(selectedMuscles);
    final overall = overallImpact(conditions);
    final muscleLabels =
        selectedMuscles.map((id) => muscleById[id]?.label ?? id).toList()
          ..sort();

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white70,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Symptom Analysis Report',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _ImpactBadge(level: overall, large: false),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Overall impact card ──────────────────────────────────────────
          _OverallCard(
            overall: overall,
            muscleLabels: muscleLabels,
            conditionCount: conditions.length,
          ),
          const SizedBox(height: 16),
          // ── Disclaimer ──────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2128),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF30363D)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF58A6FF), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This report is for informational purposes only. Always consult a qualified healthcare professional for diagnosis and treatment.',
                    style: TextStyle(color: Color(0xFF8B949E), fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // ── Condition cards ──────────────────────────────────────────────
          if (conditions.isEmpty)
            const Center(
              child: Text(
                'No conditions mapped for selected muscles.',
                style: TextStyle(color: Colors.white38),
              ),
            )
          else
            ...conditions.asMap().entries.map(
              (e) => _ConditionCard(index: e.key + 1, condition: e.value),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Overall summary card
// ─────────────────────────────────────────────────────────────────────────────
class _OverallCard extends StatelessWidget {
  final ImpactLevel overall;
  final List<String> muscleLabels;
  final int conditionCount;
  const _OverallCard({
    required this.overall,
    required this.muscleLabels,
    required this.conditionCount,
  });

  @override
  Widget build(BuildContext context) {
    final color = _impactColor(overall);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.18), const Color(0xFF161B22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.medical_services_rounded, color: color, size: 22),
              const SizedBox(width: 10),
              const Text(
                'Overall Assessment',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              _ImpactBadge(level: overall, large: true),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatChip(
                icon: Icons.fitness_center,
                label: '${muscleLabels.length} muscles',
                color: const Color(0xFF58A6FF),
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.warning_amber_rounded,
                label: '$conditionCount conditions',
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Affected Areas:',
            style: TextStyle(color: Color(0xFF8B949E), fontSize: 12),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: muscleLabels
                .map(
                  (l) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF21262D),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF30363D)),
                    ),
                    child: Text(
                      l,
                      style: const TextStyle(
                        color: Color(0xFFE6EDF3),
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Individual condition card
// ─────────────────────────────────────────────────────────────────────────────
class _ConditionCard extends StatefulWidget {
  final int index;
  final Condition condition;
  const _ConditionCard({required this.index, required this.condition});

  @override
  State<_ConditionCard> createState() => _ConditionCardState();
}

class _ConditionCardState extends State<_ConditionCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    if (widget.index == 1) {
      _expanded = true;
      _ctrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.condition;
    final color = _impactColor(c.impact);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Column(
        children: [
          // Header — always visible
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: color.withValues(alpha: 0.5)),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.index}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: const TextStyle(
                            color: Color(0xFFE6EDF3),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        _ImpactBadge(level: c.impact, large: false),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 280),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expandable body
          SizeTransition(
            sizeFactor: _anim,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFF30363D), height: 1),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    c.description,
                    style: const TextStyle(
                      color: Color(0xFF8B949E),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Impact meter
                  _ImpactMeter(level: c.impact),
                  const SizedBox(height: 14),
                  // Symptoms
                  _Section(
                    icon: Icons.sick_outlined,
                    title: 'Symptoms',
                    color: const Color(0xFFFF7B72),
                    items: c.symptoms,
                  ),
                  const SizedBox(height: 12),
                  // Cures
                  _Section(
                    icon: Icons.healing_outlined,
                    title: 'Treatment & Cure',
                    color: const Color(0xFF3FB950),
                    items: c.cures,
                  ),
                  const SizedBox(height: 12),
                  // Exercises
                  _Section(
                    icon: Icons.directions_run,
                    title: 'Rehabilitation Exercises',
                    color: const Color(0xFF58A6FF),
                    items: c.exercises,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable widgets
// ─────────────────────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final List<String> items;
  const _Section({
    required this.icon,
    required this.title,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Color(0xFFCDD9E5),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ImpactMeter extends StatelessWidget {
  final ImpactLevel level;
  const _ImpactMeter({required this.level});

  @override
  Widget build(BuildContext context) {
    final segments = [
      (label: 'Low', color: const Color(0xFF3FB950), active: true),
      (
        label: 'Moderate',
        color: const Color(0xFFD29922),
        active: level != ImpactLevel.low,
      ),
      (
        label: 'High',
        color: const Color(0xFFFF7B72),
        active: level == ImpactLevel.high,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Impact Level',
          style: TextStyle(color: Color(0xFF8B949E), fontSize: 12),
        ),
        const SizedBox(height: 6),
        Row(
          children: segments
              .map(
                (s) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    height: 6,
                    decoration: BoxDecoration(
                      color: s.active ? s.color : const Color(0xFF21262D),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 4),
        Row(
          children: segments
              .map(
                (s) => Expanded(
                  child: Text(
                    s.label,
                    style: TextStyle(
                      color: s.active ? s.color : const Color(0xFF30363D),
                      fontSize: 9,
                      fontWeight: s.active
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ImpactBadge extends StatelessWidget {
  final ImpactLevel level;
  final bool large;
  const _ImpactBadge({required this.level, required this.large});

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (level) {
      ImpactLevel.low => (
        'LOW IMPACT',
        const Color(0xFF3FB950),
        Icons.check_circle_outline,
      ),
      ImpactLevel.moderate => (
        'MODERATE IMPACT',
        const Color(0xFFD29922),
        Icons.warning_amber_outlined,
      ),
      ImpactLevel.high => (
        'HIGH IMPACT',
        const Color(0xFFFF7B72),
        Icons.dangerous_outlined,
      ),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 10 : 7,
        vertical: large ? 5 : 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: large ? 13 : 10),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: large ? 11 : 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

Color _impactColor(ImpactLevel level) => switch (level) {
  ImpactLevel.low => const Color(0xFF3FB950),
  ImpactLevel.moderate => const Color(0xFFD29922),
  ImpactLevel.high => const Color(0xFFFF7B72),
};
