import 'package:flutter/material.dart';

// ── Skin ──────────────────────────────────────────────────────────────────────
const kSkin = Color(0xFFE8C49A);
const kSkinDark = Color(0xFFD4A574);
const kSkinLight = Color(0xFFF5DEB3);
const kOutline = Color(0xFF1A0800);

// ── Muscle base colors (mid-tone) ─────────────────────────────────────────────
const kNeck = Color(0xFFCD853F);
const kTrapezius = Color(0xFFB8732A);
const kChest = Color(0xFFCC5500);
const kShoulderAnt = Color(0xFFE8622A);
const kShoulderMed = Color(0xFFD44A18);
const kShoulderPost = Color(0xFFBB3A08);
const kBiceps = Color(0xFFCC5500);
const kBrachialis = Color(0xFFA07820);
const kForearmFlex = Color(0xFFDD3300);
const kForearmExt = Color(0xFF1A7A1A);
const kSerratus = Color(0xFFCC44CC);
const kAbs = Color(0xFF7722BB);
const kOblique = Color(0xFF660088);
const kIliopsoas = Color(0xFF5500AA);
const kTFL = Color(0xFF2244CC);
const kQuadRect = Color(0xFF5544BB);
const kQuadLat = Color(0xFF332288);
const kQuadMed = Color(0xFF6655CC);
const kSartorius = Color(0xFF119999);
const kAdductor = Color(0xFF007777);
const kGracilis = Color(0xFF226644);
const kTibialis = Color(0xFF228844);
const kPeroneus = Color(0xFF009999);
const kGastro = Color(0xFF006666);
const kSoleus = Color(0xFF119988);
const kExtDigit = Color(0xFF22AA22);
const kFoot = Color(0xFFE8C49A);

// Back
const kTrapsUpper = Color(0xFFB8732A);
const kTrapsMid = Color(0xFF9A6020);
const kTrapsLower = Color(0xFF7A4A10);
const kRhomboid = Color(0xFF883300);
const kInfraspin = Color(0xFFCC44CC);
const kTeresMaj = Color(0xFFFF5599);
const kTeresMin = Color(0xFFDD1177);
const kLat = Color(0xFFCC5500);
const kErector = Color(0xFFCCAA66);
const kTricepsLong = Color(0xFFEE4422);
const kTricepsLat = Color(0xFFDD3300);
const kTricepsMed = Color(0xFFBB1100);
const kGlutMax = Color(0xFF5544BB);
const kGlutMed = Color(0xFF332288);
const kHamBicep = Color(0xFF007777);
const kSemiTend = Color(0xFF119999);
const kSemiMemb = Color(0xFF226644);
const kITBand = Color(0xFF2244CC);
const kGastroMed = Color(0xFF006666);
const kGastroLat = Color(0xFF119988);
const kSoleusBack = Color(0xFF228844);
const kAchilles = Color(0xFFCCAA66);

// ── 3D shading helpers ────────────────────────────────────────────────────────

/// Returns a radial gradient that simulates a convex muscle belly
/// [center] is the highlight focal point (0.0–1.0 relative to bounds)
/// Light comes from top-left
RadialGradient muscleGradient(
  Color base, {
  Alignment highlight = const Alignment(-0.3, -0.4),
}) {
  final light = Color.lerp(base, Colors.white, 0.55)!;
  final mid = Color.lerp(base, Colors.white, 0.12)!;
  final shadow = Color.lerp(base, Colors.black, 0.42)!;
  final deep = Color.lerp(base, Colors.black, 0.62)!;
  return RadialGradient(
    center: highlight,
    radius: 0.85,
    colors: [light, mid, base, shadow, deep],
    stops: const [0.0, 0.22, 0.52, 0.78, 1.0],
  );
}

/// Ambient occlusion paint — dark edge vignette
Paint aoPaint(Rect bounds) {
  return Paint()
    ..shader = RadialGradient(
      center: Alignment.center,
      radius: 0.7,
      colors: [Colors.transparent, Colors.black.withValues(alpha: 0.28)],
      stops: const [0.55, 1.0],
    ).createShader(bounds)
    ..style = PaintingStyle.fill;
}

/// Specular highlight — small bright oval at top-left of muscle
void drawSpecular(Canvas c, Rect bounds) {
  final cx = bounds.left + bounds.width * 0.28;
  final cy = bounds.top + bounds.height * 0.22;
  final rw = bounds.width * 0.18;
  final rh = bounds.height * 0.12;
  c.drawOval(
    Rect.fromCenter(center: Offset(cx, cy), width: rw, height: rh),
    Paint()
      ..color = Colors.white.withValues(alpha: 0.38)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
  );
}

/// Cast shadow below a path
void drawDropShadow(Canvas c, Path path, {double blur = 5, double dy = 3}) {
  c.drawPath(
    path.shift(Offset(2, dy)),
    Paint()
      ..color = Colors.black.withValues(alpha: 0.22)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur)
      ..style = PaintingStyle.fill,
  );
}
