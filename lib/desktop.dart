import 'package:flutter/material.dart';
import 'theme.dart';
import 'station.dart';
import 'main.dart' show LoginScreen;

// ---------- shared desktop widgets ----------

class DeskButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool primary;
  final bool fill;
  const DeskButton(this.label,
      {super.key,
      this.icon,
      this.onTap,
      this.primary = false,
      this.fill = false});
  @override
  Widget build(BuildContext context) {
    final fg = primary ? Colors.white : C.ink;
    return Material(
      color: primary ? C.primary : C.bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: primary ? BorderSide.none : BorderSide(color: C.line),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
              mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 16, color: fg),
                  const SizedBox(width: 8)
                ],
                Text(label, style: ts(14, w: FontWeight.w500, color: fg)),
              ]),
        ),
      ),
    );
  }
}

class DeskPage extends StatelessWidget {
  final String title;
  final String sub;
  final List<Widget> actions;
  final List<Widget> children;
  const DeskPage(
      {super.key,
      required this.title,
      required this.sub,
      this.actions = const [],
      required this.children});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: ts(24, w: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(sub, style: ts(13, color: C.muted)),
                  ]),
            ),
            Wrap(spacing: 10, children: actions),
          ]),
          const SizedBox(height: 20),
          ...gap(children, 20),
        ]),
      );
}

class DeskRow {
  final List<Widget> cells;
  final Color? bg;
  const DeskRow(this.cells, {this.bg});
}

Widget cellText(String s, {Color? c, bool bold = false}) => Text(s,
    style:
        ts(13, w: bold ? FontWeight.w500 : FontWeight.w400, color: c ?? C.ink));

class DeskTable extends StatelessWidget {
  final List<String> heads;
  final List<int> flex;
  final List<DeskRow> rows;
  const DeskTable(
      {super.key, required this.heads, required this.flex, required this.rows});

  Widget _row(List<Widget> cells,
          {Color? bg, bool head = false, bool last = false}) =>
      Container(
        height: head ? 40 : 48,
        decoration: BoxDecoration(
          color: bg ?? (head ? C.surface : C.bg),
          border: last ? null : Border(bottom: BorderSide(color: C.line)),
        ),
        child: Row(children: [
          for (var i = 0; i < cells.length; i++)
            Expanded(
              flex: flex[i],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(alignment: Alignment.centerLeft, child: cells[i]),
              ),
            ),
        ]),
      );

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            border: Border.all(color: C.line),
            borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          _row([for (final h in heads) Text(h, style: ts(13, color: C.muted))],
              head: true),
          for (var i = 0; i < rows.length; i++)
            _row(rows[i].cells, bg: rows[i].bg, last: i == rows.length - 1),
        ]),
      );
}

Widget statusPill(String s) {
  switch (s) {
    case 'Late':
    case 'Left early':
      return Pill(s, fg: C.red, bg: C.redBg);
    case 'On time':
    case 'Active':
      return Pill(s, fg: C.green, bg: C.greenBg);
    case 'Invited':
      return Pill(s, fg: C.amber, bg: C.amberBg);
    default:
      return Pill(s, fg: C.muted, bg: C.surface);
  }
}

InputDecoration searchDec() => InputDecoration(
      hintText: 'Search teachers',
      hintStyle: ts(14, color: C.hint),
      prefixIcon: Icon(Icons.search, size: 16, color: C.muted),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: C.line)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: C.blue)),
    );

BoxDecoration cardDeco() => BoxDecoration(
    color: C.bg,
    border: Border.all(color: C.line),
    borderRadius: BorderRadius.circular(12));

// ---------- login ----------

class DesktopLogin extends StatelessWidget {
  const DesktopLogin({super.key});

  InputDecoration _dec(String h) => InputDecoration(
        hintText: h,
        hintStyle: ts(14, color: C.hint),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: C.line)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: C.blue)),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: C.surface,
        body: Stack(children: [
          const Positioned(top: 8, right: 8, child: ThemeIconButton()),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 440,
                padding: const EdgeInsets.all(36),
                decoration: BoxDecoration(
                    color: C.bg,
                    border: Border.all(color: C.line),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: C.blueBg,
                              borderRadius: BorderRadius.circular(14)),
                          child: Icon(Icons.qr_code_2, size: 32, color: C.blue),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Center(
                          child: Text('EduSync admin',
                              style: ts(22, w: FontWeight.w600))),
                      const SizedBox(height: 14),
                      Center(
                          child: Text('Sign in to monitor teacher attendance',
                              style: ts(13, color: C.muted))),
                      const SizedBox(height: 14),
                      TextField(decoration: _dec('name@school.edu.my')),
                      const SizedBox(height: 14),
                      TextField(
                          obscureText: true, decoration: _dec('Password')),
                      const SizedBox(height: 14),
                      DeskButton('Sign in',
                          primary: true,
                          fill: true,
                          onTap: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => const DesktopShell()))),
                      const SizedBox(height: 14),
                      Center(
                          child: Text(
                              'Only authorised school staff can sign in.',
                              style: ts(12, color: C.hint))),
                      const SizedBox(height: 6),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            phoneMode.value = true;
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()));
                          },
                          child: Text('Teacher? Open the phone view',
                              style: ts(13, w: FontWeight.w500, color: C.blue)),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ]),
      );
}

