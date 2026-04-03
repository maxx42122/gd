import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/user_model.dart';
import '../../providers/providers.dart';
import '../../services/voice_service.dart';
import '../../utils/theme.dart';
import '../assessment_result/assessment_result_screen.dart';

class SymptomInputScreen extends ConsumerStatefulWidget {
  final Set<String> muscleIds;
  const SymptomInputScreen({super.key, this.muscleIds = const {}});
  @override
  ConsumerState<SymptomInputScreen> createState() => _SymptomInputScreenState();
}

class _SymptomInputScreenState extends ConsumerState<SymptomInputScreen> {
  final _ctrl = TextEditingController();
  final List<String> _selected = [];
  bool _analyzing = false;
  bool _isListening = false;
  String _partial = '';
  String? _voiceError;

  static const _common = [
    ('Fever', Icons.thermostat_rounded),
    ('Cough', Icons.air_rounded),
    ('Headache', Icons.psychology_rounded),
    ('Fatigue', Icons.battery_0_bar_rounded),
    ('Sore Throat', Icons.mic_off_rounded),
    ('Nausea', Icons.sick_rounded),
    ('Chest Pain', Icons.favorite_border_rounded),
    ('Shortness of Breath', Icons.air_rounded),
    ('Back Pain', Icons.accessibility_new_rounded),
    ('Joint Pain', Icons.sports_gymnastics_rounded),
    ('Dizziness', Icons.rotate_right_rounded),
    ('Vomiting', Icons.warning_amber_rounded),
    ('Abdominal Pain', Icons.medical_services_outlined),
    ('Muscle Pain', Icons.fitness_center_rounded),
    ('Runny Nose', Icons.water_drop_rounded),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    // Cancel any active session when leaving screen
    ref.read(voiceServiceProvider).cancel();
    super.dispose();
  }

  void _add(String s) {
    final v = s.trim();
    if (v.isNotEmpty && !_selected.contains(v)) {
      setState(() => _selected.add(v));
    }
  }

  void _remove(String s) => setState(() => _selected.remove(s));

  // ── Voice ──────────────────────────────────────────────────────────────────

