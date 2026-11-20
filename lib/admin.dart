import 'package:flutter/material.dart';
import 'theme.dart';
import 'app_state.dart';
import 'main.dart' show LoginScreen, showLanguageSheet;

// ---------- shared print preview & full PDF dialogs ----------

Future<void> showFullPdfDialog(BuildContext context,
    {String range = '1 Oct - 31 Oct 2026'}) async {
  const rows = [
    ['1', 'Cikgu Aina', '22', '0', '0'],
    ['2', 'Cikgu Hafiz', '21', '5', '0'],
    ['3', 'Cikgu Mei Ling', '22', '3', '1'],
    ['4', 'Cikgu Daud', '20', '2', '2'],
    ['5', 'Cikgu Ramli', '22', '1', '0'],
    ['6', 'Cikgu Siti', '22', '0', '0'],
  ];
  await showDialog<void>(
    context: context,
    builder: (ctx) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Monthly summary · 1 of 2',
                        style: ts(13, w: FontWeight.w600)),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: Text('Close', style: ts(12, color: C.blue)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: C.blueLine, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Sekolah Kebangsaan Paya Mebi',
                          style:
                              ts(13, w: FontWeight.w600, color: Colors.black)),
                      Text('Staff Attendance Monthly Summary ($range)',
                          style: ts(11, color: Colors.black54)),
                      const SizedBox(height: 10),
                      Container(
                        color: const Color(0xFF185FA5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        child: Row(children: [
                          Expanded(
                              flex: 4,
                              child: Text('Staff',
                                  style: ts(11,
                                      w: FontWeight.w600,
                                      color: Colors.white))),
                          Expanded(
                              flex: 2,
                              child: Text('Present',
                                  style: ts(11,
                                      w: FontWeight.w600,
                                      color: Colors.white))),
                          Expanded(
                              flex: 2,
                              child: Text('Late',
                                  style: ts(11,
                                      w: FontWeight.w600,
                                      color: Colors.white))),
                          Expanded(
                              flex: 2,
                              child: Text('Early',
                                  style: ts(11,
                                      w: FontWeight.w600,
                                      color: Colors.white))),
                        ]),
                      ),
                      for (final r in rows)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Color(0xFFE0E0E0))),
                          ),
                          child: Row(children: [
                            Expanded(
                                flex: 4,
                                child: Text(r[1],
                                    style: ts(11, color: Colors.black87))),
                            Expanded(
                                flex: 2,
                                child: Text(r[2],
                                    style: ts(11, color: Colors.black87))),
                            Expanded(
                                flex: 2,
                                child: Text(r[3],
                                    style: ts(11,
                                        color: r[3] != '0'
                                            ? const Color(0xFFA32D2D)
                                            : Colors.black87))),
                            Expanded(
                                flex: 2,
                                child: Text(r[4],
                                    style: ts(11,
                                        color: r[4] != '0'
                                            ? const Color(0xFFA32D2D)
                                            : Colors.black87))),
                          ]),
                        ),
                      const SizedBox(height: 18),
                      Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 1, color: Colors.black45),
                              const SizedBox(height: 4),
                              Text('Prepared by (Admin)',
                                  style: ts(10, color: Colors.black54)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 1, color: Colors.black45),
                              const SizedBox(height: 4),
                              Text('Verified by (Principal)',
                                  style: ts(10, color: Colors.black54)),
                            ],
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> showPrintPreviewSheet(BuildContext context,
    {String range = '1 Oct - 31 Oct 2026'}) async {
  String printer = 'Office printer (HP)';
  int copies = 1;
  String pages = 'All (2)';
  String colour = 'Black and white';
  bool sent = false;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: SingleChildScrollView(
            child: sent
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                              color: C.greenBg, shape: BoxShape.circle),
                          child: Icon(Icons.print_outlined,
                              size: 32, color: C.green),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                          child: Text('Sent to printer',
                              style: ts(20, w: FontWeight.w600))),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: C.surface,
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(children: [
                          Icon(Icons.description_outlined,
                              size: 26, color: C.blue),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Attendance_Oct2026.pdf',
                                    style: ts(14, w: FontWeight.w500)),
                                Text(
                                    '2 pages, $copies ${copies == 1 ? 'copy' : 'copies'}, $printer',
                                    style: ts(12, color: C.muted)),
                              ],
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 12),
                      Row(children: [
                        Icon(Icons.check, size: 16, color: C.green),
                        const SizedBox(width: 8),
                        Text('Report created', style: ts(13, color: C.green)),
                      ]),
                      const SizedBox(height: 6),
                      Row(children: [
                        Icon(Icons.check, size: 16, color: C.green),
                        const SizedBox(width: 8),
                        Text('Sent to $printer', style: ts(13, color: C.green)),
                      ]),
                      const SizedBox(height: 6),
                      Row(children: [
                        Icon(Icons.print_outlined, size: 16, color: C.amber),
                        const SizedBox(width: 8),
                        Text('Printing: page 1 of 2',
                            style: ts(13, color: C.amber)),
                      ]),
                      const SizedBox(height: 18),
                      AppButton('View PDF',
                          icon: Icons.description_outlined,
                          onTap: () => showFullPdfDialog(ctx, range: range)),
                      const SizedBox(height: 8),
                      AppButton('Back to reports',
                          outlined: true, onTap: () => Navigator.pop(ctx)),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Print report', style: ts(18, w: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                            color: C.surface,
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(children: [
                          Container(
                            width: 110,
                            height: 130,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: C.line),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text('Teacher Attendance Report',
                                    style: ts(7,
                                        w: FontWeight.w600,
                                        color: Colors.black)),
                                const SizedBox(height: 4),
                                Container(
                                    height: 6, color: const Color(0xFF185FA5)),
                                const SizedBox(height: 6),
                                for (var k = 0; k < 5; k++) ...[
                                  Container(
                                      height: 5,
                                      color: k.isOdd
                                          ? const Color(0xFFFCEBEB)
                                          : const Color(0xFFF4F4F2)),
                                  const SizedBox(height: 5),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Page 1 of 2  ',
                                  style: ts(12, color: C.muted)),
                              InkWell(
                                onTap: () =>
                                    showFullPdfDialog(ctx, range: range),
                                child: Text('View full PDF',
                                    style: ts(12,
                                        w: FontWeight.w600, color: C.blue)),
                              ),
                            ],
                          ),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: C.green, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text('Printer connected',
                            style: ts(12, color: C.green)),
                      ]),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            border: Border.all(color: C.line),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: gap([
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Printer', style: ts(13, color: C.muted)),
                                SizedBox(
                                  width: 185,
                                  child: PickerField(
                                    value: printer,
                                    options: const [
                                      'Office printer (HP)',
                                      'Staff room (Canon)'
                                    ],
                                    onChanged: (v) => setS(() => printer = v),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Copies', style: ts(13, color: C.muted)),
                                Row(children: [
                                  IconButton(
                                    icon: const Icon(
                                        Icons.remove_circle_outline,
                                        size: 20),
                                    onPressed: copies > 1
                                        ? () => setS(() => copies--)
                                        : null,
                                  ),
                                  Text('$copies',
                                      style: ts(14, w: FontWeight.w600)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline,
                                        size: 20),
                                    onPressed: () => setS(() => copies++),
                                  ),
                                ]),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Pages', style: ts(13, color: C.muted)),
                                SizedBox(
                                  width: 140,
                                  child: PickerField(
                                    value: pages,
                                    options: const ['All (2)', 'Page 1 only'],
                                    onChanged: (v) => setS(() => pages = v),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Colour', style: ts(13, color: C.muted)),
                                SizedBox(
                                  width: 165,
                                  child: PickerField(
                                    value: colour,
                                    options: const [
                                      'Black and white',
                                      'Colour'
                                    ],
                                    onChanged: (v) => setS(() => colour = v),
                                  ),
                                ),
                              ],
                            ),
                          ], 8),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AppButton('Print',
                          icon: Icons.print_outlined,
                          onTap: () => setS(() => sent = true)),
                      const SizedBox(height: 8),
                      AppButton('Save as PDF',
                          icon: Icons.description_outlined,
                          outlined: true, onTap: () {
                        Navigator.pop(ctx);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const ReportReadyScreen()));
                      }),
                    ],
                  ),
          ),
        ),
      ),
    ),
  );
}

