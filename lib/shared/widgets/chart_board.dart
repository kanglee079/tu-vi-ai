import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/chart_models.dart';

/// A proper Vietnamese Tử Vi astrolabe board.
///
/// Layout:
///   - 12 palaces arranged in a circle (clockwise from top)
///   - Center circle shows profile name + year + mệnh info
///   - Each palace shows: name, can chi, major stars, minor stars, score badge
///   - Tappable palaces → onTap(palace)
///   - Pinch-to-zoom + pan support
class ChartBoard extends StatefulWidget {
  const ChartBoard({
    super.key,
    required this.palaces,
    required this.profileName,
    required this.profileYear,
    required this.menhLabel,
    this.onTap,
  });

  final List<ChartPalace> palaces;
  final String profileName;
  final int profileYear;
  final String menhLabel;
  final ValueChanged<ChartPalace>? onTap;

  @override
  State<ChartBoard> createState() => _ChartBoardState();
}

class _ChartBoardState extends State<ChartBoard>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformController =
      TransformationController();
  late AnimationController _pulseController;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseController.addStatusListener((AnimationStatus status) {
      // Stop after one complete pulse cycle so pumpAndSettle can settle in tests.
      if (status == AnimationStatus.completed) {
        _pulseController.stop();
      }
    });
    _pulseController.forward();
  }

  @override
  void dispose() {
    _transformController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        _buildHeader(context),
        const SizedBox(height: 8),
        // Board
        Expanded(
          child: InteractiveViewer(
            transformationController: _transformController,
            minScale: 0.5,
            maxScale: 2.5,
            boundaryMargin: const EdgeInsets.all(40),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = math.min(constraints.maxWidth, constraints.maxHeight);
                return Center(
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: CustomPaint(
                      painter: _AstrolabePainter(
                        palaces: widget.palaces,
                        selectedIndex: _selectedIndex,
                        pulseValue: _pulseController.value,
                      ),
                      child: Stack(
                        children: [
                          // Center profile card
                          Center(
                            child: _buildCenterCard(context, size * 0.22),
                          ),
                          // Palace tap targets (positioned around the circle)
                          ..._buildPalaceTargets(context, size),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Legend
        _buildLegend(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.amberSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.amber, size: 18),
          const SizedBox(width: 6),
          Text(
            'Bàn lá số Tử Vi',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.amber,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterCard(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.amber.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: AppColors.amber, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.profileName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${widget.profileYear}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.amber,
                ),
          ),
          const Divider(height: 6),
          Text(
            widget.menhLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.jade,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPalaceTargets(BuildContext context, double size) {
    if (widget.palaces.length != 12) return [];
    final radius = size / 2;
    final palaceRadius = radius * 0.72;
    final palaceSize = radius * 0.42;

    return List.generate(12, (i) {
      // Arrange: 0 = top, going clockwise
      // Standard TV layout: 0=Mệnh(top), 3=PhuThê(right), 6=TaiBach(bottom), 9=QuanLoc(left)
      final angle = -math.pi / 2 + (i * 2 * math.pi / 12);
      final cx = radius + palaceRadius * math.cos(angle);
      final cy = radius + palaceRadius * math.sin(angle);

      return Positioned(
        left: cx - palaceSize / 2,
        top: cy - palaceSize / 2,
        child: _PalaceCard(
          palace: widget.palaces[i],
          size: palaceSize,
          index: i,
          isSelected: _selectedIndex == i,
          onTap: () {
            setState(() => _selectedIndex = i);
            widget.onTap?.call(widget.palaces[i]);
          },
        ),
      );
    });
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendDot(AppColors.jade, 'Chính tinh'),
        const SizedBox(width: 16),
        _legendDot(AppColors.amber, 'Phụ tinh'),
        const SizedBox(width: 16),
        _legendDot(AppColors.line, 'Biến tinh'),
      ],
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.ink)),
      ],
    );
  }
}

// ============================================================
// Palace Card — individual palace widget
// ============================================================

class _PalaceCard extends StatelessWidget {
  const _PalaceCard({
    required this.palace,
    required this.size,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  final ChartPalace palace;
  final double size;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = palace.key == 'menh' || palace.key == 'quan_loc';
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
          color: isSelected
              ? AppColors.amberSoft
              : palace.isUnlocked
                  ? Colors.white
                  : AppColors.amberSoft.withValues(alpha: 0.6),
          border: Border.all(
            color: isSelected
                ? AppColors.amber
                : isHighlighted
                    ? AppColors.amber
                    : AppColors.line,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.amber.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        padding: const EdgeInsets.all(3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Palace name
            Text(
              palace.name,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: isHighlighted ? AppColors.amber : AppColors.ink,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            // Primary stars
            if (palace.primaryStars.isNotEmpty)
              Expanded(
                child: Wrap(
                  spacing: 1,
                  runSpacing: 1,
                  children: palace.primaryStars.take(3).map((star) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0.5),
                      decoration: BoxDecoration(
                        color: AppColors.jade.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        _shorten(star),
                        style: const TextStyle(
                          fontSize: 7,
                          color: AppColors.jade,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                ),
              ),
            // Secondary stars
            if (palace.secondaryStars.isNotEmpty)
              Expanded(
                child: Wrap(
                  spacing: 1,
                  runSpacing: 1,
                  children: palace.secondaryStars.take(4).map((star) {
                    return Text(
                      _shorten(star),
                      style: const TextStyle(
                        fontSize: 6.5,
                        color: AppColors.amber,
                      ),
                      maxLines: 1,
                    );
                  }).toList(),
                ),
              ),
            // Score badge
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                decoration: BoxDecoration(
                  color: _scoreColor(palace.score).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '${palace.score}',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: _scoreColor(palace.score),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _scoreColor(int score) {
    if (score >= 68) return AppColors.jade;
    if (score >= 52) return AppColors.amber;
    return AppColors.caution;
  }

  String _shorten(String name) {
    // Truncate to 2 chars for display
    if (name.length <= 2) return name;
    // Remove common prefix words
    return name.replaceFirst('Thiên ', 'T.')
        .replaceFirst('Thái ', 'Th.')
        .replaceFirst('Hóa ', 'H.')
        .replaceFirst('Văn ', 'V.')
        .replaceFirst('Tả ', 'T.')
        .replaceFirst('Hữu ', 'H.')
        .replaceFirst('Lộc ', 'L.')
        .replaceFirst('Phá ', 'P.')
        .replaceFirst('Tham ', 'Th.')
        .replaceFirst('Cự ', 'C.')
        .replaceFirst('Liêm ', 'L.')
        .replaceFirst('Vũ ', 'V.')
        .replaceFirst('Quan ', 'Q.')
        .replaceFirst('Minh ', 'M.')
        .replaceFirst('Phúc ', 'Ph.')
        .replaceFirst('Tài ', 'T.')
        .replaceFirst('Di ', 'D.')
        .replaceFirst('Tử ', 'T.')
        .replaceFirst('Huynh ', 'H.')
        .replaceFirst('Nô ', 'N.')
        .replaceFirst('Điền ', 'Đ.')
        .replaceFirst('Tật ', 'T.')
        .replaceFirst('Giải ', 'G.')
        .replaceFirst('Duyệt ', 'D.')
        .replaceFirst('Tứ ', 'T.')
        .replaceFirst('Cát ', 'C.')
        .replaceFirst('Lục ', 'L.');
  }
}

// ============================================================
// Astrolabe Painter — draws the circle structure
// ============================================================

class _AstrolabePainter extends CustomPainter {
  _AstrolabePainter({
    required this.palaces,
    required this.selectedIndex,
    required this.pulseValue,
  });

  final List<ChartPalace> palaces;
  final int? selectedIndex;
  final double pulseValue;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final palaceRadius = radius * 0.72;

    // ---- Outer ring ----
    final outerRingPaint = Paint()
      ..color = AppColors.line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius - 2, outerRingPaint);

    // ---- Palace ring ----
    final palaceRingPaint = Paint()
      ..color = AppColors.line.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, palaceRadius, palaceRingPaint);

    // ---- Inner decorative ring ----
    final innerPaint = Paint()
      ..color = AppColors.line.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawCircle(center, radius * 0.38, innerPaint);

    // ---- 12 palace dividers (lines from center to outer ring) ----
    final dividerPaint = Paint()
      ..color = AppColors.line.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (var i = 0; i < 12; i++) {
      final angle = -math.pi / 2 + (i * 2 * math.pi / 12);
      final outer = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, outer, dividerPaint);
    }

    // ---- Palace position markers on ring ----
    final markerPaint = Paint()
      ..color = AppColors.amber.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 12; i++) {
      final angle = -math.pi / 2 + (i * 2 * math.pi / 12);
      final pos = Offset(
        center.dx + palaceRadius * math.cos(angle),
        center.dy + palaceRadius * math.sin(angle),
      );
      canvas.drawCircle(pos, 3, markerPaint);
    }

    // ---- Selected palace glow ----
    if (selectedIndex != null && selectedIndex! < palaces.length) {
      final angle = -math.pi / 2 + (selectedIndex! * 2 * math.pi / 12);
      final selectedPos = Offset(
        center.dx + palaceRadius * math.cos(angle),
        center.dy + palaceRadius * math.sin(angle),
      );

      final glowPaint = Paint()
        ..color = AppColors.amber.withValues(alpha: 0.3 + pulseValue * 0.2)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(selectedPos, 10 + pulseValue * 4, glowPaint);
    }

    // ---- Cardinal direction labels ----
    _drawCardinalLabel(canvas, center, radius - 18, -math.pi / 2, 'N');
    _drawCardinalLabel(canvas, center, radius - 18, math.pi / 2, 'S');
    _drawCardinalLabel(canvas, center, radius - 18, 0, 'Đ');
    _drawCardinalLabel(canvas, center, radius - 18, math.pi, 'T');
  }

  void _drawCardinalLabel(
      Canvas canvas, Offset center, double labelRadius, double angle, String text) {
    final pos = Offset(
      center.dx + labelRadius * math.cos(angle),
      center.dy + labelRadius * math.sin(angle),
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: AppColors.line.withValues(alpha: 0.7),
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      pos - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_AstrolabePainter oldDelegate) =>
      selectedIndex != oldDelegate.selectedIndex ||
      pulseValue != oldDelegate.pulseValue ||
      palaces != oldDelegate.palaces;
}
