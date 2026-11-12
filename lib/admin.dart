import 'package:flutter/material.dart';
import 'theme.dart';
import 'main.dart' show LoginScreen;

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});
  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int i = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: IndexedStack(index: i, children: const [
            AdminDashboard(),
            AdminReports(),
            AdminTeachers()
          ]),
        ),
        bottomNavigationBar: BottomNav(
          index: i,
          onTap: (v) => setState(() => i = v),
          items: const [
            NavItem(Icons.grid_view, 'Dashboard'),
            NavItem(Icons.description_outlined, 'Reports'),
            NavItem(Icons.group_outlined, 'Teachers'),
          ],
        ),
      );
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  Widget _violation(String name, String what) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
            color: C.redBg, borderRadius: BorderRadius.circular(8)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(name, style: ts(13, color: C.red)),
          Text(what, style: ts(13, w: FontWeight.w500, color: C.red)),
        ]),
      );

  @override
  Widget build(BuildContext context) => PageBody(
        children: [
          const Heading("Today's attendance", sub: 'Mon, 12 Oct - live'),
          const Row(children: [
            Expanded(child: StatCard('Present', '38')),
            SizedBox(width: 8),
            Expanded(child: StatCard('Late', '4', danger: true)),
            SizedBox(width: 8),
            Expanded(child: StatCard('Absent', '2')),
          ]),
          Column(
              children: gap([
            _violation('Cikgu Hafiz', '7:05 AM - Late'),
            _violation('Cikgu Mei Ling', '6:58 AM - Late'),
            _violation('Cikgu Daud', '12:30 PM - Left early'),
          ], 6)),
          Column(children: [
            LineRow('Cikgu Aina', '6:42 AM', rightColor: C.green),
            LineRow('Cikgu Ramli', '6:35 AM', rightColor: C.green),
            LineRow('Cikgu Siti', '6:31 AM', rightColor: C.green),
          ]),
          Text('Late is after 6:50 AM. Early leave is before 12:50 PM.',
              style: ts(12, color: C.hint)),
          Text('Appearance', style: ts(13, w: FontWeight.w500, color: C.muted)),
          const ThemeChips(),
          AppButton('Sign out',
              outlined: true,
              onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (r) => false)),
        ],
      );
}

class AdminReports extends StatefulWidget {
  const AdminReports({super.key});
  @override
  State<AdminReports> createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  String range = '1 Oct - 31 Oct 2026';
  String teacher = 'All teachers';

  static const ranges = [
    '1 Oct - 31 Oct 2026',
    '1 Sep - 30 Sep 2026',
    '1 Oct - 12 Oct 2026'
  ];
  static const teachers = [
    'All teachers',
    'Cikgu Aina',
    'Cikgu Hafiz',
    'Cikgu Mei Ling',
    'Cikgu Daud',
    'Cikgu Farah'
  ];
  static const stats = {
    'All teachers': [42, 17, 6],
    'Cikgu Aina': [1, 0, 0],
    'Cikgu Hafiz': [1, 5, 0],
    'Cikgu Mei Ling': [1, 3, 1],
    'Cikgu Daud': [1, 2, 2],
    'Cikgu Farah': [1, 1, 0],
  };

  Widget _stat(String l, String v, {Color? c}) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(l, style: ts(13, color: C.muted)),
        Text(v, style: ts(13, w: FontWeight.w500, color: c ?? C.ink)),
      ]);

  Widget _label(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(t, style: ts(12, color: C.muted)));

  @override
  Widget build(BuildContext context) {
    final s = stats[teacher]!;
    return PageBody(
      footer: [
        AppButton('Export PDF',
            icon: Icons.download,
            onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ReportReadyScreen()))),
        AppButton('Print',
            icon: Icons.print_outlined,
            outlined: true,
            onTap: () => toast(context, 'Sending to printer...')),
      ],
      children: [
        Text('Attendance report', style: ts(20, w: FontWeight.w600)),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('Date range'),
          PickerField(
              value: range,
              options: ranges,
              onChanged: (v) => setState(() => range = v)),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('Teacher'),
          PickerField(
              value: teacher,
              options: teachers,
              onChanged: (v) => setState(() => teacher = v)),
        ]),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
              color: C.surface, borderRadius: BorderRadius.circular(12)),
          child: Column(
              children: gap([
            _stat('Teachers', '${s[0]}'),
            _stat('Total late', '${s[1]}', c: C.red),
            _stat('Total left early', '${s[2]}', c: C.red),
            _stat('Format', 'PDF, A4'),
          ], 6)),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AiSummaryScreen())),
            icon: Icon(Icons.auto_awesome, size: 16, color: C.blue),
            label: Text('View AI summary',
                style: ts(13, w: FontWeight.w500, color: C.blue)),
          ),
        ),
      ],
    );
  }
}

class AiSummaryScreen extends StatefulWidget {
  const AiSummaryScreen({super.key});
  @override
  State<AiSummaryScreen> createState() => _AiSummaryScreenState();
}