// ---------- shell ----------

class DesktopShell extends StatefulWidget {
  const DesktopShell({super.key});
  @override
  State<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends State<DesktopShell> {
  int i = 0;

  Widget _nav(int idx, IconData icon, String label) {
    final sel = i == idx;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: sel ? C.blueBg : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => setState(() => i = idx),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(children: [
              Icon(icon, size: 18, color: sel ? C.blue : C.muted),
              const SizedBox(width: 10),
              Text(label,
                  style: ts(14,
                      w: sel ? FontWeight.w500 : FontWeight.w400,
                      color: sel ? C.blue : C.muted)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _sidebar() => Container(
        width: 240,
        decoration: BoxDecoration(
            color: C.surface, border: Border(right: BorderSide(color: C.line))),
        padding: const EdgeInsets.all(16),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 0, 24),
            child: Row(children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    color: C.blueBg, borderRadius: BorderRadius.circular(8)),
                child: Icon(Icons.qr_code_2, size: 20, color: C.blue),
              ),
              const SizedBox(width: 10),
              Text('EduSync', style: ts(15, w: FontWeight.w500)),
            ]),
          ),
          _nav(0, Icons.grid_view, 'Dashboard'),
          _nav(1, Icons.description_outlined, 'Reports'),
          _nav(2, Icons.auto_awesome, 'AI summary'),
          _nav(3, Icons.group_outlined, 'Teachers'),
          const Spacer(),
          const Align(
              alignment: Alignment.centerLeft, child: ThemeIconButton()),
          PopupMenuButton<String>(
            tooltip: '',
            onSelected: (v) {
              if (v == 'qr') {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const StationScreen()));
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (r) => false);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  value: 'qr',
                  child: Text('QR station display', style: ts(14))),
              PopupMenuItem(
                  value: 'out', child: Text('Sign out', style: ts(14))),
            ],
            child: Row(children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(color: C.blueBg, shape: BoxShape.circle),
                child: Text('SA',
                    style: ts(12, w: FontWeight.w500, color: C.blue)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('School administrator',
                          style: ts(13, w: FontWeight.w500),
                          overflow: TextOverflow.ellipsis),
                      Text('Sekolah Kebangsaan Paya Mebi',
                          style: ts(10, color: C.muted),
                          overflow: TextOverflow.ellipsis),
                    ]),
              ),
            ]),
          ),
        ]),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Row(children: [
          _sidebar(),
          Expanded(
            child: IndexedStack(index: i, children: [
              DeskDashboard(onExport: () {
                setState(() => i = 1);
                toast(context, 'Opening reports');
              }),
              const DeskReports(),
              const DeskAi(),
              const DeskTeachers(),
            ]),
          ),
        ]),
      );
}

// ---------- D2 dashboard ----------

class _Att {
  final String name, inT, outT, loc, status;
  const _Att(this.name, this.inT, this.outT, this.loc, this.status);
}

class DeskDashboard extends StatefulWidget {
  final VoidCallback onExport;
  const DeskDashboard({super.key, required this.onExport});
  @override
  State<DeskDashboard> createState() => _DeskDashboardState();
}

class _DeskDashboardState extends State<DeskDashboard> {
  String q = '';
  String day = 'Today';
  static const v = 'Verified (within 50 m)';
  static const data = [
    _Att('Cikgu Hafiz', '7:05 AM', '-', v, 'Late'),
    _Att('Cikgu Mei Ling', '6:58 AM', '-', v, 'Late'),
    _Att('Cikgu Daud', '6:44 AM', '12:30 PM', v, 'Left early'),
    _Att('Cikgu Aina', '6:42 AM', '-', v, 'On time'),
    _Att('Cikgu Ramli', '6:35 AM', '-', v, 'On time'),
    _Att('Cikgu Siti', '6:31 AM', '-', v, 'On time'),
    _Att('Cikgu Jamal', '-', '-', '-', 'Absent'),
  ];