// ---------- admin attendance rules modal (R2-F1) ----------

Future<void> showAttendanceRulesSheet(BuildContext context) async {
  bool forAkp = false;
  int lateMin = app.teacherLateMin;
  int graceMin = app.teacherGraceMin;
  int earlyMin = app.teacherEarlyMin;
  int qrSec = app.qrRefreshSeconds;

  void loadRole(bool akp) {
    forAkp = akp;
    lateMin = akp ? app.akpLateMin : app.teacherLateMin;
    graceMin = akp ? app.akpGraceMin : app.teacherGraceMin;
    earlyMin = akp ? app.akpEarlyMin : app.teacherEarlyMin;
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) {
        Widget roleTab(String label, bool akp) {
          final sel = forAkp == akp;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => setS(() => loadRole(akp)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: sel ? C.blueBg : C.bg,
                  border: Border.all(color: sel ? C.blueLine : C.line),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(label,
                    style: ts(13,
                        w: FontWeight.w500, color: sel ? C.blue : C.ink)),
              ),
            ),
          );
        }

        Widget stepperRow(String label, String value, VoidCallback onMinus,
            VoidCallback onPlus) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: ts(13, color: C.muted)),
              Row(children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 20),
                  onPressed: onMinus,
                ),
                SizedBox(
                  width: 78,
                  child: Text(value,
                      textAlign: TextAlign.center,
                      style: ts(14, w: FontWeight.w600)),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  onPressed: onPlus,
                ),
              ]),
            ],
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Attendance rules', style: ts(18, w: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Text('Rules for  ', style: ts(13, color: C.muted)),
                    roleTab('Teachers', false),
                    const SizedBox(width: 8),
                    roleTab('Support staff (AKP)', true),
                  ]),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(color: C.line),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Late arrival', style: ts(13, w: FontWeight.w600)),
                        stepperRow(
                          'Late after',
                          formatMinutes(lateMin),
                          () => setS(() => lateMin -= 5),
                          () => setS(() => lateMin += 5),
                        ),
                        stepperRow(
                          'Grace period',
                          '$graceMin min',
                          () => setS(() {
                            if (graceMin > 0) graceMin -= 5;
                          }),
                          () => setS(() => graceMin += 5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(color: C.line),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Early departure',
                            style: ts(13, w: FontWeight.w600)),
                        stepperRow(
                          'Left early before',
                          formatMinutes(earlyMin),
                          () => setS(() => earlyMin -= 5),
                          () => setS(() => earlyMin += 5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(color: C.line),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('QR code', style: ts(13, w: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('New code every',
                                style: ts(13, color: C.muted)),
                            Wrap(spacing: 6, children: [
                              for (final sec in const [3, 4, 5])
                                ChoiceChip(
                                  label: Text('$sec s', style: ts(12)),
                                  selected: qrSec == sec,
                                  selectedColor: C.blueBg,
                                  onSelected: (_) => setS(() => qrSec = sec),
                                ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      'Changes start from the next school day. Past records keep the old rules.',
                      style: ts(12, color: C.hint)),
                  const SizedBox(height: 14),
                  AppButton('Save changes', onTap: () {
                    app.updateRules(
                      forAkp: forAkp,
                      lateMin: lateMin,
                      graceMin: graceMin,
                      earlyMin: earlyMin,
                      qrSeconds: qrSec,
                    );
                    Navigator.pop(ctx);
                    toast(context, 'Attendance rules saved');
                  }),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

// ---------- admin shell & tabs ----------

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

  Widget _quickTile(BuildContext context, IconData icon, String title,
          String sub, VoidCallback onTap) =>
      InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: C.line),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: C.blueBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: C.blue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: ts(14, w: FontWeight.w500)),
                  Text(sub, style: ts(12, color: C.muted)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: C.muted),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) => PageBody(
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
            Text(
                'Teachers: late after ${app.teacherLateStr}, early before ${app.teacherEarlyStr}. AKP: late after ${app.akpLateStr}. QR every ${app.qrRefreshSeconds}s.',
                style: ts(12, color: C.hint)),
            _quickTile(
              context,
              Icons.tune,
              'Attendance rules',
              'Late and early times, QR timing (${app.qrRefreshSeconds}s)',
              () => showAttendanceRulesSheet(context),
            ),
            _quickTile(
              context,
              Icons.language,
              'Language and account',
              '${app.language}, email, password',
              () => showLanguageSheet(context),
            ),
            Text('Appearance',
                style: ts(13, w: FontWeight.w500, color: C.muted)),
            const ThemeChips(),
            AppButton('Sign out',
                outlined: true,
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (r) => false)),
          ],
        ),
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
        AppButton('Print or preview',
            icon: Icons.print_outlined,
            outlined: true,
            onTap: () => showPrintPreviewSheet(context, range: range)),
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
                onTap: () => showFullPdfDialog(context)),
            AppButton('Print',
                icon: Icons.print_outlined,
                outlined: true,
                onTap: () => showPrintPreviewSheet(context)),
            AppButton('Share',
                icon: Icons.share_outlined,
                outlined: true,
                onTap: () => showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Share report',
                            style: ts(18, w: FontWeight.w600)),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Attendance_Oct2026.pdf',
                                style: ts(14, w: FontWeight.w500)),
                            const SizedBox(height: 6),
                            Text(
                                'Prototype preview: no PDF is uploaded or shared. In the finished app, this opens your device share sheet.',
                                style: ts(12, color: C.muted)),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Back to report')),
                        ],
                      ),
                    )),
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