class _AiSummaryScreenState extends State<AiSummaryScreen> {
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
        Icon(Icons.show_chart, size: 16, color: C.blue),
        const SizedBox(width: 8),
        Expanded(child: Text(t, style: ts(13))),
      ]);

  @override
  Widget build(BuildContext context) => Screen(
        child: PageBody(
          footer: [
            AppButton('Regenerate summary',
                icon: Icons.auto_awesome, onTap: loading ? null : _regen),
            AppButton('Export PDF',
                outlined: true,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ReportReadyScreen()))),
          ],
          children: [
            const BackHeader('Reports'),
            Heading('AI summary',
                sub: 'October 2026 - 42 teachers',
                badge: Pill('AI', fg: C.blue, bg: C.blueBg)),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: C.surface, borderRadius: BorderRadius.circular(12)),
              child: loading
                  ? const Center(
                      child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator()))
                  : Column(
                      children: gap([
                      _bullet(
                          'Late arrivals rose from 9 to 17 this month, mostly on Mondays.'),
                      _bullet(
                          '6 early departures, 4 of them on Fridays before 12:50 PM.'),
                      _bullet(
                          'One teacher accounts for 5 of the late arrivals. The rest of the staff were mostly on time.'),
                    ], 12)),
            ),
            NoteBox(Icons.lock_outline,
                'Names are replaced with codes before data is sent to the AI.',
                fg: C.green, bg: C.greenBg),
            NoteBox(Icons.error_outline,
                'If the AI is unavailable, the report shows the totals table instead.',
                fg: C.amber, bg: C.amberBg),
          ],
        ),
      );
}

class ReportReadyScreen extends StatelessWidget {
  const ReportReadyScreen({super.key});
  @override
  Widget build(BuildContext context) => Screen(
        child: PageBody(
          footer: [
            AppButton('Open PDF',
                icon: Icons.description_outlined,
                onTap: () => toast(context, 'Opening Attendance_Oct2026.pdf')),
            AppButton('Print',
                icon: Icons.print_outlined,
                outlined: true,
                onTap: () => toast(context, 'Sending to printer...')),
            AppButton('Share',
                icon: Icons.download,
                outlined: true,
                onTap: () => toast(context, 'Share sheet would open here')),
          ],
          children: [
            const BackHeader('Reports'),
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration:
                    BoxDecoration(color: C.greenBg, shape: BoxShape.circle),
                child: Icon(Icons.check, size: 36, color: C.green),
              ),
            ),
            Center(
                child: Text('Report ready', style: ts(20, w: FontWeight.w600))),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: C.surface, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Icon(Icons.description_outlined, size: 28, color: C.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Attendance_Oct2026.pdf',
                            style: ts(14, w: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text('A4, 2 pages: monthly summary and daily log',
                            style: ts(12, color: C.muted)),
                      ]),
                ),
              ]),
            ),
            Text(
                'Auditors and education office officers can read the PDF or the printed copy at any time.',
                textAlign: TextAlign.center,
                style: ts(13, color: C.muted)),
          ],
        ),
      );
}

class _T {
  final String name;
  final bool active;
  _T(this.name, this.active);
  String get initials {
    final p = name.replaceFirst('Cikgu ', '').split(' ');
    return p.length > 1
        ? (p[0][0] + p[1][0]).toUpperCase()
        : p[0].substring(0, p[0].length > 1 ? 2 : 1).toUpperCase();
  }
}

class AdminTeachers extends StatefulWidget {
  const AdminTeachers({super.key});
  @override
  State<AdminTeachers> createState() => _AdminTeachersState();
}

class _AdminTeachersState extends State<AdminTeachers> {
  final list = <_T>[
    _T('Cikgu Aina', true),
    _T('Cikgu Hafiz', true),
    _T('Cikgu Mei Ling', true),
    _T('Cikgu Daud', true),
    _T('Cikgu Farah', false),
  ];
  int added = 0; // base: 2 invited (Farah + one not listed)
  String q = '';

  Future<void> _add() async {
    final c = TextEditingController();
    final name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add teacher', style: ts(18, w: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: c,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Teacher name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              AppButton('Send invite',
                  onTap: () => Navigator.pop(ctx, c.text.trim())),
            ]),
      ),
    );
    if (name == null || name.isEmpty) return;
    setState(() {
      list.add(_T(name.startsWith('Cikgu') ? name : 'Cikgu $name', false));
      added++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shown = list
        .where((t) => t.name.toLowerCase().contains(q.toLowerCase()))
        .toList();
    final invited = 2 + added;
    return PageBody(
      footer: [AppButton('Add teacher', icon: Icons.add, onTap: _add)],
      children: [
        Heading('Teachers', sub: '42 active - $invited invited'),
        TextField(
          onChanged: (v) => setState(() => q = v),
          decoration: InputDecoration(
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
          ),
        ),
        Column(children: [
          for (final t in shown)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: C.line))),
              child: Row(children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration:
                      BoxDecoration(color: C.blueBg, shape: BoxShape.circle),
                  child: Text(t.initials,
                      style: ts(12, w: FontWeight.w500, color: C.blue)),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(t.name, style: ts(14))),
                t.active
                    ? Pill('Active', fg: C.green, bg: C.greenBg)
                    : Pill('Invited', fg: C.amber, bg: C.amberBg),
              ]),
            ),
        ]),
        NoteBox(Icons.error_outline,
            '$invited teachers have not finished setup. Send a reminder.',
            fg: C.amber,
            bg: C.amberBg,
            onTap: () => toast(context, 'Reminder sent to $invited teachers')),
      ],
    );
  }
}