  @override
  Widget build(BuildContext context) {
    final rows = data
        .where((a) => a.name.toLowerCase().contains(q.toLowerCase()))
        .toList();
    return DeskPage(
      title: "Today's attendance",
      sub: 'Monday, 12 October 2026 - updates live',
      actions: [
        DeskButton('Export PDF', icon: Icons.download, onTap: widget.onExport)
      ],
      children: [
        const Row(children: [
          Expanded(child: _BigStat('Present', '38')),
          SizedBox(width: 16),
          Expanded(child: _BigStat('Late (after 6:50 AM)', '4', danger: true)),
          SizedBox(width: 16),
          Expanded(
              child:
                  _BigStat('Left early (before 12:50 PM)', '1', danger: true)),
          SizedBox(width: 16),
          Expanded(child: _BigStat('Absent', '2')),
        ]),
        Row(children: [
          SizedBox(
              width: 320,
              child: TextField(
                  onChanged: (s) => setState(() => q = s),
                  decoration: searchDec())),
          const SizedBox(width: 12),
          SizedBox(
              width: 130,
              child: PickerField(
                  value: day,
                  options: const ['Today', 'Yesterday'],
                  onChanged: (s) {
                    setState(() => day = s);
                    if (s != 'Today')
                      toast(context, 'Sample data is only available for today');
                  })),
        ]),
        DeskTable(
          heads: const [
            'Teacher',
            'Check-in',
            'Check-out',
            'Location',
            'Status'
          ],
          flex: const [28, 16, 16, 24, 28],
          rows: [
            for (final a in rows)
              DeskRow([
                cellText(a.name),
                cellText(a.inT,
                    c: a.status == 'Late' || a.status == 'Left early'
                        ? C.red
                        : C.ink),
                cellText(a.outT),
                cellText(a.loc),
                statusPill(a.status),
              ],
                  bg: a.status == 'Late' || a.status == 'Left early'
                      ? C.redBg
                      : null),
          ],
        ),
        Text(
            'Red marks a late arrival (after 6:50 AM) or an early departure (before 12:50 PM). Sample data.',
            style: ts(12, color: C.hint)),
      ],
    );
  }
}

class _BigStat extends StatelessWidget {
  final String label, value;
  final bool danger;
  const _BigStat(this.label, this.value, {this.danger = false});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
            color: danger ? C.redBg : C.surface,
            borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: ts(13, color: danger ? C.red : C.muted)),
          const SizedBox(height: 6),
          Text(value,
              style: ts(32, w: FontWeight.w600, color: danger ? C.red : C.ink)),
        ]),
      );
}

// ---------- D3 reports ----------

class DeskReports extends StatefulWidget {
  const DeskReports({super.key});
  @override
  State<DeskReports> createState() => _DeskReportsState();
}

class _DeskReportsState extends State<DeskReports> {
  String range = '1 Oct - 31 Oct 2026';
  String teacher = 'All teachers';
  String type = 'Monthly summary + daily log';
  bool ready = false;

  static const sample = [
    ['Cikgu Aina', '22', '3', '1'],
    ['Cikgu Hafiz', '21', '5', '0'],
    ['Cikgu Mei Ling', '22', '2', '1'],
    ['Cikgu Daud', '20', '1', '3'],
    ['Cikgu Siti', '22', '0', '0'],
    ['Cikgu Ramli', '22', '1', '0'],
  ];

  void _export() => setState(() => ready = true);

