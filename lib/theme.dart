import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class C {
  static bool dark = false;
  static Color _p(int l, int d) => Color(dark ? d : l);
  static Color get bg => _p(0xFFFFFFFF, 0xFF171F2B);
  static Color get ink => _p(0xFF1F1F1E, 0xFFF2F5FA);
  static Color get muted => _p(0xFF6B6A66, 0xFFBEC8D6);
  static Color get hint => _p(0xFF9A9893, 0xFF9EACC0);
  static Color get line => _p(0xFFDDDCD7, 0xFF758398);
  static Color get surface => _p(0xFFF4F4F2, 0xFF10151D);
  static Color get blue => _p(0xFF185FA5, 0xFF8DC5FF);
  static Color get primary => _p(0xFF185FA5, 0xFF246DB0);
  static Color get blueBg => _p(0xFFE6F1FB, 0xFF18334E);
  static Color get blueLine => _p(0xFF85B7EB, 0xFF8DC5FF);
  static Color get green => _p(0xFF3B6D11, 0xFFB1DC87);
  static Color get greenBg => _p(0xFFEAF3DE, 0xFF20351D);
  static Color get red => _p(0xFFA32D2D, 0xFFFFB3B3);
  static Color get redBg => _p(0xFFFCEBEB, 0xFF422329);
  static Color get redNote => _p(0xFFD61818, 0xFFFFB3B3);
  static Color get amber => _p(0xFF854F0B, 0xFFF6CF8A);
  static Color get amberBg => _p(0xFFFAEEDA, 0xFF3C2E18);
}

final ValueNotifier<bool> phoneMode = ValueNotifier(false);

final ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

void rebuildAll() {
  void r(Element e) {
    e.markNeedsBuild();
    e.visitChildren(r);
  }

  WidgetsBinding.instance.rootElement?.visitChildren(r);
}

TextStyle ts(double size, {FontWeight w = FontWeight.w400, Color? color}) =>
    GoogleFonts.inter(fontSize: size, fontWeight: w, color: color ?? C.ink);

ThemeData buildTheme(bool dark) {
  final prev = C.dark;
  C.dark = dark;
  final b = dark ? Brightness.dark : Brightness.light;
  final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF185FA5), brightness: b)
      .copyWith(primary: C.primary, surface: C.bg, onSurface: C.ink);
  final base = ThemeData(
    useMaterial3: true,
    brightness: b,
    colorScheme: scheme,
    scaffoldBackgroundColor: C.bg,
    canvasColor: C.bg,
    dividerColor: C.line,
  );
  final out = base.copyWith(textTheme: GoogleFonts.interTextTheme(base.textTheme));
  C.dark = prev;
  return out;
}

List<Widget> gap(List<Widget> l, double h) {
  final o = <Widget>[];
  for (var i = 0; i < l.length; i++) {
    if (i > 0) o.add(SizedBox(height: h));
    o.add(l[i]);
  }
  return o;
}

void toast(BuildContext c, String msg) {
  ScaffoldMessenger.of(c)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
}

class Screen extends StatelessWidget {
  final Widget child;
  const Screen({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Scaffold(body: SafeArea(child: child));
}

class PageBody extends StatelessWidget {
  final List<Widget> children;
  final List<Widget> footer;
  const PageBody({super.key, required this.children, this.footer = const []});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: gap(children, 14)),
        ),
      ),
      if (footer.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: gap(footer, 8)),
        ),
    ]);
  }
}

class BackHeader extends StatelessWidget {
  final String title;
  const BackHeader(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Row(children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Padding(padding: const EdgeInsets.all(4), child: Icon(Icons.arrow_back, size: 20, color: C.ink)),
        ),
        const SizedBox(width: 8),
        Text(title, style: ts(16, w: FontWeight.w500)),
      ]);
}

class Heading extends StatelessWidget {
  final String title;
  final String? sub;
  final Widget? badge;
  const Heading(this.title, {super.key, this.sub, this.badge});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(title, style: ts(20, w: FontWeight.w600)),
          if (badge != null) ...[const SizedBox(width: 8), badge!],
        ]),
        if (sub != null) ...[const SizedBox(height: 2), Text(sub!, style: ts(12, color: C.muted))],
      ]);
}

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool outlined;
  const AppButton(this.label, {super.key, this.icon, this.onTap, this.outlined = false});
  @override
  Widget build(BuildContext context) {
    final fg = outlined ? C.ink : Colors.white;
    return Material(
      color: outlined ? C.bg : C.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: outlined ? BorderSide(color: C.line) : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (icon != null) ...[Icon(icon, size: 18, color: fg), const SizedBox(width: 8)],
            Text(label, style: ts(15, w: FontWeight.w500, color: fg)),
          ]),
        ),
      ),
    );
  }
}

