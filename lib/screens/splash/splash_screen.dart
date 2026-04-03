import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SplashScreen extends StatefulWidget {
  final bool firebaseReady;
  const SplashScreen({super.key, required this.firebaseReady});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Controllers ────────────────────────────────────────────────────────────
  late final AnimationController _bgCtrl;
  late final AnimationController _logoCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _tagCtrl;
  late final AnimationController _particleCtrl;

  // ── Animations ─────────────────────────────────────────────────────────────
  late final Animation<double> _bgFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoRotate;
  late final Animation<double> _pulse;
  late final Animation<double> _textSlide;
  late final Animation<double> _textFade;
  late final Animation<double> _tagFade;
  late final Animation<double> _tagSlide;
  late final Animation<double> _particle;

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _tagCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _particleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat();

    _bgFade = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeIn);

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut),
    );
    _logoFade =
        CurvedAnimation(parent: _logoCtrl, curve: const Interval(0.0, 0.5));
    _logoRotate = Tween<double>(begin: -0.3, end: 0.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutBack),
    );

    _pulse = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    _textSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic),
    );
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn);

    _tagSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _tagCtrl, curve: Curves.easeOutCubic),
    );
    _tagFade = CurvedAnimation(parent: _tagCtrl, curve: Curves.easeIn);

    _particle = CurvedAnimation(parent: _particleCtrl, curve: Curves.linear);

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _bgCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _tagCtrl.forward();

    // Navigate after splash
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        widget.firebaseReady ? '/auth' : '/home',
      );
    }
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _logoCtrl.dispose();
    _pulseCtrl.dispose();
    _textCtrl.dispose();
    _tagCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.kBg,
      body: FadeTransition(
        opacity: _bgFade,
        child: Stack(
          children: [
            // ── Animated background gradient ──────────────────────────────
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particle,
                builder: (_, __) => CustomPaint(
                  painter: _BackgroundPainter(_particle.value),
                ),
              ),
            ),

            // ── Floating particles ────────────────────────────────────────
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particle,
                builder: (_, __) => CustomPaint(
                  painter: _ParticlePainter(_particle.value),
                ),
              ),
            ),

            // ── Center content ────────────────────────────────────────────
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  AnimatedBuilder(
                    animation: Listenable.merge([_logoCtrl, _pulseCtrl]),
                    builder: (_, __) => Transform.rotate(
                      angle: _logoRotate.value,
                      child: Transform.scale(
                        scale: _logoScale.value * _pulse.value,
                        child: Opacity(
                          opacity: _logoFade.value.clamp(0.0, 1.0),
                          child: _SimplyLogo(size: size.width * 0.32),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // App name
                  AnimatedBuilder(
                    animation: _textCtrl,
                    builder: (_, __) => Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: Opacity(
                        opacity: _textFade.value.clamp(0.0, 1.0),
                        child: _AppNameText(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Tagline
                  AnimatedBuilder(
                    animation: _tagCtrl,
                    builder: (_, __) => Transform.translate(
                      offset: Offset(0, _tagSlide.value),
                      child: Opacity(
                        opacity: _tagFade.value.clamp(0.0, 1.0),
                        child: const _Tagline(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom loader ─────────────────────────────────────────────
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _tagCtrl,
                builder: (_, __) => Opacity(
                  opacity: _tagFade.value.clamp(0.0, 1.0),
                  child: const _BottomLoader(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Logo widget ───────────────────────────────────────────────────────────────

class _SimplyLogo extends StatelessWidget {
  final double size;
  const _SimplyLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.4),
          radius: 0.9,
          colors: [
            Color(0xFF4FC3F7),
            Color(0xFF0288D1),
            Color(0xFF01579B),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0288D1).withValues(alpha: 0.55),
            blurRadius: 40,
            spreadRadius: 4,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF4FC3F7).withValues(alpha: 0.25),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _LogoPainter(),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // ── Heartbeat / pulse line ────────────────────────────────────────────
    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.045
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final y = cy;
    final seg = size.width * 0.09;

    path.moveTo(cx - seg * 3.2, y);
    path.lineTo(cx - seg * 1.8, y);
    path.lineTo(cx - seg * 1.1, y - r * 0.42);
    path.lineTo(cx - seg * 0.4, y + r * 0.38);
    path.lineTo(cx + seg * 0.3, y - r * 0.62);
    path.lineTo(cx + seg * 1.0, y + r * 0.28);
    path.lineTo(cx + seg * 1.5, y);
    path.lineTo(cx + seg * 3.2, y);

    // Clip to circle
    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.82));
    canvas.clipPath(clipPath);
    canvas.drawPath(path, linePaint);

    // ── Small dot at peak ─────────────────────────────────────────────────
    canvas.drawCircle(
      Offset(cx + seg * 0.3, y - r * 0.62),
      size.width * 0.038,
      Paint()
        ..color = const Color(0xFF80DEEA)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawCircle(
      Offset(cx + seg * 0.3, y - r * 0.62),
      size.width * 0.022,
      Paint()..color = Colors.white,
    );

    // ── Specular highlight ────────────────────────────────────────────────
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - r * 0.22, cy - r * 0.30),
        width: r * 0.38,
        height: r * 0.22,
      ),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── App name ──────────────────────────────────────────────────────────────────

class _AppNameText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF80DEEA), Color(0xFF4FC3F7), Color(0xFFE1F5FE)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bounds),
      child: const Text(
        'SimpLY',
        style: TextStyle(
          color: Colors.white,
          fontSize: 52,
          fontWeight: FontWeight.w800,
          letterSpacing: 4,
          height: 1.0,
        ),
      ),
    );
  }
}

// ── Tagline ───────────────────────────────────────────────────────────────────

class _Tagline extends StatelessWidget {
  const _Tagline();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 1,
          color: const Color(0xFF4FC3F7).withValues(alpha: 0.5),
        ),
        const SizedBox(width: 10),
        const Text(
          'AI Health Triage',
          style: TextStyle(
            color: Color(0xFF90CAF9),
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 3.5,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 28,
          height: 1,
          color: const Color(0xFF4FC3F7).withValues(alpha: 0.5),
        ),
      ],
    );
  }
}

// ── Bottom loader ─────────────────────────────────────────────────────────────

class _BottomLoader extends StatelessWidget {
  const _BottomLoader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 120,
          child: LinearProgressIndicator(
            backgroundColor: AppTheme.kBorder,
            valueColor: const AlwaysStoppedAnimation(Color(0xFF4FC3F7)),
            minHeight: 2,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Powered by AI',
          style: TextStyle(
            color: AppTheme.kTextMuted,
            fontSize: 11,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

// ── Background painter ────────────────────────────────────────────────────────

class _BackgroundPainter extends CustomPainter {
  final double t;
  _BackgroundPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Deep dark base
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF060D18),
    );

    // Animated radial glow — top
    final topGlow = RadialGradient(
      center: Alignment(math.sin(t * math.pi * 2) * 0.3, -0.6),
      radius: 0.9,
      colors: [
        const Color(0xFF0D47A1).withValues(alpha: 0.35),
        Colors.transparent,
      ],
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader =
            topGlow.createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    // Animated radial glow — bottom
    final bottomGlow = RadialGradient(
      center: Alignment(math.cos(t * math.pi * 2) * 0.4, 0.8),
      radius: 0.7,
      colors: [
        const Color(0xFF006064).withValues(alpha: 0.25),
        Colors.transparent,
      ],
    );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = bottomGlow
            .createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  @override
  bool shouldRepaint(_BackgroundPainter old) => old.t != t;
}

// ── Particle painter ──────────────────────────────────────────────────────────

class _ParticlePainter extends CustomPainter {
  final double t;
  _ParticlePainter(this.t);

  static final _rng = math.Random(42);
  static final _particles = List.generate(22, (i) => _Particle(_rng, i));

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final progress = (t + p.offset) % 1.0;
      final x = p.x * size.width;
      final y = size.height - progress * (size.height + 40) + 20;
      final alpha = (math.sin(progress * math.pi) * 0.6).clamp(0.0, 1.0);
      final radius = p.radius * (1 + math.sin(progress * math.pi * 2) * 0.3);

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = p.color.withValues(alpha: alpha)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 1.5),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}

class _Particle {
  final double x;
  final double offset;
  final double radius;
  final Color color;

  _Particle(math.Random rng, int seed)
      : x = (seed * 0.047 + rng.nextDouble() * 0.04) % 1.0,
        offset = rng.nextDouble(),
        radius = 1.5 + rng.nextDouble() * 2.5,
        color = [
          const Color(0xFF4FC3F7),
          const Color(0xFF80DEEA),
          const Color(0xFF90CAF9),
          const Color(0xFFB3E5FC),
        ][seed % 4];
}