  @override
  Widget build(BuildContext context) {
    final rows = sample
        .where((r) => teacher == 'All teachers' || r[0] == teacher)
        .toList();
    return DeskPage(
      title: 'Attendance reports',
      sub:
          'Generate a record that auditors and education officers can read later',
      children: [
        if (ready)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
                color: C.greenBg, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Icon(Icons.check, size: 18, color: C.green),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                    'Report ready: Attendance_Oct2026.pdf (A4, 2 pages: monthly summary and daily log)',
                    style: ts(13, color: C.green)),
              ),
              DeskButton('Open PDF',
                  onTap: () =>
                      toast(context, 'Opening Attendance_Oct2026.pdf')),
              const SizedBox(width: 12),
              DeskButton('Print',
                  icon: Icons.print_outlined,
                  onTap: () => toast(context, 'Sending to printer...')),
              const SizedBox(width: 12),
              DeskButton('Share',
                  onTap: () => toast(context, 'Share sheet would open here')),
            ]),
          ),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            decoration: cardDeco(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Report options', style: ts(14, w: FontWeight.w500)),
                  const SizedBox(height: 14),
                  _lbl('Date range'),
                  PickerField(
                      value: range,
                      options: const [
                        '1 Oct - 31 Oct 2026',
                        '1 Sep - 30 Sep 2026'
                      ],
                      onChanged: (v) => setState(() => range = v)),
                  const SizedBox(height: 14),
                  _lbl('Teacher'),
                  PickerField(
                      value: teacher,
                      options: const [
                        'All teachers',
                        'Cikgu Aina',
                        'Cikgu Hafiz',
                        'Cikgu Mei Ling',
                        'Cikgu Daud',
                        'Cikgu Siti',
                        'Cikgu Ramli'
                      ],
                      onChanged: (v) => setState(() => teacher = v)),
                  const SizedBox(height: 14),
                  _lbl('Report type'),
                  PickerField(
                      value: type,
                      options: const [
                        'Monthly summary + daily log',
                        'Monthly summary only'
                      ],
                      onChanged: (v) => setState(() => type = v)),
                  const SizedBox(height: 56),
                  DeskButton('Export PDF',
                      icon: Icons.download,
                      primary: true,
                      fill: true,
                      onTap: _export),
                  const SizedBox(height: 10),
                  DeskButton('Print',
                      icon: Icons.print_outlined,
                      fill: true,
                      onTap: () => toast(context, 'Sending to printer...')),
                ]),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: cardDeco(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Preview: monthly summary, $range',
                        style: ts(14, w: FontWeight.w500)),
                    const SizedBox(height: 14),
                    DeskTable(
                      heads: const [
                        'Teacher',
                        'Present',
                        'Late (after 6:50)',
                        'Left early (before 12:50)'
                      ],
                      flex: const [26, 10, 17, 22],
                      rows: [
                        for (final r in rows)
                          DeskRow([
                            cellText(r[0]),
                            cellText(r[1]),
                            cellText(r[2], c: r[2] != '0' ? C.red : C.ink),
                            cellText(r[3], c: r[3] != '0' ? C.red : C.ink),
                          ]),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                        'Sample data: ${rows.length} of 42 teachers shown. The PDF includes all teachers, a daily log, and signature lines for the administrator and principal.',
                        style: ts(12, color: C.hint)),
                  ]),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _lbl(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(t, style: ts(12, color: C.muted)));
}

// ---------- D4 AI summary ----------

class DeskAi extends StatefulWidget {
  const DeskAi({super.key});
  @override
  State<DeskAi> createState() => _DeskAiState();
}

class _DeskAiState extends State<DeskAi> {
  bool loading = false;

  Future<void> _regen() async {
    setState(() => loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => loading = false);
    toast(context, 'Summary regenerated');
  }

  Widget _bullet(String t) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(Icons.show_chart, size: 18, color: C.blue),
        const SizedBox(width: 10),
        Expanded(child: Text(t, style: ts(14))),
      ]);

  Widget _bar(String day, int v) => Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text('$v', style: ts(13, color: C.muted)),
          const SizedBox(height: 6),
          Container(
            height: v * 28.0,
            margin: const EdgeInsets.symmetric(horizontal: 17),
            decoration: BoxDecoration(
                color: C.blue, borderRadius: BorderRadius.circular(6)),
          ),
          const SizedBox(height: 8),
          Text(day, style: ts(13, color: C.muted)),
        ]),
      );

  @override
  Widget build(BuildContext context) => DeskPage(
        title: 'AI attendance summary',
        sub: 'October 2026 - 42 teachers',
        actions: [
          DeskButton('Regenerate summary',
              icon: Icons.auto_awesome,
              primary: true,
              onTap: loading ? null : _regen),
          DeskButton('Export PDF',
              icon: Icons.download,
              onTap: () => toast(context, 'AI_Summary_Oct2026.pdf saved')),
        ],
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 594,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: cardDeco(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Key insights', style: ts(15, w: FontWeight.w500)),
                      const SizedBox(height: 16),
                      if (loading)
                        const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(child: CircularProgressIndicator()))
                      else
                        ...gap([
                          _bullet(
                              'Late arrivals rose from 9 to 17 this month, mostly on Mondays.'),
                          _bullet(
                              '6 early departures, 4 of them on Fridays before 12:50 PM.'),
                          _bullet(
                              'One teacher accounts for 5 of the late arrivals. The rest of the staff were mostly on time.'),
                        ], 14),
                      const SizedBox(height: 18),
                      NoteBox(Icons.lock_outline,
                          'Names are replaced with codes before data is sent to the AI service.',
                          fg: C.green, bg: C.greenBg),
                      const SizedBox(height: 14),
                      NoteBox(Icons.error_outline,
                          'If the AI service is unavailable, the report shows the plain totals table instead.',
                          fg: C.amber, bg: C.amberBg),
                    ]),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 520,
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: cardDeco(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Late arrivals by weekday (October)',
                          style: ts(14, w: FontWeight.w500)),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 260,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _bar('Mon', 7),
                              _bar('Tue', 3),
                              _bar('Wed', 2),
                              _bar('Thu', 2),
                              _bar('Fri', 3),
                            ]),
                      ),
                      const SizedBox(height: 14),
                      Text('Sample data. Totals: 17 late arrivals.',
                          style: ts(12, color: C.hint)),
                    ]),
              ),
            ),
          ]),
        ],
      );
}