class _AkpStaff {
  final String name;
  final String dept;
  final String category; // IT, Office, Other
  final String time;
  final String status; // On time, Late, Absent, Invited
  _AkpStaff(this.name, this.dept, this.category, this.time, this.status);
  String get initials {
    final clean = name
        .replaceFirst('En. ', '')
        .replaceFirst('Pn. ', '')
        .replaceFirst('Cik ', '');
    final p = clean.split(' ');
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
  bool showAkp = false;
  String akpFilter = 'All';
  String q = '';

  final list = <_T>[
    _T('Cikgu Aina', true),
    _T('Cikgu Hafiz', true),
    _T('Cikgu Mei Ling', true),
    _T('Cikgu Daud', true),
    _T('Cikgu Farah', false),
  ];

  final akpList = <_AkpStaff>[
    _AkpStaff('En. Hafiz', 'IT support', 'IT', '7:28 AM', 'On time'),
    _AkpStaff('Pn. Rosnah', 'Office clerk', 'Office', '7:31 AM', 'On time'),
    _AkpStaff('En. Faizal', 'IT support', 'IT', '7:52 AM', 'Late'),
    _AkpStaff('Pn. Lim', 'Office clerk', 'Office', '7:26 AM', 'On time'),
    _AkpStaff('Cik Devi', 'Library assistant', 'Other', '7:30 AM', 'On time'),
    _AkpStaff('En. Roslan', 'Driver', 'Other', 'Not in', 'Absent'),
  ];

  int added = 0; // base: 2 invited

  bool _prefixMatch(String fullName, String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return true;
    final lower = fullName.toLowerCase();
    final stripped = lower
        .replaceFirst('cikgu ', '')
        .replaceFirst('en. ', '')
        .replaceFirst('pn. ', '')
        .replaceFirst('cik ', '');
    return lower.startsWith(trimmed) || stripped.startsWith(trimmed);
  }

  Future<void> _addTeacher() async {
    String name = '';
    final res = await showModalBottomSheet<String>(
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
                autofocus: true,
                onChanged: (v) => name = v,
                decoration: InputDecoration(
                  hintText: 'Teacher name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              AppButton('Send invite',
                  onTap: () => Navigator.pop(ctx, name.trim())),
            ]),
      ),
    );
    if (res == null || res.isEmpty) return;
    setState(() {
      list.add(_T(res.startsWith('Cikgu') ? res : 'Cikgu $res', false));
      added++;
    });
  }

  Future<void> _addAkp() async {
    String name = '';
    String email = '';
    String dept = 'IT support';
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Add support staff', style: ts(18, w: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Register AKP staff using their personal email.',
                  style: ts(12, color: C.muted)),
              const SizedBox(height: 12),
              TextField(
                autofocus: true,
                onChanged: (v) => name = v,
                decoration: InputDecoration(
                  hintText: 'Full name (e.g. En. Amir)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => email = v,
                decoration: InputDecoration(
                  hintText: 'Personal email (e.g. amir@gmail.com)',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              PickerField(
                value: dept,
                options: const [
                  'IT support',
                  'Office clerk',
                  'Library assistant',
                  'Driver'
                ],
                onChanged: (v) => setS(() => dept = v),
              ),
              const SizedBox(height: 12),
              AppButton('Prepare invitation',
                  onTap: () => Navigator.pop(ctx, true)),
            ],
          ),
        ),
      ),
    );
    if (saved != true || name.trim().isEmpty) return;
    final cat = dept == 'IT support'
        ? 'IT'
        : (dept == 'Office clerk' ? 'Office' : 'Other');
    setState(() {
      akpList.add(_AkpStaff(name.trim(), dept, cat, 'Not in', 'Invited'));
    });
    if (!mounted) return;
    toast(
        context,
        email.trim().isEmpty
            ? 'Invitation prepared for ${name.trim()}'
            : 'Invitation prepared for ${email.trim()}');
  }

  Widget _segment(String label, bool akp) {
    final sel = showAkp == akp;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => setState(() => showAkp = akp),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: sel ? C.blueBg : C.bg,
            border: Border.all(color: sel ? C.blueLine : C.line),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label,
              style: ts(13, w: FontWeight.w500, color: sel ? C.blue : C.ink)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shownTeachers = list.where((t) => _prefixMatch(t.name, q)).toList();
    final shownAkp = akpList
        .where((s) =>
            (akpFilter == 'All' || s.category == akpFilter) &&
            _prefixMatch(s.name, q))
        .toList();
    final invited = 2 + added;

    return ListenableBuilder(
      listenable: app,
      builder: (context, _) => PageBody(
        footer: [
          AppButton(
            showAkp ? 'Add support staff' : 'Add teacher',
            icon: Icons.add,
            onTap: showAkp ? _addAkp : _addTeacher,
          ),
        ],
        children: [
          Heading(
            showAkp ? 'Support staff (AKP)' : 'Teachers',
            sub: showAkp
                ? 'Non-teaching staff, today'
                : '42 active - $invited invited',
          ),
          Row(children: [
            _segment('Teachers', false),
            const SizedBox(width: 8),
            _segment('Support staff (AKP)', true),
          ]),
          TextField(
            onChanged: (v) => setState(() => q = v),
            decoration: InputDecoration(
              hintText: showAkp
                  ? 'Search AKP by starting letters'
                  : 'Search teachers by starting letters',
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
          if (!showAkp) ...[
            Column(children: [
              for (final t in shownTeachers)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: C.line))),
                  child: Row(children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: C.blueBg, shape: BoxShape.circle),
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
                onTap: () =>
                    toast(context, 'Reminder sent to $invited teachers')),
          ] else ...[
            Wrap(spacing: 6, children: [
              for (final f in const ['All', 'IT', 'Office', 'Other'])
                ChoiceChip(
                  label: Text(f, style: ts(12)),
                  selected: akpFilter == f,
                  selectedColor: C.blueBg,
                  onSelected: (_) => setState(() => akpFilter = f),
                ),
            ]),
            const Row(children: [
              Expanded(child: StatCard('Present', '5')),
              SizedBox(width: 8),
              Expanded(child: StatCard('Late', '1', danger: true)),
              SizedBox(width: 8),
              Expanded(child: StatCard('Absent', '1')),
            ]),
            Column(children: [
              for (final s in shownAkp)
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: s.status == 'Late' ? C.redBg : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: s.status == 'Late'
                        ? null
                        : Border(bottom: BorderSide(color: C.line)),
                  ),
                  child: Row(children: [
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: C.blueBg, shape: BoxShape.circle),
                      child: Text(s.initials,
                          style: ts(12, w: FontWeight.w500, color: C.blue)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.name,
                              style: ts(14,
                                  color: s.status == 'Late' ? C.red : C.ink)),
                          Text(s.dept, style: ts(11, color: C.muted)),
                        ],
                      ),
                    ),
                    Text(s.time,
                        style: ts(12,
                            color: s.status == 'Late' ? C.red : C.muted)),
                    const SizedBox(width: 8),
                    s.status == 'On time'
                        ? Pill('On time', fg: C.green, bg: C.greenBg)
                        : s.status == 'Late'
                            ? Pill('Late', fg: C.red, bg: C.redBg)
                            : s.status == 'Invited'
                                ? Pill('Invited', fg: C.amber, bg: C.amberBg)
                                : Pill('Absent', fg: C.muted, bg: C.surface),
                  ]),
                ),
            ]),
            Text(
                'Support staff use their own times: late after ${app.akpLateStr}. Change this in Attendance rules.',
                style: ts(12, color: C.hint)),
          ],
        ],
      ),
    );
  }
}
