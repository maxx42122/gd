import 'package:flutter/material.dart';
import 'muscle_colors.dart';
import 'front_painter.dart';

class BackBodyPainter extends CustomPainter {
  final Set<String> selected;
  final List<MuscleRegion> regions = [];
  BackBodyPainter({required this.selected});

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
      ..strokeWidth = 0.45..style = PaintingStyle.stroke;
    for (double y = b.top + 3; y < b.bottom; y += 4.5) {
      c.drawPath(Path.combine(PathOperation.intersect, path,
          Path()..moveTo(b.left, y)..lineTo(b.right, y)), p);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    regions.clear();
    final w = size.width;
    final h = size.height;

    // HEAD (back)
    final skull = Path()..addOval(Rect.fromCenter(center: Offset(w*.50, h*.058), width: w*.30, height: h*.105));
    _draw(canvas, 'cranium_back', skull, kSkin);
    // Ears
    for (final ex in [w*.348, w*.652]) {
      canvas.drawOval(Rect.fromCenter(center: Offset(ex, h*.082), width: w*.024, height: h*.040),
          Paint()..color = kSkin);
      canvas.drawOval(Rect.fromCenter(center: Offset(ex, h*.082), width: w*.024, height: h*.040),
          Paint()..color = kOutline..style = PaintingStyle.stroke..strokeWidth = 0.7);
    }
    // Neck
    final neck = Path()
      ..moveTo(w*.435, h*.124)..lineTo(w*.565, h*.124)
      ..lineTo(w*.572, h*.158)..lineTo(w*.428, h*.158)..close();
    _draw(canvas, 'neck_back', neck, kSkin);

    // UPPER TRAPEZIUS — wide diamond from neck to shoulders
    final upperTrap = Path()
      ..moveTo(w*.435, h*.126)..lineTo(w*.565, h*.126)
      ..quadraticBezierTo(w*.660, h*.144, w*.715, h*.194)
      ..quadraticBezierTo(w*.678, h*.210, w*.610, h*.218)
      ..lineTo(w*.500, h*.224)..lineTo(w*.390, h*.218)
      ..quadraticBezierTo(w*.322, h*.210, w*.285, h*.194)
      ..quadraticBezierTo(w*.340, h*.144, w*.435, h*.126)..close();
    _draw(canvas, 'upper_trapezius', upperTrap, kTrapsUpper);
    // Middle trapezius
    final midTrap = Path()
      ..moveTo(w*.285, h*.194)..quadraticBezierTo(w*.322, h*.210, w*.390, h*.218)
      ..lineTo(w*.500, h*.224)..lineTo(w*.610, h*.218)
      ..quadraticBezierTo(w*.678, h*.210, w*.715, h*.194)
      ..lineTo(w*.702, h*.258)..quadraticBezierTo(w*.648, h*.272, w*.572, h*.278)
      ..lineTo(w*.500, h*.282)..lineTo(w*.428, h*.278)
      ..quadraticBezierTo(w*.352, h*.272, w*.298, h*.258)..close();
    _draw(canvas, 'middle_trapezius', midTrap, kTrapsMid);
    // Lower trapezius
    final lowTrap = Path()
      ..moveTo(w*.298, h*.258)..quadraticBezierTo(w*.352, h*.272, w*.428, h*.278)
      ..lineTo(w*.500, h*.282)..lineTo(w*.572, h*.278)
      ..quadraticBezierTo(w*.648, h*.272, w*.702, h*.258)
      ..lineTo(w*.688, h*.318)..quadraticBezierTo(w*.628, h*.332, w*.552, h*.336)
      ..lineTo(w*.500, h*.338)..lineTo(w*.448, h*.336)
      ..quadraticBezierTo(w*.372, h*.332, w*.312, h*.318)..close();
    _draw(canvas, 'lower_trapezius', lowTrap, kTrapsLower);

    // POSTERIOR DELTOID
    final postDelL = Path()
      ..moveTo(w*.285, h*.194)..quadraticBezierTo(w*.220, h*.202, w*.188, h*.238)
      ..quadraticBezierTo(w*.192, h*.268, w*.215, h*.278)
      ..quadraticBezierTo(w*.248, h*.260, w*.268, h*.234)
      ..quadraticBezierTo(w*.280, h*.214, w*.285, h*.194)..close();
    _draw(canvas, 'posterior_deltoid_l', postDelL, kShoulderPost);
    final postDelR = Path()
      ..moveTo(w*.715, h*.194)..quadraticBezierTo(w*.780, h*.202, w*.812, h*.238)
      ..quadraticBezierTo(w*.808, h*.268, w*.785, h*.278)
      ..quadraticBezierTo(w*.752, h*.260, w*.732, h*.234)
      ..quadraticBezierTo(w*.720, h*.214, w*.715, h*.194)..close();
    _draw(canvas, 'posterior_deltoid_r', postDelR, kShoulderPost);

    // INFRASPINATUS
    final infraL = Path()
      ..moveTo(w*.298, h*.258)..quadraticBezierTo(w*.272, h*.278, w*.268, h*.312)
      ..quadraticBezierTo(w*.278, h*.332, w*.302, h*.334)
      ..quadraticBezierTo(w*.322, h*.316, w*.322, h*.288)..close();
    _draw(canvas, 'infraspinatus_l', infraL, kInfraspin);
    final infraR = Path()
      ..moveTo(w*.702, h*.258)..quadraticBezierTo(w*.728, h*.278, w*.732, h*.312)
      ..quadraticBezierTo(w*.722, h*.332, w*.698, h*.334)
      ..quadraticBezierTo(w*.678, h*.316, w*.678, h*.288)..close();
    _draw(canvas, 'infraspinatus_r', infraR, kInfraspin);

    // TERES MINOR & MAJOR
    final tMinL = Path()
      ..moveTo(w*.215, h*.278)..quadraticBezierTo(w*.202, h*.296, w*.206, h*.316)
      ..lineTo(w*.226, h*.318)..quadraticBezierTo(w*.226, h*.298, w*.228, h*.284)..close();
    _draw(canvas, 'teres_minor_l', tMinL, kTeresMin);
    final tMinR = Path()
      ..moveTo(w*.785, h*.278)..quadraticBezierTo(w*.798, h*.296, w*.794, h*.316)
      ..lineTo(w*.774, h*.318)..quadraticBezierTo(w*.774, h*.298, w*.772, h*.284)..close();
    _draw(canvas, 'teres_minor_r', tMinR, kTeresMin);
    final tMajL = Path()
      ..moveTo(w*.206, h*.316)..quadraticBezierTo(w*.196, h*.338, w*.200, h*.362)
      ..lineTo(w*.220, h*.362)..quadraticBezierTo(w*.220, h*.340, w*.226, h*.318)..close();
    _draw(canvas, 'teres_major_l', tMajL, kTeresMaj);
    final tMajR = Path()
      ..moveTo(w*.794, h*.316)..quadraticBezierTo(w*.804, h*.338, w*.800, h*.362)
      ..lineTo(w*.780, h*.362)..quadraticBezierTo(w*.780, h*.340, w*.774, h*.318)..close();
    _draw(canvas, 'teres_major_r', tMajR, kTeresMaj);

    // RHOMBOIDS
    final rhomL = Path()
      ..moveTo(w*.390, h*.218)..quadraticBezierTo(w*.372, h*.258, w*.372, h*.282)
      ..lineTo(w*.448, h*.278)..lineTo(w*.448, h*.224)..close();
    _draw(canvas, 'rhomboid_major_l', rhomL, kRhomboid);
    final rhomR = Path()
      ..moveTo(w*.610, h*.218)..quadraticBezierTo(w*.628, h*.258, w*.628, h*.282)
      ..lineTo(w*.552, h*.278)..lineTo(w*.552, h*.224)..close();
    _draw(canvas, 'rhomboid_major_r', rhomR, kRhomboid);

    // LATISSIMUS DORSI — sweeps from shoulder down to hip
    final latL = Path()
      ..moveTo(w*.302, h*.258)..quadraticBezierTo(w*.268, h*.290, w*.252, h*.340)
      ..quadraticBezierTo(w*.244, h*.390, w*.252, h*.432)
      ..quadraticBezierTo(w*.268, h*.458, w*.298, h*.462)
      ..quadraticBezierTo(w*.328, h*.444, w*.336, h*.412)
      ..quadraticBezierTo(w*.334, h*.362, w*.322, h*.318)..close();
    _draw(canvas, 'latissimus_dorsi_l', latL, kLat);
    final latR = Path()
      ..moveTo(w*.698, h*.258)..quadraticBezierTo(w*.732, h*.290, w*.748, h*.340)
      ..quadraticBezierTo(w*.756, h*.390, w*.748, h*.432)
      ..quadraticBezierTo(w*.732, h*.458, w*.702, h*.462)
      ..quadraticBezierTo(w*.672, h*.444, w*.664, h*.412)
      ..quadraticBezierTo(w*.666, h*.362, w*.678, h*.318)..close();
    _draw(canvas, 'latissimus_dorsi_r', latR, kLat);

    // ERECTOR SPINAE
    final erspL = Path()
      ..moveTo(w*.448, h*.224)..lineTo(w*.448, h*.278)..lineTo(w*.448, h*.440)
      ..lineTo(w*.468, h*.444)..lineTo(w*.468, h*.224)..close();
    _draw(canvas, 'erector_spinae_l', erspL, kErector);
    final erspR = Path()
      ..moveTo(w*.552, h*.224)..lineTo(w*.552, h*.278)..lineTo(w*.552, h*.440)
      ..lineTo(w*.532, h*.444)..lineTo(w*.532, h*.224)..close();
    _draw(canvas, 'erector_spinae_r', erspR, kErector);
    canvas.drawLine(Offset(w*.500, h*.224), Offset(w*.500, h*.444),
        Paint()..color = kOutline.withValues(alpha: 0.4)..strokeWidth = 0.8);

    // TRICEPS — long, lateral, medial heads
    final triLongL = Path()
      ..moveTo(w*.215, h*.278)..quadraticBezierTo(w*.185, h*.302, w*.180, h*.358)
      ..quadraticBezierTo(w*.185, h*.386, w*.202, h*.392)
      ..quadraticBezierTo(w*.225, h*.370, w*.232, h*.340)
      ..quadraticBezierTo(w*.235, h*.308, w*.232, h*.288)..close();
    _draw(canvas, 'triceps_long_head_l', triLongL, kTricepsLong);
    final triLongR = Path()
      ..moveTo(w*.785, h*.278)..quadraticBezierTo(w*.815, h*.302, w*.820, h*.358)
      ..quadraticBezierTo(w*.815, h*.386, w*.798, h*.392)
      ..quadraticBezierTo(w*.775, h*.370, w*.768, h*.340)
      ..quadraticBezierTo(w*.765, h*.308, w*.768, h*.288)..close();
    _draw(canvas, 'triceps_long_head_r', triLongR, kTricepsLong);
    final triLatL = Path()
      ..moveTo(w*.180, h*.328)..quadraticBezierTo(w*.162, h*.352, w*.162, h*.382)
      ..lineTo(w*.182, h*.388)..quadraticBezierTo(w*.185, h*.360, w*.188, h*.336)..close();
    _draw(canvas, 'triceps_lateral_head_l', triLatL, kTricepsLat);
    final triLatR = Path()
      ..moveTo(w*.820, h*.328)..quadraticBezierTo(w*.838, h*.352, w*.838, h*.382)
      ..lineTo(w*.818, h*.388)..quadraticBezierTo(w*.815, h*.360, w*.812, h*.336)..close();
    _draw(canvas, 'triceps_lateral_head_r', triLatR, kTricepsLat);
    final triMedL = Path()
      ..moveTo(w*.202, h*.352)..quadraticBezierTo(w*.190, h*.368, w*.190, h*.386)
      ..lineTo(w*.206, h*.388)..quadraticBezierTo(w*.208, h*.370, w*.210, h*.356)..close();
    _draw(canvas, 'triceps_medial_head_l', triMedL, kTricepsMed);
    final triMedR = Path()
      ..moveTo(w*.798, h*.352)..quadraticBezierTo(w*.810, h*.368, w*.810, h*.386)
      ..lineTo(w*.794, h*.388)..quadraticBezierTo(w*.792, h*.370, w*.790, h*.356)..close();
    _draw(canvas, 'triceps_medial_head_r', triMedR, kTricepsMed);

    // FOREARM EXTENSORS
    final extRadL = Path()
      ..moveTo(w*.202, h*.392)..quadraticBezierTo(w*.182, h*.424, w*.184, h*.472)
      ..lineTo(w*.204, h*.476)..quadraticBezierTo(w*.212, h*.430, w*.218, h*.398)..close();
    _draw(canvas, 'extensor_carpi_radialis_l', extRadL, kForearmExt);
    final extRadR = Path()
      ..moveTo(w*.798, h*.392)..quadraticBezierTo(w*.818, h*.424, w*.816, h*.472)
      ..lineTo(w*.796, h*.476)..quadraticBezierTo(w*.788, h*.430, w*.782, h*.398)..close();
    _draw(canvas, 'extensor_carpi_radialis_r', extRadR, kForearmExt);
    final extUlnL = Path()
      ..moveTo(w*.162, h*.382)..quadraticBezierTo(w*.145, h*.410, w*.148, h*.458)
      ..lineTo(w*.165, h*.462)..quadraticBezierTo(w*.165, h*.416, w*.175, h*.388)..close();
    _draw(canvas, 'extensor_carpi_ulnaris_back_l', extUlnL, kForearmExt.withValues(alpha: 0.78));
    final extUlnR = Path()
      ..moveTo(w*.838, h*.382)..quadraticBezierTo(w*.855, h*.410, w*.852, h*.458)
      ..lineTo(w*.835, h*.462)..quadraticBezierTo(w*.835, h*.416, w*.825, h*.388)..close();
    _draw(canvas, 'extensor_carpi_ulnaris_back_r', extUlnR, kForearmExt.withValues(alpha: 0.78));
    // Wrist/hand back
    final handL = Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w*.138, h*.468, w*.072, h*.072), const Radius.circular(8)));
    _draw(canvas, 'wrist_hand_back_l', handL, kSkin);
    final handR = Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w*.790, h*.468, w*.072, h*.072), const Radius.circular(8)));
    _draw(canvas, 'wrist_hand_back_r', handR, kSkin);

    // EXTERNAL OBLIQUE (back)
    final oblL = Path()
      ..moveTo(w*.298, h*.462)..quadraticBezierTo(w*.278, h*.480, w*.275, h*.508)
      ..lineTo(w*.300, h*.514)..quadraticBezierTo(w*.308, h*.490, w*.318, h*.470)..close();
    _draw(canvas, 'external_oblique_back_l', oblL, kOblique);
    final oblR = Path()
      ..moveTo(w*.702, h*.462)..quadraticBezierTo(w*.722, h*.480, w*.725, h*.508)
      ..lineTo(w*.700, h*.514)..quadraticBezierTo(w*.692, h*.490, w*.682, h*.470)..close();
    _draw(canvas, 'external_oblique_back_r', oblR, kOblique);

    // GLUTES
    final glutMedL = Path()
      ..moveTo(w*.275, h*.508)..quadraticBezierTo(w*.258, h*.498, w*.255, h*.480)
      ..quadraticBezierTo(w*.262, h*.464, w*.282, h*.460)
      ..quadraticBezierTo(w*.302, h*.466, w*.308, h*.480)
      ..quadraticBezierTo(w*.306, h*.498, w*.298, h*.508)..close();
    _draw(canvas, 'gluteus_medius_l', glutMedL, kGlutMed);
    final glutMedR = Path()
      ..moveTo(w*.725, h*.508)..quadraticBezierTo(w*.742, h*.498, w*.745, h*.480)
      ..quadraticBezierTo(w*.738, h*.464, w*.718, h*.460)
      ..quadraticBezierTo(w*.698, h*.466, w*.692, h*.480)
      ..quadraticBezierTo(w*.694, h*.498, w*.702, h*.508)..close();
    _draw(canvas, 'gluteus_medius_r', glutMedR, kGlutMed);
    final glutMaxL = Path()
      ..moveTo(w*.275, h*.508)..quadraticBezierTo(w*.252, h*.532, w*.248, h*.572)
      ..quadraticBezierTo(w*.255, h*.604, w*.280, h*.614)
      ..quadraticBezierTo(w*.315, h*.608, w*.332, h*.586)
      ..quadraticBezierTo(w*.342, h*.558, w*.338, h*.524)
      ..quadraticBezierTo(w*.325, h*.504, w*.308, h*.500)..close();
    _draw(canvas, 'gluteus_maximus_l', glutMaxL, kGlutMax);
    final glutMaxR = Path()
      ..moveTo(w*.725, h*.508)..quadraticBezierTo(w*.748, h*.532, w*.752, h*.572)
      ..quadraticBezierTo(w*.745, h*.604, w*.720, h*.614)
      ..quadraticBezierTo(w*.685, h*.608, w*.668, h*.586)
      ..quadraticBezierTo(w*.658, h*.558, w*.662, h*.524)
      ..quadraticBezierTo(w*.675, h*.504, w*.692, h*.500)..close();
    _draw(canvas, 'gluteus_maximus_r', glutMaxR, kGlutMax);

    // HAMSTRINGS
    final bfL = Path()
      ..moveTo(w*.280, h*.614)..quadraticBezierTo(w*.258, h*.642, w*.254, h*.688)
      ..quadraticBezierTo(w*.258, h*.722, w*.276, h*.734)
      ..quadraticBezierTo(w*.302, h*.728, w*.316, h*.706)
      ..quadraticBezierTo(w*.324, h*.672, w*.318, h*.638)..close();
    _draw(canvas, 'biceps_femoris_l', bfL, kHamBicep);
    final bfR = Path()
      ..moveTo(w*.720, h*.614)..quadraticBezierTo(w*.742, h*.642, w*.746, h*.688)
      ..quadraticBezierTo(w*.742, h*.722, w*.724, h*.734)
      ..quadraticBezierTo(w*.698, h*.728, w*.684, h*.706)
      ..quadraticBezierTo(w*.676, h*.672, w*.682, h*.638)..close();
    _draw(canvas, 'biceps_femoris_r', bfR, kHamBicep);
    final stL = Path()
      ..moveTo(w*.338, h*.524)..quadraticBezierTo(w*.334, h*.562, w*.332, h*.604)
      ..quadraticBezierTo(w*.332, h*.644, w*.338, h*.678)
      ..quadraticBezierTo(w*.354, h*.684, w*.366, h*.672)
      ..quadraticBezierTo(w*.372, h*.638, w*.370, h*.598)
      ..quadraticBezierTo(w*.366, h*.558, w*.358, h*.526)..close();
    _draw(canvas, 'semitendinosus_l', stL, kSemiTend);
    final stR = Path()
      ..moveTo(w*.662, h*.524)..quadraticBezierTo(w*.666, h*.562, w*.668, h*.604)
      ..quadraticBezierTo(w*.668, h*.644, w*.662, h*.678)
      ..quadraticBezierTo(w*.646, h*.684, w*.634, h*.672)
      ..quadraticBezierTo(w*.628, h*.638, w*.630, h*.598)
      ..quadraticBezierTo(w*.634, h*.558, w*.642, h*.526)..close();
    _draw(canvas, 'semitendinosus_r', stR, kSemiTend);
    final smL = Path()
      ..moveTo(w*.358, h*.526)..quadraticBezierTo(w*.362, h*.562, w*.362, h*.604)
      ..quadraticBezierTo(w*.362, h*.644, w*.358, h*.678)
      ..lineTo(w*.370, h*.678)..quadraticBezierTo(w*.374, h*.642, w*.374, h*.602)
      ..quadraticBezierTo(w*.374, h*.560, w*.370, h*.524)..close();
    _draw(canvas, 'semimembranosus_l', smL, kSemiMemb);
    final smR = Path()
      ..moveTo(w*.642, h*.526)..quadraticBezierTo(w*.638, h*.562, w*.638, h*.604)
      ..quadraticBezierTo(w*.638, h*.644, w*.642, h*.678)
      ..lineTo(w*.630, h*.678)..quadraticBezierTo(w*.626, h*.642, w*.626, h*.602)
      ..quadraticBezierTo(w*.626, h*.560, w*.630, h*.524)..close();
    _draw(canvas, 'semimembranosus_r', smR, kSemiMemb);
    // IT Band
    final itbL = Path()
      ..moveTo(w*.248, h*.572)..quadraticBezierTo(w*.238, h*.612, w*.238, h*.660)
      ..quadraticBezierTo(w*.242, h*.698, w*.256, h*.712)
      ..lineTo(w*.268, h*.710)..quadraticBezierTo(w*.256, h*.696, w*.254, h*.658)
      ..quadraticBezierTo(w*.254, h*.612, w*.262, h*.574)..close();
    _draw(canvas, 'iliotibial_band_l', itbL, kITBand);
    final itbR = Path()
      ..moveTo(w*.752, h*.572)..quadraticBezierTo(w*.762, h*.612, w*.762, h*.660)
      ..quadraticBezierTo(w*.758, h*.698, w*.744, h*.712)
      ..lineTo(w*.732, h*.710)..quadraticBezierTo(w*.744, h*.696, w*.746, h*.658)
      ..quadraticBezierTo(w*.746, h*.612, w*.738, h*.574)..close();
    _draw(canvas, 'iliotibial_band_r', itbR, kITBand);

    // LOWER LEG BACK
    final gastMedL = Path()
      ..moveTo(w*.370, h*.682)..quadraticBezierTo(w*.364, h*.710, w*.364, h*.748)
      ..quadraticBezierTo(w*.368, h*.778, w*.380, h*.790)
      ..quadraticBezierTo(w*.396, h*.786, w*.402, h*.770)
      ..quadraticBezierTo(w*.406, h*.742, w*.402, h*.710)
      ..quadraticBezierTo(w*.394, h*.686, w*.384, h*.680)..close();
    _draw(canvas, 'gastrocnemius_medial_l', gastMedL, kGastroMed);
    final gastMedR = Path()
      ..moveTo(w*.630, h*.682)..quadraticBezierTo(w*.636, h*.710, w*.636, h*.748)
      ..quadraticBezierTo(w*.632, h*.778, w*.620, h*.790)
      ..quadraticBezierTo(w*.604, h*.786, w*.598, h*.770)
      ..quadraticBezierTo(w*.594, h*.742, w*.598, h*.710)
      ..quadraticBezierTo(w*.606, h*.686, w*.616, h*.680)..close();
    _draw(canvas, 'gastrocnemius_medial_r', gastMedR, kGastroMed);
    final gastLatL = Path()
      ..moveTo(w*.318, h*.680)..quadraticBezierTo(w*.302, h*.708, w*.300, h*.746)
      ..quadraticBezierTo(w*.304, h*.776, w*.318, h*.788)
      ..quadraticBezierTo(w*.336, h*.784, w*.344, h*.768)
      ..quadraticBezierTo(w*.350, h*.740, w*.346, h*.708)
      ..quadraticBezierTo(w*.338, h*.682, w*.328, h*.678)..close();
    _draw(canvas, 'gastrocnemius_lateral_l', gastLatL, kGastroLat);
    final gastLatR = Path()
      ..moveTo(w*.682, h*.680)..quadraticBezierTo(w*.698, h*.708, w*.700, h*.746)
      ..quadraticBezierTo(w*.696, h*.776, w*.682, h*.788)
      ..quadraticBezierTo(w*.664, h*.784, w*.656, h*.768)
      ..quadraticBezierTo(w*.650, h*.740, w*.654, h*.708)
      ..quadraticBezierTo(w*.662, h*.682, w*.672, h*.678)..close();
    _draw(canvas, 'gastrocnemius_lateral_r', gastLatR, kGastroLat);
    // Soleus
    final solL = Path()
      ..moveTo(w*.302, h*.786)..quadraticBezierTo(w*.296, h*.810, w*.298, h*.838)
      ..quadraticBezierTo(w*.306, h*.854, w*.326, h*.856)
      ..quadraticBezierTo(w*.348, h*.852, w*.354, h*.836)
      ..quadraticBezierTo(w*.358, h*.810, w*.354, h*.786)..close();
    _draw(canvas, 'soleus_back_l', solL, kSoleusBack);
    final solR = Path()
      ..moveTo(w*.698, h*.786)..quadraticBezierTo(w*.704, h*.810, w*.702, h*.838)
      ..quadraticBezierTo(w*.694, h*.854, w*.674, h*.856)
      ..quadraticBezierTo(w*.652, h*.852, w*.646, h*.836)
      ..quadraticBezierTo(w*.642, h*.810, w*.646, h*.786)..close();
    _draw(canvas, 'soleus_back_r', solR, kSoleusBack);
    // Achilles tendon
    final achL = Path()
      ..moveTo(w*.350, h*.852)..quadraticBezierTo(w*.346, h*.872, w*.348, h*.888)
      ..lineTo(w*.360, h*.888)..quadraticBezierTo(w*.360, h*.872, w*.358, h*.852)..close();
    _draw(canvas, 'achilles_tendon_l', achL, kAchilles);
    final achR = Path()
      ..moveTo(w*.650, h*.852)..quadraticBezierTo(w*.654, h*.872, w*.652, h*.888)
      ..lineTo(w*.640, h*.888)..quadraticBezierTo(w*.640, h*.872, w*.642, h*.852)..close();
    _draw(canvas, 'achilles_tendon_r', achR, kAchilles);
    // Peroneus brevis
    final perBrevL = Path()
      ..moveTo(w*.300, h*.746)..quadraticBezierTo(w*.288, h*.772, w*.290, h*.804)
      ..lineTo(w*.306, h*.806)..quadraticBezierTo(w*.306, h*.776, w*.312, h*.750)..close();
    _draw(canvas, 'peroneus_brevis_l', perBrevL, kPeroneus);
    final perBrevR = Path()
      ..moveTo(w*.700, h*.746)..quadraticBezierTo(w*.712, h*.772, w*.710, h*.804)
      ..lineTo(w*.694, h*.806)..quadraticBezierTo(w*.694, h*.776, w*.688, h*.750)..close();
    _draw(canvas, 'peroneus_brevis_r', perBrevR, kPeroneus);
    // Feet
    final footL = Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w*.290, h*.886, w*.090, h*.048), const Radius.circular(10)));
    _draw(canvas, 'ankle_foot_back_l', footL, kFoot);
    final footR = Path()..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(w*.620, h*.886, w*.090, h*.048), const Radius.circular(10)));
    _draw(canvas, 'ankle_foot_back_r', footR, kFoot);
  }

  @override
  bool shouldRepaint(BackBodyPainter old) => old.selected != selected;
}