// ---------- D5 teachers ----------

class _Teacher {
  String name;
  String email;
  final String status;
  final String last;
  _Teacher(this.name, this.email, this.status, this.last);
}

class DeskTeachers extends StatefulWidget {
  const DeskTeachers({super.key});
  @override
  State<DeskTeachers> createState() => _DeskTeachersState();
}

class _DeskTeachersState extends State<DeskTeachers> {
  String q = '';
  final list = <_Teacher>[
    _Teacher('Cikgu Aina', 'aina@school.edu.my', 'Active', '6:42 AM'),
    _Teacher('Cikgu Hafiz', 'hafiz@school.edu.my', 'Active', '7:05 AM'),
    _Teacher('Cikgu Mei Ling', 'meiling@school.edu.my', 'Active', '6:58 AM'),
    _Teacher('Cikgu Daud', 'daud@school.edu.my', 'Active', '6:44 AM'),
    _Teacher('Cikgu Siti', 'siti@school.edu.my', 'Active', '6:31 AM'),
    _Teacher('Cikgu Ramli', 'ramli@school.edu.my', 'Active', '6:35 AM'),
    _Teacher('Cikgu Farah', 'farah@school.edu.my', 'Invited', '-'),
    _Teacher('Cikgu Nurul', 'nurul@school.edu.my', 'Invited', '-'),
  ];

  int get invited => list.where((t) => t.status == 'Invited').length;

  String _email(String name) =>
      '${name.replaceFirst('Cikgu ', '').toLowerCase().replaceAll(' ', '')}@school.edu.my';

  Future<void> _addOrEdit([_Teacher? t]) async {
    final c = TextEditingController(text: t?.name ?? '');
    final res = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t == null ? 'Add teacher' : 'Edit teacher',
            style: ts(18, w: FontWeight.w600)),
        content: TextField(
            controller: c,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Teacher name')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, c.text.trim()),
              child: Text(t == null ? 'Send invite' : 'Save')),
        ],
      ),
    );
    if (res == null || res.isEmpty) return;
    final name = res.startsWith('Cikgu') ? res : 'Cikgu $res';
    setState(() {
      if (t == null) {
        list.add(_Teacher(name, _email(name), 'Invited', '-'));
      } else {
        t.name = name;
        t.email = _email(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rows = list
        .where((t) => t.name.toLowerCase().contains(q.toLowerCase()))
        .toList();
    return DeskPage(
      title: 'Teachers',
      sub: '42 active - $invited invited',
      actions: [
        DeskButton('Add teacher',
            icon: Icons.add, primary: true, onTap: () => _addOrEdit())
      ],
      children: [
        NoteBox(Icons.error_outline,
            '$invited teachers have not finished setup. Send a reminder.',
            fg: C.amber,
            bg: C.amberBg,
            onTap: () => toast(context, 'Reminder sent to $invited teachers')),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
              width: 320,
              child: TextField(
                  onChanged: (s) => setState(() => q = s),
                  decoration: searchDec())),
        ),
        DeskTable(
          heads: const [
            'Teacher',
            'School email',
            'Status',
            'Last scan today',
            'Actions'
          ],
          flex: const [28, 32, 16, 20, 18],
          rows: [
            for (final t in rows)
              DeskRow([
                cellText(t.name),
                cellText(t.email),
                statusPill(t.status),
                cellText(t.last),
                InkWell(
                  onTap: () => t.status == 'Invited'
                      ? toast(context, 'Reminder sent to ${t.name}')
                      : _addOrEdit(t),
                  child: Text(t.status == 'Invited' ? 'Send reminder' : 'Edit',
                      style: ts(13, w: FontWeight.w500, color: C.blue)),
                ),
              ]),
          ],
        ),
        Text('Sample teacher names and emails.', style: ts(12, color: C.hint)),
      ],
    );
  }
}