class Pill extends StatelessWidget {
  final String text;
  final Color fg;
  final Color bg;
  const Pill(this.text, {super.key, required this.fg, required this.bg});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: ts(12, w: FontWeight.w500, color: fg)),
      );
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool danger;
  const StatCard(this.label, this.value, {super.key, this.danger = false});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: danger ? C.redBg : C.surface, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: ts(12, color: danger ? C.red : C.muted)),
          const SizedBox(height: 4),
          Text(value, style: ts(24, w: FontWeight.w600, color: danger ? C.red : C.ink)),
        ]),
      );
}

class NoteBox extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color fg;
  final Color bg;
  final VoidCallback? onTap;
  const NoteBox(this.icon, this.text, {super.key, required this.fg, required this.bg, this.onTap});
  @override
  Widget build(BuildContext context) => Material(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 8),
              Expanded(child: Text(text, style: ts(12, color: fg))),
            ]),
          ),
        ),
      );
}

class LineRow extends StatelessWidget {
  final String left;
  final String right;
  final Color? rightColor;
  const LineRow(this.left, this.right, {super.key, this.rightColor});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: C.line))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(left, style: ts(14)),
          Text(right, style: ts(14, w: FontWeight.w500, color: rightColor ?? C.ink)),
        ]),
      );
}

class DashedBox extends StatelessWidget {
  final double size;
  final Widget child;
  const DashedBox({super.key, required this.size, required this.child});
  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _DashPainter(),
        child: SizedBox(width: size, height: size, child: Center(child: child)),
      );
}

class _DashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = C.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(12)));
    for (final m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 6), p);
        d += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class NavItem {
  final IconData icon;
  final String label;
  const NavItem(this.icon, this.label);
}

class BottomNav extends StatelessWidget {
  final List<NavItem> items;
  final int index;
  final ValueChanged<int> onTap;
  const BottomNav({super.key, required this.items, required this.index, required this.onTap});
  @override
  Widget build(BuildContext context) => Container(
        color: C.surface,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              for (var i = 0; i < items.length; i++)
                InkWell(
                  onTap: () => onTap(i),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(items[i].icon, size: 22, color: i == index ? C.blue : C.muted),
                    const SizedBox(height: 2),
                    Text(items[i].label,
                        style: ts(11, w: i == index ? FontWeight.w500 : FontWeight.w400, color: i == index ? C.blue : C.muted)),
                  ]),
                ),
            ]),
          ),
        ),
      );
}

class PickerField extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  const PickerField({super.key, required this.value, required this.options, required this.onChanged});
  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          builder: (_) => SafeArea(
            child: ListView(shrinkWrap: true, children: [
              for (final o in options)
                ListTile(
                  title: Text(o, style: ts(14)),
                  trailing: o == value ? Icon(Icons.check, color: C.blue) : null,
                  onTap: () {
                    onChanged(o);
                    Navigator.pop(context);
                  },
                ),
            ]),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(border: Border.all(color: C.line), borderRadius: BorderRadius.circular(10)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(value, style: ts(14)),
            Icon(Icons.keyboard_arrow_down, size: 18, color: C.muted),
          ]),
        ),
      );
}

IconData _modeIcon(ThemeMode m) => m == ThemeMode.light
    ? Icons.light_mode_outlined
    : m == ThemeMode.dark
        ? Icons.dark_mode_outlined
        : Icons.brightness_auto_outlined;

class ThemeIconButton extends StatelessWidget {
  const ThemeIconButton({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (context, m, _) => IconButton(
          tooltip: 'Theme: ${m.name} (tap to change)',
          icon: Icon(_modeIcon(m), color: C.muted),
          onPressed: () => themeMode.value = m == ThemeMode.system
              ? ThemeMode.light
              : m == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.system,
        ),
      );
}

class ThemeChips extends StatelessWidget {
  const ThemeChips({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (context, m, _) => Wrap(spacing: 8, children: [
          for (final e in const {'System': ThemeMode.system, 'Light': ThemeMode.light, 'Dark': ThemeMode.dark}.entries)
            ChoiceChip(
              label: Text(e.key, style: ts(12)),
              selected: m == e.value,
              selectedColor: C.blueBg,
              onSelected: (_) => themeMode.value = e.value,
            ),
        ]),
      );
}
