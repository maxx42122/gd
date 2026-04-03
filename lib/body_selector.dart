import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'front_painter.dart';
import 'back_painter.dart';
import 'muscle_group.dart';
import 'screens/symptom_input/symptom_input_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Interactive body viewer with pinch-zoom, pan, and two-finger rotate
// ─────────────────────────────────────────────────────────────────────────────
class _TransformState {
  double scale;
  Offset offset;
  double rotation;
  _TransformState({
    this.scale = 1.0,
    this.offset = Offset.zero,
    this.rotation = 0.0,
  });
  _TransformState copy() =>
      _TransformState(scale: scale, offset: offset, rotation: rotation);
}

class BodySelectorScreen extends StatefulWidget {
  const BodySelectorScreen({super.key});
  @override
  State<BodySelectorScreen> createState() => _BodySelectorScreenState();
}

class _BodySelectorScreenState extends State<BodySelectorScreen>
    with SingleTickerProviderStateMixin {
  final Set<String> _selected = {};
  late final TabController _tabController;

  // Transform state per tab
  final _transforms = [_TransformState(), _TransformState()];

  // Gesture tracking
  double? _baseScale;
  double? _baseRotation;
  Offset? _baseFocalPoint;
  Offset? _baseOffset;

  // Painters (kept for hit-testing)
  FrontBodyPainter? _frontPainter;
  BackBodyPainter? _backPainter;

  // Canvas size for coordinate mapping
  Size _canvasSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _TransformState get _current => _transforms[_tabController.index];

  void _onScaleStart(ScaleStartDetails d) {
    _baseScale = _current.scale;
    _baseRotation = _current.rotation;
    _baseFocalPoint = d.focalPoint;
    _baseOffset = _current.offset;
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    setState(() {
      final t = _current;
      t.scale = (_baseScale! * d.scale).clamp(0.6, 5.0);
      t.rotation = _baseRotation! + d.rotation;
      final delta = d.focalPoint - _baseFocalPoint!;
      t.offset = _baseOffset! + delta;
    });
  }

  void _onTapDown(TapDownDetails d, bool isFront) {
    // Map tap from screen space → canvas space (undo transform)
    final t = _current;
    final center = Offset(_canvasSize.width / 2, _canvasSize.height / 2);
    // Reverse: translate, rotate, scale
    var p = d.localPosition - t.offset - center;
    final cos = math.cos(-t.rotation);
    final sin = math.sin(-t.rotation);
    p = Offset(p.dx * cos - p.dy * sin, p.dx * sin + p.dy * cos);
    p = p / t.scale + center;

    final id =
        isFront ? _frontPainter?.findRegion(p) : _backPainter?.findRegion(p);
    if (id == null) return;

    final muscle = muscleById[id];
    if (muscle == null) return;
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
        _snack('${muscle.label} deselected');
      } else {
        _selected.add(id);
        _snack('${muscle.label} selected');
      }
    });
  }

  void _resetTransform() {
    setState(() {
      _transforms[_tabController.index] = _TransformState();
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w500)),
        duration: const Duration(milliseconds: 1000),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onContinue() {
    if (_selected.isEmpty) {
      _snack('Select at least one muscle');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SymptomInputScreen(muscleIds: Set.from(_selected)),
      ),
    );
  }

  Widget _buildBodyCanvas({required bool isFront}) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final h = constraints.maxHeight;
        final w = constraints.maxWidth;
        _canvasSize = Size(w, h);
        final t = _current;

        return GestureDetector(
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          onTapDown: (d) => _onTapDown(d, isFront),
          child: Container(
            width: w,
            height: h,
            color: const Color(0xFFF8F9FC),
            child: ClipRect(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translateByDouble(t.offset.dx, t.offset.dy, 0, 1)
                  ..rotateZ(t.rotation)
                  ..scaleByDouble(t.scale, t.scale, 1, 1),
                child: CustomPaint(
                  size: Size(w, h),
                  painter: isFront
                      ? (_frontPainter = FrontBodyPainter(selected: _selected))
                      : (_backPainter = BackBodyPainter(selected: _selected)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedList = _selected.toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        title: const Text(
          'Muscle Anatomy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white70, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (selectedList.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => _selected.clear()),
              child: const Text(
                'Clear',
                style: TextStyle(color: Color(0xFFFF6B6B)),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            tooltip: 'Reset view',
            onPressed: _resetTransform,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF58A6FF),
          unselectedLabelColor: Colors.white38,
          indicatorColor: const Color(0xFF58A6FF),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: '⬛  FRONT VIEW'),
            Tab(text: '⬛  BACK VIEW'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Hint bar
          Container(
            color: const Color(0xFF161B22),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedList.isEmpty
                      ? 'Tap a muscle • Pinch to zoom • Drag to pan'
                      : '${selectedList.length} muscle${selectedList.length > 1 ? "s" : ""} selected',
                  style: TextStyle(
                    color: selectedList.isEmpty
                        ? Colors.white38
                        : const Color(0xFFFF6B6B),
                    fontSize: 11,
                    fontWeight: selectedList.isEmpty
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
                const Text(
                  '↻ Two-finger rotate',
                  style: TextStyle(color: Colors.white24, fontSize: 10),
                ),
              ],
            ),
          ),
          // Body canvas
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBodyCanvas(isFront: true),
                _buildBodyCanvas(isFront: false),
              ],
            ),
          ),
          // Selected chips
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: selectedList.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    width: double.infinity,
                    color: const Color(0xFF161B22),
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: selectedList.map((id) {
                        final label = muscleById[id]?.label ?? id;
                        return Chip(
                          label: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: const Color(0xFF8B0000),
                          side: const BorderSide(
                            color: Color(0xFFFF6B6B),
                            width: 0.8,
                          ),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 12,
                            color: Colors.white70,
                          ),
                          onDeleted: () => setState(() => _selected.remove(id)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                  ),
          ),
          // Continue button
          Container(
            color: const Color(0xFF161B22),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedList.isEmpty
                      ? const Color(0xFF30363D)
                      : const Color(0xFF238636),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  selectedList.isEmpty
                      ? 'Select a muscle to continue'
                      : 'Analyse Symptoms  (${selectedList.length} selected)',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
