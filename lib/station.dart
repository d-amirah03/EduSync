import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'theme.dart';

const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
const _months = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December'
];

String fmtTime(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final m = d.minute.toString().padLeft(2, '0');
  return '$h:$m ${d.hour < 12 ? 'AM' : 'PM'}';
}

String fmtDate(DateTime d) => '${_days[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';

class StationScreen extends StatefulWidget {
  const StationScreen({super.key});
  @override
  State<StationScreen> createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  static const total = 30;
  DateTime now = DateTime.now();
  int left = 14;
  int seed = 1;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
        left--;
        if (left <= 0) {
          left = total;
          seed++;
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget _info(bool wide) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Sekolah Kebangsaan Paya Mebi', style: ts(wide ? 18 : 15, color: C.muted)),
          const SizedBox(height: 10),
          Text(fmtTime(now), style: ts(wide ? 72 : 48, w: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(fmtDate(now), style: ts(wide ? 20 : 16, color: C.muted)),
          const SizedBox(height: 34),
          Text('Scan to check in or out', style: ts(wide ? 32 : 24, w: FontWeight.w600)),
          const SizedBox(height: 10),
          Text('Open EduSync on your phone and tap Scan', style: ts(wide ? 18 : 15, color: C.muted)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: left / total,
              minHeight: 8,
              backgroundColor: C.surface,
              valueColor: AlwaysStoppedAnimation(C.blue),
            ),
          ),
          const SizedBox(height: 10),
          Text('Code refreshes in ${left}s', style: ts(14, color: C.hint)),
        ],
      );

  Widget _qr(double size) => Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: C.line),
          borderRadius: BorderRadius.circular(16),
        ),
        child: CustomPaint(size: Size(size, size), painter: QrPainter(seed)),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: C.surface,
        body: SafeArea(
          child: Stack(children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: C.bg,
                  border: Border.all(color: C.line),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: LayoutBuilder(builder: (context, c) {
                  final wide = c.maxWidth >= 800;
                  if (wide) {
                    return Row(children: [
                      Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48), child: _info(true))),
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48), child: _qr(300)),
                    ]);
                  }
                  final s = min(300.0, c.maxWidth - 140);
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(children: [_info(false), const SizedBox(height: 24), _qr(s)]),
                  );
                }),
              ),
            ),
            const Positioned(top: 4, right: 4, child: ThemeIconButton()),
            Positioned(
              top: 4,
              left: 4,
              child: IconButton(icon: Icon(Icons.arrow_back, color: C.muted), onPressed: () => Navigator.of(context).pop()),
            ),
          ]),
        ),
      );
}

class QrPainter extends CustomPainter {
  final int seed;
  QrPainter(this.seed);
  static const n = 25;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / n;
    final black = Paint()..color = Colors.black;
    final white = Paint()..color = Colors.white;
    final rnd = Random(seed);
    bool finder(int x, int y) => (x < 8 && y < 8) || (x > 16 && y < 8) || (x < 8 && y > 16);
    for (var y = 0; y < n; y++) {
      for (var x = 0; x < n; x++) {
        final on = rnd.nextDouble() < 0.45;
        if (on && !finder(x, y)) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), black);
        }
      }
    }
    for (final o in const [Offset(0, 0), Offset(18, 0), Offset(0, 18)]) {
      canvas.drawRect(Rect.fromLTWH(o.dx * cell, o.dy * cell, 7 * cell, 7 * cell), black);
      canvas.drawRect(Rect.fromLTWH((o.dx + 1) * cell, (o.dy + 1) * cell, 5 * cell, 5 * cell), white);
      canvas.drawRect(Rect.fromLTWH((o.dx + 2) * cell, (o.dy + 2) * cell, 3 * cell, 3 * cell), black);
    }
  }

  @override
  bool shouldRepaint(covariant QrPainter old) => old.seed != seed;
}