  Future<void> _toggleVoice() async {
    final voice = ref.read(voiceServiceProvider);

    if (_isListening) {
      await voice.stop();
      setState(() {
        _isListening = false;
        _partial = '';
      });
      return;
    }

    setState(() {
      _isListening = true;
      _partial = '';
      _voiceError = null;
    });

    final result = await voice.startListening(
      onPartial: (text) {
        if (mounted) setState(() => _partial = text);
      },
      onFinal: (text) {
        if (mounted && text.isNotEmpty) {
          setState(() {
            _partial = '';
          });
          _parseVoice(text);
        }
      },
      onError: (err) {
        if (mounted) {
          setState(() {
            _isListening = false;
            _partial = '';
            _voiceError = err;
          });
        }
      },
      onDone: () {
        if (mounted) {
          setState(() {
            _isListening = false;
            _partial = '';
          });
        }
      },
    );

    if (!mounted) return;
    switch (result) {
      case VoiceStartResult.started:
        break; // all good — callbacks handle the rest
      case VoiceStartResult.denied:
        setState(() {
          _isListening = false;
          _voiceError = 'Microphone permission denied. Tap to try again.';
        });
      case VoiceStartResult.permanentlyDenied:
        setState(() {
          _isListening = false;
          _voiceError = 'Microphone blocked. Enable it in App Settings.';
        });
        // Offer to open settings
        _showPermissionDialog();
      case VoiceStartResult.unavailable:
        setState(() {
          _isListening = false;
          _voiceError = 'Speech recognition not available on this device.';
        });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.kCard,
        title: const Text('Microphone Permission',
            style: TextStyle(color: AppTheme.kTextPrimary)),
        content: const Text(
          'Microphone access is permanently denied.\n\nGo to App Settings → Permissions → Microphone and enable it.',
          style: TextStyle(color: AppTheme.kTextSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.kTextSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings(); // from permission_handler
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _parseVoice(String input) {
    final lower = input.toLowerCase();
    bool matched = false;

    for (final (name, _) in _common) {
      if (lower.contains(name.toLowerCase()) && !_selected.contains(name)) {
        setState(() => _selected.add(name));
        matched = true;
      }
    }

    // If nothing from the quick list matched, add the raw spoken text as-is
    if (!matched) {
      // Capitalise first letter and add
      final cleaned = input.trim();
      if (cleaned.isNotEmpty) {
        _add(cleaned[0].toUpperCase() + cleaned.substring(1));
      }
    }

    // Show a snack so the user knows what was captured
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Heard: "$input"'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.kCard,
      ),
    );
  }

  // ── Analyze ────────────────────────────────────────────────────────────────

  Future<void> _analyze() async {
    if (_selected.isEmpty && widget.muscleIds.isEmpty) return;
    setState(() => _analyzing = true);

    try {
      final profile = ref.read(userProfileProvider) ??
          UserProfile.empty(ref.read(authStateProvider).value?.uid ?? 'guest');

      final assessment = await ref.read(assessmentsProvider.notifier).analyze(
            symptoms: List.from(_selected),
            muscleIds: widget.muscleIds.toList(),
            profile: profile,
            ai: ref.read(aiServiceProvider),
          );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AssessmentResultScreen(assessment: assessment),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _analyzing = false);
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Describe Symptoms'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Muscle context banner
            if (widget.muscleIds.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.kAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.kAccent.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.accessibility_new_rounded,
                        color: AppTheme.kAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${widget.muscleIds.length} muscle area${widget.muscleIds.length > 1 ? "s" : ""} selected from body map',
                        style: const TextStyle(
                            color: AppTheme.kAccent, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),

            // Voice card
            _VoiceCard(
              isListening: _isListening,
              partial: _partial,
              error: _voiceError,
              onTap: _toggleVoice,
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 16),

            // Text input row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    style: const TextStyle(color: AppTheme.kTextPrimary),
                    decoration: const InputDecoration(
                      hintText: 'Type a symptom and press +',
                      prefixIcon: Icon(Icons.edit_outlined,
                          color: AppTheme.kTextSecondary),
                    ),
                    onSubmitted: (v) {
                      _add(v);
                      _ctrl.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    _add(_ctrl.text);
                    _ctrl.clear();
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.kAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add_rounded, color: Colors.white),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 24),

            // Common symptoms chips
            Text('Common Symptoms',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600))
                .animate()
                .fadeIn(delay: 200.ms),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _common.indexed.map((entry) {
                final i = entry.$1;
                final (name, icon) = entry.$2;
                final sel = _selected.contains(name);
                return FilterChip(
                  avatar: Icon(icon,
                      size: 14,
                      color: sel ? AppTheme.kAccent : AppTheme.kTextSecondary),
                  label: Text(name),
                  selected: sel,
                  onSelected: (v) => v ? _add(name) : _remove(name),
                  selectedColor: AppTheme.kAccent.withValues(alpha: 0.15),
                  checkmarkColor: AppTheme.kAccent,
                  labelStyle: TextStyle(
                    color: sel ? AppTheme.kAccent : AppTheme.kTextPrimary,
                    fontSize: 12,
                  ),
                  side: BorderSide(
                      color: sel ? AppTheme.kAccent : AppTheme.kBorder),
                ).animate().fadeIn(delay: Duration(milliseconds: 220 + i * 20));
              }).toList(),
            ),

            // Selected symptoms
            if (_selected.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Selected (${_selected.length})',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  TextButton(
                    onPressed: () => setState(() => _selected.clear()),
                    child: const Text('Clear all',
                        style: TextStyle(color: AppTheme.kHigh, fontSize: 12)),
                  ),
                ],
              ),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _selected
                    .map((s) => Chip(
                          label: Text(s,
                              style: const TextStyle(
                                  color: AppTheme.kTextPrimary, fontSize: 12)),
                          deleteIcon: const Icon(Icons.close,
                              size: 14, color: AppTheme.kTextSecondary),
                          onDeleted: () => _remove(s),
                          backgroundColor:
                              AppTheme.kAccent.withValues(alpha: 0.1),
                          side: BorderSide(
                              color: AppTheme.kAccent.withValues(alpha: 0.4)),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 32),

            // Analyze button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: (_selected.isEmpty && widget.muscleIds.isEmpty) ||
                        _analyzing
                    ? null
                    : _analyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.kAccentGreen,
                  disabledBackgroundColor: AppTheme.kCard,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _analyzing
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.analytics_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Analyze Symptoms${_selected.isNotEmpty ? " (${_selected.length})" : ""}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Voice card widget ─────────────────────────────────────────────────────────

class _VoiceCard extends StatelessWidget {
  final bool isListening;
  final String partial;
  final String? error;
  final VoidCallback onTap;

  const _VoiceCard({
    required this.isListening,
    required this.partial,
    required this.onTap,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isListening
              ? [const Color(0xFF1F3A5F), const Color(0xFF0D2137)]
              : error != null
                  ? [
                      AppTheme.kHigh.withValues(alpha: 0.08),
                      AppTheme.kCard,
                    ]
                  : [AppTheme.kCard, AppTheme.kSurface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isListening
              ? AppTheme.kAccent.withValues(alpha: 0.5)
              : error != null
                  ? AppTheme.kHigh.withValues(alpha: 0.4)
                  : AppTheme.kBorder,
          width: isListening ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Mic button with glow
              AvatarGlow(
                animate: isListening,
                glowColor: AppTheme.kAccent,
                glowRadiusFactor: 0.35,
                child: GestureDetector(
                  onTap: onTap,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isListening
                          ? AppTheme.kAccent
                          : error != null
                              ? AppTheme.kHigh.withValues(alpha: 0.15)
                              : AppTheme.kAccent.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                      boxShadow: isListening
                          ? [
                              BoxShadow(
                                color: AppTheme.kAccent.withValues(alpha: 0.4),
                                blurRadius: 16,
                                spreadRadius: 2,
                              )
                            ]
                          : [],
                    ),
                    child: Icon(
                      isListening
                          ? Icons.mic_rounded
                          : error != null
                              ? Icons.mic_off_rounded
                              : Icons.mic_none_rounded,
                      color: isListening
                          ? Colors.white
                          : error != null
                              ? AppTheme.kHigh
                              : AppTheme.kAccent,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isListening
                          ? 'Listening...'
                          : error != null
                              ? 'Microphone error'
                              : 'Tap to speak',
                      style: TextStyle(
                        color: isListening
                            ? AppTheme.kAccent
                            : error != null
                                ? AppTheme.kHigh
                                : AppTheme.kTextPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isListening && partial.isNotEmpty
                          ? partial
                          : error != null
                              ? error!
                              : 'Say symptoms like "fever and headache"',
                      style: TextStyle(
                        color: error != null
                            ? AppTheme.kHigh.withValues(alpha: 0.8)
                            : AppTheme.kTextSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Stop button when listening
              if (isListening)
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.kHigh.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppTheme.kHigh.withValues(alpha: 0.3)),
                    ),
                    child: const Text(
                      'Stop',
                      style: TextStyle(
                          color: AppTheme.kHigh,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
          // Live waveform bars when listening
          if (isListening) ...[
            const SizedBox(height: 14),
            _WaveformBars(),
          ],
        ],
      ),
    );
  }
}

// ── Animated waveform ─────────────────────────────────────────────────────────

class _WaveformBars extends StatefulWidget {
  @override
  State<_WaveformBars> createState() => _WaveformBarsState();
}

class _WaveformBarsState extends State<_WaveformBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const barCount = 20;
    const heights = [
      8.0,
      16.0,
      24.0,
      18.0,
      30.0,
      14.0,
      26.0,
      20.0,
      32.0,
      12.0,
      28.0,
      16.0,
      22.0,
      30.0,
      10.0,
      24.0,
      18.0,
      28.0,
      14.0,
      8.0,
    ];

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(barCount, (i) {
            final phase = (i / barCount + _ctrl.value) % 1.0;
            final scale = 0.4 + 0.6 * (0.5 + 0.5 * (phase * 2 - 1).abs());
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width: 3,
              height: heights[i] * scale,
              decoration: BoxDecoration(
                color: AppTheme.kAccent.withValues(alpha: 0.6 + 0.4 * scale),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}
