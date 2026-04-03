import 'package:flutter/material.dart';
import 'muscle_colors.dart';

class MuscleRegion {
  final String id;
  final Path path;
  MuscleRegion(this.id, this.path);
}

class FrontBodyPainter extends CustomPainter {
  final Set<String> selected;
  final List<MuscleRegion> regions = [];
  FrontBodyPainter({required this.selected});

  String? findRegion(Offset p) {
    for (final r in regions.reversed) {
      if (r.path.contains(p)) return r.id;
    }
    return null;
  }

  void _draw(Canvas c, String id, Path path, Color color) {
    regions.add(MuscleRegion(id, path));
    c.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);
    _fibers(c, path, color);
    if (selected.contains(id)) {
      c.drawPath(path, Paint()..color = const Color(0xBBE53935)..style = PaintingStyle.fill);
      c.drawPath(path, Paint()..color = const Color(0xFFB71C1C)..style = PaintingStyle.stroke..strokeWidth = 2.2);
    }
    c.drawPath(path, Paint()..color = kOutline..style = PaintingStyle.stroke..strokeWidth = 0.85..strokeJoin = StrokeJoin.round);
  }

  void _fibers(Canvas c, Path path, Color base) {
    final b = path.getBounds();
    final p = Paint()
      ..color = Color.lerp(base, Colors.white, 0.28)!.withValues(alpha: 0.32)
      ..strokeWidth = 0.45
      ..style = PaintingStyle.stroke;
    for (double y = b.top + 3; y < b.bottom; y += 4.5) {
      c.drawPath(
        Path.combine(PathOperation.intersect, path, Path()..moveTo(b.left, y)..lineTo(b.right, y)), p);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    regions.clear();
    final w = size.width;
    final h = size.height;

    // HEAD
    final skull = Path()..addOval(Rect.fromCenter(center: Offset(w*.50, h*.058), width: w*.30, height: h*.105));
    _draw(canvas, 'cranium', skull, kSkin);
    final face = Path()
      ..moveTo(w*.375, h*.062)
      ..quadraticBezierTo(w*.365, h*.092, w*.385, h*.112)
      ..quadraticBezierTo(w*.440, h*.128, w*.500, h*.130)
      ..quadraticBezierTo(w*.560, h*.128, w*.615, h*.112)
      ..quadraticBezierTo(w*.635, h*.092, w*.625, h*.062)
      ..quadraticBezierTo(w*.500, h*.048, w*.375, h*.062)..close();
    _draw(canvas, 'face', face, kSkin);
    canvas.drawOval(Rect.fromCenter(center: Offset(w*.458, h*.076), width: w*.042, height: h*.020),
        Paint()..color = const Color(0xFF5C3A1E));
    canvas.drawOval(Rect.fromCenter(center: Offset(w*.542, h*.076), width: w*.042, height: h*.020),
        Paint()..color = const Color(0xFF5C3A1E));
    canvas.drawPath(Path()..moveTo(w*.468, h*.100)..quadraticBezierTo(w*.500, h*.108, w*.532, h*.100),
        Paint()..color = const Color(0xFF8B5E3C)..style = PaintingStyle.stroke..strokeWidth = 1.0);
    for (final ex in [w*.348, w*.652]) {
      canvas.drawOval(Rect.fromCenter(center: Offset(ex, h*.082), width: w*.024, height: h*.040),
          Paint()..color = kSkin);
      canvas.drawOval(Rect.fromCenter(center: Offset(ex, h*.082), width: w*.024, height: h*.040),
          Paint()..color = kOutline..style = PaintingStyle.stroke..strokeWidth = 0.7);
    }

    // NECK
    final neck = Path()
      ..moveTo(w*.435, h*.124)..lineTo(w*.565, h*.124)
      ..lineTo(w*.572, h*.158)..lineTo(w*.428, h*.158)..close();
    _draw(canvas, 'neck', neck, kSkin);
    final scmL = Path()
      ..moveTo(w*.438, h*.126)..quadraticBezierTo(w*.382, h*.136, w*.362, h*.158)
      ..lineTo(w*.390, h*.165)..quadraticBezierTo(w*.408, h*.144, w*.452, h*.132)..close();
    _draw(canvas, 'sternocleidomastoid_l', scmL, kNeck);
    final scmR = Path()
      ..moveTo(w*.562, h*.126)..quadraticBezierTo(w*.618, h*.136, w*.638, h*.158)
      ..lineTo(w*.610, h*.165)..quadraticBezierTo(w*.592, h*.144, w*.548, h*.132)..close();
    _draw(canvas, 'sternocleidomastoid_r', scmR, kNeck);

    // TRAPEZIUS
    final trapL = Path()
      ..moveTo(w*.362, h*.158)..quadraticBezierTo(w*.318, h*.170, w*.285, h*.194)
      ..lineTo(w*.308, h*.202)..quadraticBezierTo(w*.338, h*.180, w*.390, h*.167)..close();
    _draw(canvas, 'trapezius_l', trapL, kTrapezius);
    final trapR = Path()
      ..moveTo(w*.638, h*.158)..quadraticBezierTo(w*.682, h*.170, w*.715, h*.194)
      ..lineTo(w*.692, h*.202)..quadraticBezierTo(w*.662, h*.180, w*.610, h*.167)..close();
    _draw(canvas, 'trapezius_r', trapR, kTrapezius);

    // ANTERIOR DELTOID
    final antDelL = Path()
      ..moveTo(w*.285, h*.194)..quadraticBezierTo(w*.220, h*.202, w*.188, h*.238)
      ..quadraticBezierTo(w*.192, h*.268, w*.215, h*.278)
      ..quadraticBezierTo(w*.248, h*.260, w*.268, h*.234)
      ..quadraticBezierTo(w*.280, h*.214, w*.285, h*.194)..close();
    _draw(canvas, 'anterior_deltoid_l', antDelL, kShoulderAnt);
    final antDelR = Path()
      ..moveTo(w*.715, h*.194)..quadraticBezierTo(w*.780, h*.202, w*.812, h*.238)
      ..quadraticBezierTo(w*.808, h*.268, w*.785, h*.278)
      ..quadraticBezierTo(w*.752, h*.260, w*.732, h*.234)
      ..quadraticBezierTo(w*.720, h*.214, w*.715, h*.194)..close();
    _draw(canvas, 'anterior_deltoid_r', antDelR, kShoulderAnt);
    final medDelL = Path()
      ..moveTo(w*.215, h*.278)..quadraticBezierTo(w*.182, h*.296, w*.178, h*.328)
      ..lineTo(w*.202, h*.334)..quadraticBezierTo(w*.212, h*.306, w*.232, h*.288)..close();
    _draw(canvas, 'medial_deltoid_l', medDelL, kShoulderMed);
    final medDelR = Path()
      ..moveTo(w*.785, h*.278)..quadraticBezierTo(w*.818, h*.296, w*.822, h*.328)
      ..lineTo(w*.798, h*.334)..quadraticBezierTo(w*.788, h*.306, w*.768, h*.288)..close();
    _draw(canvas, 'medial_deltoid_r', medDelR, kShoulderMed);

    // PECTORALIS
    final pecL = Path()
      ..moveTo(w*.285, h*.194)..quadraticBezierTo(w*.355, h*.174, w*.500, h*.178)
      ..lineTo(w*.500, h*.268)..quadraticBezierTo(w*.425, h*.282, w*.345, h*.274)
      ..quadraticBezierTo(w*.295, h*.258, w*.285, h*.230)..close();
    _draw(canvas, 'pectoralis_major_l', pecL, kChest);
    final pecR = Path()
      ..moveTo(w*.715, h*.194)..quadraticBezierTo(w*.645, h*.174, w*.500, h*.178)
      ..lineTo(w*.500, h*.268)..quadraticBezierTo(w*.575, h*.282, w*.655, h*.274)
      ..quadraticBezierTo(w*.705, h*.258, w*.715, h*.230)..close();
    _draw(canvas, 'pectoralis_major_r', pecR, kChest);
    final pecMinL = Path()
      ..moveTo(w*.348, h*.182)..quadraticBezierTo(w*.420, h*.176, w*.490, h*.178)
      ..lineTo(w*.484, h*.218)..quadraticBezierTo(w*.418, h*.224, w*.350, h*.216)..close();
    _draw(canvas, 'pectoralis_minor_l', pecMinL, kChest.withValues(alpha: 0.62));
    final pecMinR = Path()
      ..moveTo(w*.652, h*.182)..quadraticBezierTo(w*.580, h*.176, w*.510, h*.178)
      ..lineTo(w*.516, h*.218)..quadraticBezierTo(w*.582, h*.224, w*.650, h*.216)..close();
    _draw(canvas, 'pectoralis_minor_r', pecMinR, kChest.withValues(alpha: 0.62));
    canvas.drawLine(Offset(w*.500, h*.178), Offset(w*.500, h*.268),
        Paint()..color = kOutline.withValues(alpha: 0.35)..strokeWidth = 0.7);

    // SERRATUS ANTERIOR
    final serL = Path()
      ..moveTo(w*.295, h*.230)..quadraticBezierTo(w*.268, h*.256, w*.272, h*.302)
      ..quadraticBezierTo(w*.286, h*.320, w*.315, h*.318)
      ..quadraticBezierTo(w*.332, h*.290, w*.334, h*.260)..close();
    _draw(canvas, 'serratus_anterior_l', serL, kSerratus);
    final serR = Path()
      ..moveTo(w*.705, h*.230)..quadraticBezierTo(w*.732, h*.256, w*.728, h*.302)
      ..quadraticBezierTo(w*.714, h*.320, w*.685, h*.318)
      ..quadraticBezierTo(w*.668, h*.290, w*.666, h*.260)..close();
    _draw(canvas, 'serratus_anterior_r', serR, kSerratus);

    // RECTUS ABDOMINIS
    final abs = Path()
      ..moveTo(w*.388, h*.268)..quadraticBezierTo(w*.500, h*.258, w*.612, h*.268)
      ..lineTo(w*.602, h*.412)..quadraticBezierTo(w*.500, h*.424, w*.398, h*.412)..close();
    _draw(canvas, 'rectus_abdominis', abs, kAbs);
    for (final yf in [0.298, 0.334, 0.368, 0.400]) {
      canvas.drawLine(Offset(w*.398, h*yf), Offset(w*.602, h*yf),
          Paint()..color = kOutline.withValues(alpha: 0.38)..strokeWidth = 0.65);
    }
    canvas.drawLine(Offset(w*.500, h*.268), Offset(w*.500, h*.412),
        Paint()..color = kOutline.withValues(alpha: 0.38)..strokeWidth = 0.65);

    // EXTERNAL OBLIQUE
    final oblL = Path()
      ..moveTo(w*.315, h*.318)..lineTo(w*.388, h*.268)..lineTo(w*.398, h*.412)
      ..lineTo(w*.355, h*.438)..quadraticBezierTo(w*.305, h*.412, w*.290, h*.368)
      ..quadraticBezierTo(w*.290, h*.338, w*.305, h*.322)..close();
    _draw(canvas, 'external_oblique_l', oblL, kOblique);
    final oblR = Path()
      ..moveTo(w*.685, h*.318)..lineTo(w*.612, h*.268)..lineTo(w*.602, h*.412)
      ..lineTo(w*.645, h*.438)..quadraticBezierTo(w*.695, h*.412, w*.710, h*.368)
      ..quadraticBezierTo(w*.710, h*.338, w*.695, h*.322)..close();
    _draw(canvas, 'external_oblique_r', oblR, kOblique);

    // BICEPS
    final bicL = Path()
      ..moveTo(w*.215, h*.278)..quadraticBezierTo(w*.182, h*.300, w*.175, h*.352)
      ..quadraticBezierTo(w*.180, h*.378, w*.198, h*.384)
      ..quadraticBezierTo(w*.220, h*.364, w*.228, h*.338)
      ..quadraticBezierTo(w*.232, h*.308, w*.232, h*.288)..close();
    _draw(canvas, 'biceps_brachii_l', bicL, kBiceps);
    final bicR = Path()
      ..moveTo(w*.785, h*.278)..quadraticBezierTo(w*.818, h*.300, w*.825, h*.352)
      ..quadraticBezierTo(w*.820, h*.378, w*.802, h*.384)
      ..quadraticBezierTo(w*.780, h*.364, w*.772, h*.338)
      ..quadraticBezierTo(w*.768, h*.308, w*.768, h*.288)..close();
    _draw(canvas, 'biceps_brachii_r', bicR, kBiceps);
    final braL = Path()
      ..moveTo(w*.178, h*.328)..quadraticBezierTo(w*.162, h*.352, w*.162, h*.380)
      ..lineTo(w*.182, h*.386)..quadraticBezierTo(w*.186, h*.360, w*.192, h*.336)..close();
    _draw(canvas, 'brachialis_l', braL, kBrachialis);
    final braR = Path()
      ..moveTo(w*.822, h*.328)..quadraticBezierTo(w*.838, h*.352, w*.838, h*.380)
      ..lineTo(w*.818, h*.386)..quadraticBezierTo(w*.814, h*.360, w*.808, h*.336)..close();
    _draw(canvas, 'brachialis_r', braR, kBrachialis);

    // FOREARM
    final foreFlexL = Path()
      ..moveTo(w*.198, h*.384)..quadraticBezierTo(w*.178, h*.418, w*.182, h*.468)
      ..lineTo(w*.202, h*.472)..quadraticBezierTo(w*.210, h*.424, w*.218, h*.390)..close();
    _draw(canvas, 'flexor_carpi_radialis_l', foreFlexL, kForearmFlex);
    final foreFlexR = Path()
      ..moveTo(w*.802, h*.384)..quadraticBezierTo(w*.822, h*.418, w*.818, h*.468)
      ..lineTo(w*.798, h*.472)..quadraticBezierTo(w*.790, h*.424, w*.782, h*.390)..close();
    _draw(canvas, 'flexor_carpi_radialis_r', foreFlexR, kForearmFlex);
    final brachRadL = Path()
      ..moveTo(w*.175, h*.352)..quadraticBezierTo(w*.158, h*.378, w*.158, h*.420)
      ..lineTo(w*.178, h*.424)..quadraticBezierTo(w*.180, h*.384, w*.182, h*.358)..close();
    _draw(canvas, 'brachioradialis_l', brachRadL, kForearmFlex.withValues(alpha: 0.82));
    final brachRadR = Path()
      ..moveTo(w*.825, h*.352)..quadraticBezierTo(w*.842, h*.378, w*.842, h*.420)
      ..lineTo(w*.822, h*.424)..quadraticBezierTo(w*.820, h*.384, w*.818, h*.358)..close();
    _draw(canvas, 'brachioradialis_r', brachRadR, kForearmFlex.withValues(alpha: 0.82));
    final extCarpiL = Path()
      ..moveTo(w*.162, h*.380)..quadraticBezierTo(w*.145, h*.408, w*.148, h*.455)
      ..lineTo(w*.165, h*.458)..quadraticBezierTo(w*.165, h*.414, w*.175, h*.386)..close();
    _draw(canvas, 'extensor_carpi_ulnaris_l', extCarpiL, kForearmExt);
    final extCarpiR = Path()
      ..moveTo(w*.838, h*.380)..quadraticBezierTo(w*.855, h*.408, w*.852, h*.455)
      ..lineTo(w*.835, h*.458)..quadraticBezierTo(w*.835, h*.414, w*.825, h*.386)..close();
    _draw(canvas, 'extensor_carpi_ulnaris_r', extCarpiR, kForearmExt);
    final handL = Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w*.138, h*.468, w*.072, h*.072), const Radius.circular(8)));
    _draw(canvas, 'wrist_hand_l', handL, kSkin);
    final handR = Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w*.790, h*.468, w*.072, h*.072), const Radius.circular(8)));
    _draw(canvas, 'wrist_hand_r', handR, kSkin);

    // HIP / TFL
    final hipL = Path()
      ..moveTo(w*.355, h*.438)..quadraticBezierTo(w*.335, h*.454, w*.332, h*.478)
      ..lineTo(w*.358, h*.484)..quadraticBezierTo(w*.368, h*.464, w*.375, h*.446)..close();
    _draw(canvas, 'iliopsoas_l', hipL, kIliopsoas);
    final hipR = Path()
      ..moveTo(w*.645, h*.438)..quadraticBezierTo(w*.665, h*.454, w*.668, h*.478)
      ..lineTo(w*.642, h*.484)..quadraticBezierTo(w*.632, h*.464, w*.625, h*.446)..close();
    _draw(canvas, 'iliopsoas_r', hipR, kIliopsoas);
    final tflL = Path()
      ..moveTo(w*.290, h*.368)..quadraticBezierTo(w*.272, h*.392, w*.272, h*.428)
      ..lineTo(w*.298, h*.434)..quadraticBezierTo(w*.300, h*.400, w*.308, h*.376)..close();
    _draw(canvas, 'tensor_fasciae_latae_l', tflL, kTFL);
    final tflR = Path()
      ..moveTo(w*.710, h*.368)..quadraticBezierTo(w*.728, h*.392, w*.728, h*.428)
      ..lineTo(w*.702, h*.434)..quadraticBezierTo(w*.700, h*.400, w*.692, h*.376)..close();
    _draw(canvas, 'tensor_fasciae_latae_r', tflR, kTFL);

    // QUADS
    final vlL = Path()
      ..moveTo(w*.272, h*.428)..quadraticBezierTo(w*.248, h*.458, w*.244, h*.518)
      ..quadraticBezierTo(w*.248, h*.562, w*.268, h*.578)
      ..quadraticBezierTo(w*.298, h*.582, w*.322, h*.572)
      ..quadraticBezierTo(w*.340, h*.548, w*.342, h*.512)
      ..quadraticBezierTo(w*.338, h*.468, w*.325, h*.440)..close();
    _draw(canvas, 'vastus_lateralis_l', vlL, kQuadLat);
    final vlR = Path()
      ..moveTo(w*.728, h*.428)..quadraticBezierTo(w*.752, h*.458, w*.756, h*.518)
      ..quadraticBezierTo(w*.752, h*.562, w*.732, h*.578)
      ..quadraticBezierTo(w*.702, h*.582, w*.678, h*.572)
      ..quadraticBezierTo(w*.660, h*.548, w*.658, h*.512)
      ..quadraticBezierTo(w*.662, h*.468, w*.675, h*.440)..close();
    _draw(canvas, 'vastus_lateralis_r', vlR, kQuadLat);
    final rfL = Path()
      ..moveTo(w*.358, h*.484)..quadraticBezierTo(w*.350, h*.518, w*.350, h*.558)
      ..quadraticBezierTo(w*.352, h*.592, w*.362, h*.608)
      ..quadraticBezierTo(w*.382, h*.604, w*.392, h*.588)
      ..quadraticBezierTo(w*.400, h*.558, w*.398, h*.520)
      ..quadraticBezierTo(w*.394, h*.490, w*.382, h*.480)..close();
    _draw(canvas, 'rectus_femoris_l', rfL, kQuadRect);
    final rfR = Path()
      ..moveTo(w*.642, h*.484)..quadraticBezierTo(w*.650, h*.518, w*.650, h*.558)
      ..quadraticBezierTo(w*.648, h*.592, w*.638, h*.608)
      ..quadraticBezierTo(w*.618, h*.604, w*.608, h*.588)
      ..quadraticBezierTo(w*.600, h*.558, w*.602, h*.520)
      ..quadraticBezierTo(w*.606, h*.490, w*.618, h*.480)..close();
    _draw(canvas, 'rectus_femoris_r', rfR, kQuadRect);
    final vmL = Path()
      ..moveTo(w*.398, h*.520)..quadraticBezierTo(w*.400, h*.558, w*.396, h*.590)
      ..quadraticBezierTo(w*.388, h*.612, w*.372, h*.618)
      ..quadraticBezierTo(w*.350, h*.612, w*.342, h*.596)
      ..quadraticBezierTo(w*.340, h*.572, w*.348, h*.548)
      ..quadraticBezierTo(w*.362, h*.528, w*.380, h*.518)..close();
    _draw(canvas, 'vastus_medialis_l', vmL, kQuadMed);
    final vmR = Path()
      ..moveTo(w*.602, h*.520)..quadraticBezierTo(w*.600, h*.558, w*.604, h*.590)
      ..quadraticBezierTo(w*.612, h*.612, w*.628, h*.618)
      ..quadraticBezierTo(w*.650, h*.612, w*.658, h*.596)
      ..quadraticBezierTo(w*.660, h*.572, w*.652, h*.548)
      ..quadraticBezierTo(w*.638, h*.528, w*.620, h*.518)..close();
    _draw(canvas, 'vastus_medialis_r', vmR, kQuadMed);
    final sarL = Path()
      ..moveTo(w*.332, h*.478)..quadraticBezierTo(w*.328, h*.512, w*.330, h*.552)
      ..quadraticBezierTo(w*.334, h*.588, w*.342, h*.614)
      ..lineTo(w*.352, h*.612)..quadraticBezierTo(w*.344, h*.584, w*.342, h*.550)
      ..quadraticBezierTo(w*.340, h*.512, w*.344, h*.480)..close();
    _draw(canvas, 'sartorius_l', sarL, kSartorius);
    final sarR = Path()
      ..moveTo(w*.668, h*.478)..quadraticBezierTo(w*.672, h*.512, w*.670, h*.552)
      ..quadraticBezierTo(w*.666, h*.588, w*.658, h*.614)
      ..lineTo(w*.648, h*.612)..quadraticBezierTo(w*.656, h*.584, w*.658, h*.550)
      ..quadraticBezierTo(w*.660, h*.512, w*.656, h*.480)..close();
    _draw(canvas, 'sartorius_r', sarR, kSartorius);
    final addL = Path()
      ..moveTo(w*.375, h*.446)..quadraticBezierTo(w*.368, h*.480, w*.368, h*.520)
      ..quadraticBezierTo(w*.370, h*.558, w*.374, h*.590)
      ..lineTo(w*.386, h*.588)..quadraticBezierTo(w*.382, h*.556, w*.382, h*.518)
      ..quadraticBezierTo(w*.382, h*.480, w*.388, h*.448)..close();
    _draw(canvas, 'adductor_longus_l', addL, kAdductor);
    final addR = Path()
      ..moveTo(w*.625, h*.446)..quadraticBezierTo(w*.632, h*.480, w*.632, h*.520)
      ..quadraticBezierTo(w*.630, h*.558, w*.626, h*.590)
      ..lineTo(w*.614, h*.588)..quadraticBezierTo(w*.618, h*.556, w*.618, h*.518)
      ..quadraticBezierTo(w*.618, h*.480, w*.612, h*.448)..close();
    _draw(canvas, 'adductor_longus_r', addR, kAdductor);
    final graL = Path()
      ..moveTo(w*.374, h*.590)..quadraticBezierTo(w*.372, h*.616, w*.374, h*.640)
      ..lineTo(w*.384, h*.640)..quadraticBezierTo(w*.384, h*.616, w*.386, h*.588)..close();
    _draw(canvas, 'gracilis_l', graL, kGracilis);
    final graR = Path()
      ..moveTo(w*.626, h*.590)..quadraticBezierTo(w*.628, h*.616, w*.626, h*.640)
      ..lineTo(w*.616, h*.640)..quadraticBezierTo(w*.616, h*.616, w*.614, h*.588)..close();
    _draw(canvas, 'gracilis_r', graR, kGracilis);
    final patL = Path()..addOval(Rect.fromCenter(
        center: Offset(w*.370, h*.628), width: w*.048, height: h*.030));
    _draw(canvas, 'patella_l', patL, kSkinDark);
    final patR = Path()..addOval(Rect.fromCenter(
        center: Offset(w*.630, h*.628), width: w*.048, height: h*.030));
    _draw(canvas, 'patella_r', patR, kSkinDark);

    // LOWER LEG
    final tibL = Path()
      ..moveTo(w*.348, h*.644)..quadraticBezierTo(w*.338, h*.672, w*.338, h*.710)
      ..quadraticBezierTo(w*.340, h*.742, w*.350, h*.758)
      ..quadraticBezierTo(w*.366, h*.754, w*.372, h*.738)
      ..quadraticBezierTo(w*.376, h*.706, w*.374, h*.670)
      ..quadraticBezierTo(w*.368, h*.648, w*.360, h*.644)..close();
    _draw(canvas, 'tibialis_anterior_l', tibL, kTibialis);
    final tibR = Path()
      ..moveTo(w*.652, h*.644)..quadraticBezierTo(w*.662, h*.672, w*.662, h*.710)
      ..quadraticBezierTo(w*.660, h*.742, w*.650, h*.758)
      ..quadraticBezierTo(w*.634, h*.754, w*.628, h*.738)
      ..quadraticBezierTo(w*.624, h*.706, w*.626, h*.670)
      ..quadraticBezierTo(w*.632, h*.648, w*.640, h*.644)..close();
    _draw(canvas, 'tibialis_anterior_r', tibR, kTibialis);
    final perL = Path()
      ..moveTo(w*.334, h*.646)..quadraticBezierTo(w*.318, h*.676, w*.316, h*.714)
      ..quadraticBezierTo(w*.318, h*.746, w*.330, h*.760)
      ..lineTo(w*.340, h*.758)..quadraticBezierTo(w*.330, h*.744, w*.328, h*.712)
      ..quadraticBezierTo(w*.330, h*.676, w*.344, h*.648)..close();
    _draw(canvas, 'peroneus_longus_l', perL, kPeroneus);
    final perR = Path()
      ..moveTo(w*.666, h*.646)..quadraticBezierTo(w*.682, h*.676, w*.684, h*.714)
      ..quadraticBezierTo(w*.682, h*.746, w*.670, h*.760)
      ..lineTo(w*.660, h*.758)..quadraticBezierTo(w*.670, h*.744, w*.672, h*.712)
      ..quadraticBezierTo(w*.670, h*.676, w*.656, h*.648)..close();
    _draw(canvas, 'peroneus_longus_r', perR, kPeroneus);
    final gastL = Path()
      ..moveTo(w*.374, h*.644)..quadraticBezierTo(w*.382, h*.672, w*.382, h*.710)
      ..quadraticBezierTo(w*.380, h*.742, w*.372, h*.760)
      ..quadraticBezierTo(w*.360, h*.762, w*.354, h*.758)
      ..quadraticBezierTo(w*.360, h*.742, w*.362, h*.710)
      ..quadraticBezierTo(w*.364, h*.674, w*.362, h*.646)..close();
    _draw(canvas, 'gastrocnemius_l', gastL, kGastro);
    final gastR = Path()
      ..moveTo(w*.626, h*.644)..quadraticBezierTo(w*.618, h*.672, w*.618, h*.710)
      ..quadraticBezierTo(w*.620, h*.742, w*.628, h*.760)
      ..quadraticBezierTo(w*.640, h*.762, w*.646, h*.758)
      ..quadraticBezierTo(w*.640, h*.742, w*.638, h*.710)
      ..quadraticBezierTo(w*.636, h*.674, w*.638, h*.646)..close();
    _draw(canvas, 'gastrocnemius_r', gastR, kGastro);
    final solL = Path()
      ..moveTo(w*.352, h*.758)..quadraticBezierTo(w*.346, h*.782, w*.348, h*.808)
      ..quadraticBezierTo(w*.354, h*.822, w*.368, h*.824)
      ..quadraticBezierTo(w*.380, h*.820, w*.384, h*.806)
      ..quadraticBezierTo(w*.386, h*.782, w*.382, h*.760)..close();
    _draw(canvas, 'soleus_l', solL, kSoleus);
    final solR = Path()
      ..moveTo(w*.648, h*.758)..quadraticBezierTo(w*.654, h*.782, w*.652, h*.808)
      ..quadraticBezierTo(w*.646, h*.822, w*.632, h*.824)
      ..quadraticBezierTo(w*.620, h*.820, w*.616, h*.806)
      ..quadraticBezierTo(w*.614, h*.782, w*.618, h*.760)..close();
    _draw(canvas, 'soleus_r', solR, kSoleus);
    final extDigL = Path()
      ..moveTo(w*.374, h*.664)..quadraticBezierTo(w*.384, h*.694, w*.384, h*.730)
      ..lineTo(w*.392, h*.730)..quadraticBezierTo(w*.392, h*.694, w*.384, h*.664)..close();
    _draw(canvas, 'extensor_digitorum_longus_l', extDigL, kExtDigit);
    final extDigR = Path()
      ..moveTo(w*.626, h*.664)..quadraticBezierTo(w*.616, h*.694, w*.616, h*.730)
      ..lineTo(w*.608, h*.730)..quadraticBezierTo(w*.608, h*.694, w*.616, h*.664)..close();
    _draw(canvas, 'extensor_digitorum_longus_r', extDigR, kExtDigit);
    final footL = Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w*.318, h*.824, w*.090, h*.048), const Radius.circular(10)));
    _draw(canvas, 'ankle_foot_l', footL, kFoot);
    final footR = Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w*.592, h*.824, w*.090, h*.048), const Radius.circular(10)));
    _draw(canvas, 'ankle_foot_r', footR, kFoot);
  }

  @override
  bool shouldRepaint(FrontBodyPainter old) => old.selected != selected;
}
