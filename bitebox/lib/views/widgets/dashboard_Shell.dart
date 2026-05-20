
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class BBSalesChartCard extends StatelessWidget {
  final List<double> revenue;
  final List<double> orders;
  final List<String> xLabels;
  final List<String> yLabels;
  final bool         isLoading;

  const BBSalesChartCard({
    super.key,
    required this.revenue,
    required this.orders,
    required this.xLabels,
    required this.yLabels,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BBColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BBColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales Performance',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: BBColors.border),
                ),
                child: Text(
                  'Last 7 Days',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: BBColors.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Legend
          Row(
            children: [
              _LegendDot(color: BBColors.red,   label: 'Revenue'),
              const SizedBox(width: 14),
              _LegendDot(color: BBColors.green, label: 'Orders'),
            ],
          ),
          const SizedBox(height: 12),

          // Chart canvas
          SizedBox(
            height: 200,
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: BBColors.red))
                : CustomPaint(
                    painter: _SalesLinePainter(
                      revenue: revenue,
                      orders:  orders,
                      xLabels: xLabels,
                      yLabels: yLabels,
                    ),
                    child: const SizedBox.expand(),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Painter ─────────────────────────────────────────────────────────────────

class _SalesLinePainter extends CustomPainter {
  final List<double> revenue;
  final List<double> orders;
  final List<String> xLabels;
  final List<String> yLabels;

  const _SalesLinePainter({
    required this.revenue,
    required this.orders,
    required this.xLabels,
    required this.yLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (revenue.isEmpty) return;
    const double padL = 40, padB = 24, padT = 10;
    final double cW = size.width - padL;
    final double cH = size.height - padB - padT;

    _drawGrid(canvas, size, padL, padT, cW, cH);
    _drawYLabels(canvas, padT, cH);
    _drawXLabels(canvas, size, padL, cW);
    _drawLine(canvas, revenue, BBColors.red,   padL, padT, cW, cH);
    _drawLine(canvas, orders,  BBColors.green, padL, padT, cW, cH);
  }

  void _drawGrid(Canvas c, Size s, double pL, double pT, double cW, double cH) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 0.5;
    for (int i = 0; i <= 4; i++) {
      final y = pT + cH * (1 - i / 4);
      c.drawLine(Offset(pL, y), Offset(s.width, y), p);
    }
  }

  void _drawYLabels(Canvas c, double pT, double cH) {
    for (int i = 0; i <= 4; i++) {
      final y = pT + cH * (1 - i / 4);
      final painter = TextPainter(
        text: TextSpan(
          text: yLabels[i],
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.45),
            fontSize: 9,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
      );
      painter.layout(maxWidth: 34);
      painter.paint(c, Offset(0, y - painter.height / 2));
    }
  }

  void _drawXLabels(Canvas c, Size s, double pL, double cW) {
    for (int i = 0; i < xLabels.length; i++) {
      final x = pL + (cW / (xLabels.length - 1)) * i;
      final painter = TextPainter(
        text: TextSpan(
          text: xLabels[i],
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.45),
            fontSize: 9,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      painter.layout();
      painter.paint(c, Offset(x - painter.width / 2, s.height - painter.height));
    }
  }

  void _drawLine(Canvas c, List<double> data, Color color,
      double pL, double pT, double cW, double cH) {
    if (data.length < 2) return;
    final pts = List.generate(data.length, (i) => Offset(
      pL + (cW / (data.length - 1)) * i,
      pT + cH * (1 - data[i]),
    ));

    // Fill
    final fill = Path()
      ..moveTo(pts.first.dx, pT + cH)
      ..lineTo(pts.first.dx, pts.first.dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final cp1 = Offset((pts[i].dx + pts[i + 1].dx) / 2, pts[i].dy);
      final cp2 = Offset((pts[i].dx + pts[i + 1].dx) / 2, pts[i + 1].dy);
      fill.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i + 1].dx, pts[i + 1].dy);
    }
    fill.lineTo(pts.last.dx, pT + cH);
    fill.close();
    c.drawPath(fill, Paint()..color = color.withOpacity(0.08));

    // Line
    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final cp1 = Offset((pts[i].dx + pts[i + 1].dx) / 2, pts[i].dy);
      final cp2 = Offset((pts[i].dx + pts[i + 1].dx) / 2, pts[i + 1].dy);
      line.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i + 1].dx, pts[i + 1].dy);
    }
    c.drawPath(line, Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round);

    // Dots
    for (final pt in pts) {
      c.drawCircle(pt, 2.5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant _SalesLinePainter old) =>
      old.revenue != revenue || old.orders != orders;
}

// ─── Legend dot ──────────────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  final Color  color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 8, height: 8,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
      ),
      const SizedBox(width: 5),
      Text(label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: BBColors.muted,
        ),
      ),
    ],
  );
}
