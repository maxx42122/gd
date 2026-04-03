import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/assessment_model.dart';
import '../utils/theme.dart';

class RiskIndicatorCard extends StatelessWidget {
  final Assessment assessment;
  const RiskIndicatorCard({super.key, required this.assessment});

  @override
  Widget build(BuildContext context) {
    final color = assessment.riskColor;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [
            color.withValues(alpha: 0.18),
            AppTheme.kCard,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Column(
        children: [
          // Pulsing icon
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.12),
              border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
            ),
            child: Icon(assessment.riskIcon, color: color, size: 48),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              begin: const Offset(1, 1),
              end: const Offset(1.05, 1.05),
              duration: 1200.ms,
              curve: Curves.easeInOut),
          const SizedBox(height: 16),
          Text(
            assessment.riskLabel,
            style: TextStyle(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _subtitle(assessment.riskLevel),
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppTheme.kTextSecondary, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  String _subtitle(RiskLevel level) {
    switch (level) {
      case RiskLevel.high:
        return 'Urgent attention required.\nDo not delay seeking medical care.';
      case RiskLevel.medium:
        return 'Medical evaluation recommended\nwithin the next 24 hours.';
      case RiskLevel.low:
        return 'Symptoms appear mild.\nMonitor and rest as needed.';
    }
  }
}

class RiskBadge extends StatelessWidget {
  final RiskLevel level;
  final bool large;
  const RiskBadge({super.key, required this.level, this.large = false});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (level) {
      case RiskLevel.high:
        color = AppTheme.kHigh;
        label = 'HIGH';
        break;
      case RiskLevel.medium:
        color = AppTheme.kMedium;
        label = 'MED';
        break;
      case RiskLevel.low:
        color = AppTheme.kLow;
        label = 'LOW';
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: large ? 12 : 8, vertical: large ? 6 : 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: large ? 13 : 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
