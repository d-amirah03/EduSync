import 'package:flutter/material.dart';
import 'theme.dart';
import 'app_state.dart';
import 'results.dart';
import 'main.dart' show LoginScreen, showLanguageSheet, showPasswordSheet;

class TeacherShell extends StatefulWidget {
  const TeacherShell({super.key});
  @override
  State<TeacherShell> createState() => _TeacherShellState();
}

class _TeacherShellState extends State<TeacherShell> {
  int i = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: IndexedStack(index: i, children: const [
            TeacherHome(),
            TeacherHistory(),
            TeacherProfile()
          ]),
        ),
        bottomNavigationBar: BottomNav(
          index: i,
          onTap: (v) => setState(() => i = v),
          items: const [
            NavItem(Icons.home_outlined, 'Home'),
            NavItem(Icons.history, 'History'),
            NavItem(Icons.person_outline, 'Profile'),
          ],
        ),
      );
}

class TeacherHome extends StatelessWidget {
  const TeacherHome({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final akp = app.isAkp;
          final inDone = app.checkIn != null;
          final outDone = app.checkOut != null;
          final label = !inDone
              ? 'Scan to check in'
              : (!outDone ? 'Scan to check out' : 'All done for today');
          final reminderText = akp
              ? "Reminder at ${app.akpEarlyStr} if you haven't scanned"
              : "Reminder at 12:40 PM if you haven't scanned";

          return PageBody(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Mon, 12 Oct', style: ts(12, color: C.muted)),
              const SizedBox(height: 2),
              Text(
                  akp
                      ? 'Good morning, En. Hafiz'
                      : 'Good morning, Cikgu Zanibah',
                  style: ts(20, w: FontWeight.w600)),
              if (akp) ...[
                const SizedBox(height: 6),
                Pill('Support staff (AKP): IT support',
                    fg: C.blue, bg: C.blueBg),
              ],
            ]),
            Text('Today', style: ts(13, w: FontWeight.w600, color: C.muted)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                  color: C.surface, borderRadius: BorderRadius.circular(12)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(akp ? 'Work hours' : 'Check in',
                              style: ts(13,
                                  w: akp ? FontWeight.w600 : FontWeight.w400,
                                  color: akp ? C.ink : C.muted)),
                          if (inDone)
                            app.pendingSync && !outDone
                                ? Pill('Pending sync',
                                    fg: C.amber, bg: C.amberBg)
                                : app.isLate
                                    ? Pill('Late', fg: C.red, bg: C.redBg)
                                    : Pill('On time',
                                        fg: C.green, bg: C.greenBg),
                        ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (akp)
                              Text('Check in', style: ts(12, color: C.muted)),
                            Text(app.checkIn ?? 'Not yet',
                                style: ts(akp ? 22 : 28,
                                    w: FontWeight.w600,
                                    color: inDone ? C.ink : C.hint)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Check out', style: ts(12, color: C.muted)),
                            Text(app.checkOut ?? 'Not yet',
                                style: ts(14,
                                    w: FontWeight.w500,
                                    color: outDone ? C.ink : C.hint)),
                          ],
                        ),
                      ),
                    ]),
                    if (akp) ...[
                      const SizedBox(height: 8),
                      Text('Work hours ${app.akpLateStr} to ${app.akpEarlyStr}',
                          style: ts(12, color: C.muted)),
                    ],
                  ]),
            ),
            Material(
              color: inDone && outDone ? C.surface : C.blueBg,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: inDone && outDone
                    ? null
                    : () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => ScanScreen(checkingOut: inDone))),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: inDone && outDone ? C.line : C.blueLine),
                  ),
                  child: Column(children: [
                    Icon(
                        inDone && outDone
                            ? Icons.check_circle_outline
                            : Icons.qr_code_scanner,
                        size: 40,
                        color: inDone && outDone ? C.muted : C.blue),
                    const SizedBox(height: 8),
                    Text(label,
                        style: ts(17,
                            w: FontWeight.w500,
                            color: inDone && outDone ? C.muted : C.blue)),
                    if (akp) ...[
                      const SizedBox(height: 2),
                      Text('Work hours', style: ts(12, color: C.muted)),
                    ],
                  ]),
                ),
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const ReminderNotificationScreen())),
              child: Row(children: [
                Icon(Icons.notifications_none, size: 16, color: C.ink),
                const SizedBox(width: 8),
                Expanded(child: Text(reminderText, style: ts(12))),
              ]),
            ),
          ]);
        },
      );
}

class ScanScreen extends StatefulWidget {
  final bool checkingOut;
  const ScanScreen({super.key, required this.checkingOut});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  ScanOutcome outcome = ScanOutcome.ok;
  bool done = false;

  static const _labels = {
    ScanOutcome.ok: 'On time',
    ScanOutcome.late: 'Late',
    ScanOutcome.expired: 'QR expired',
    ScanOutcome.far: 'Too far',
    ScanOutcome.offline: 'No signal',
  };

  void _push(Widget w) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));

  void scan() {
    if (done) return;
    final out = widget.checkingOut;
    final outTime = app.isAkp ? '4:35 PM' : '12:58 PM';
    final okInTime = app.isAkp ? '7:28 AM' : '6:42 AM';
    final lateInTime = app.isAkp ? '7:52 AM' : '7:05 AM';

    switch (outcome) {
      case ScanOutcome.ok:
      case ScanOutcome.late:
        if (out) {
          app.setCheckOut(outTime);
          setState(() => done = true);
        } else {
          final late = outcome == ScanOutcome.late;
          app.setCheckIn(late ? lateInTime : okInTime, late: late);
          _push(checkedInResult(late: late));
        }
        break;
      case ScanOutcome.expired:
        _push(expiredResult());
        break;
      case ScanOutcome.far:
        _push(farResult());
        break;
      case ScanOutcome.offline:
        if (out) {
          app.setCheckOut(outTime, offline: true);
          _push(offlineResult(outTime));
        } else {
          app.setCheckIn(okInTime, offline: true);
          _push(offlineResult(okInTime));
        }
        break;
    }
  }

  Widget _check(IconData icon, String text) => Row(children: [
        Icon(icon, size: 18, color: C.green),
        const SizedBox(width: 8),
        Text(text, style: ts(14, color: C.green)),
      ]);

  @override
  Widget build(BuildContext context) => Screen(
        child: PageBody(
          footer: [
            if (done)
              AppButton('Done',
                  onTap: () =>
                      Navigator.of(context).popUntil((r) => r.isFirst)),
          ],
          children: [
            const BackHeader('Scan QR code'),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                  color: C.surface, borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: GestureDetector(
                  onTap: scan,
                  child: DashedBox(
                      size: 150,
                      child: Icon(Icons.qr_code_2, size: 60, color: C.hint)),
                ),
              ),
            ),
            if (!done) ...[
              Text('Tap the scan frame to scan the station QR code.',
                  style: ts(13, color: C.muted)),
              Text('Demo: choose what happens when you scan',
                  style: ts(12, color: C.hint)),
              Wrap(spacing: 8, runSpacing: 4, children: [
                for (final o in ScanOutcome.values)
                  ChoiceChip(
                    label: Text(_labels[o]!, style: ts(12)),
                    selected: outcome == o,
                    selectedColor: C.blueBg,
                    onSelected: (_) => setState(() => outcome = o),
                  ),
              ]),
            ] else ...[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: gap([
                    _check(Icons.check, 'QR code is valid'),
                    _check(Icons.place_outlined,
                        'Location verified (within 50 m)'),
                    _check(Icons.schedule, 'Checked out at ${app.checkOut}'),
                  ], 10)),
            ],
            NoteBox(Icons.error_outline,
                "No signal? Your scan is saved on this phone and syncs when you're back online.",
                fg: C.amber, bg: C.amberBg),
          ],
        ),
      );
}

class TeacherHistory extends StatelessWidget {
  const TeacherHistory({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          String? today;
          Color todayColor = C.green;
          if (app.checkIn != null) {
            today = app.checkOut == null
                ? '${app.checkIn} - in progress'
                : '${app.checkIn} - ${app.checkOut}';
            if (app.isLate) todayColor = C.red;
          }
          return PageBody(
            footer: [
              AppButton('View monthly record',
                  outlined: true,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const MyRecordScreen()))),
            ],
            children: [
              Text('My attendance', style: ts(20, w: FontWeight.w600)),
              Row(children: [
                Expanded(
                    child: StatCard(
                        'Late this month', '${3 + (app.isLate ? 1 : 0)}',
                        danger: true)),
                const SizedBox(width: 10),
                const Expanded(
                    child: StatCard('Left early', '1', danger: true)),
              ]),
              Column(children: [
                if (today != null)
                  LineRow('Mon 12 Oct', today, rightColor: todayColor),
                LineRow('Fri 9 Oct', '7:05 AM - 1:00 PM', rightColor: C.red),
                const LineRow('Thu 8 Oct', '6:40 AM - 1:02 PM'),
                LineRow('Wed 7 Oct', '6:48 AM - 12:30 PM', rightColor: C.red),
                const LineRow('Tue 6 Oct', '6:38 AM - 1:05 PM'),
              ]),
              Text('Red means late or left early',
                  style: ts(12, color: C.redNote)),
            ],
          );
        },
      );
}

class MyRecordScreen extends StatelessWidget {
  const MyRecordScreen({super.key});
  @override
  Widget build(BuildContext context) => Screen(
        child: PageBody(
          footer: [
            AppButton('Export PDF',
                icon: Icons.download,
                onTap: () => toast(context, 'Attendance_Oct2026.pdf saved')),
            AppButton('Print',
                icon: Icons.print_outlined,
                outlined: true,
                onTap: () => toast(context, 'Sending to printer...')),
          ],
          children: [
            const BackHeader('History'),
            Heading('My record',
                sub: app.isAkp
                    ? 'En. Hafiz (AKP) - 1 Oct to 31 Oct 2026'
                    : 'Cikgu Zanibah - 1 Oct to 31 Oct 2026'),
            const Row(children: [
              Expanded(child: StatCard('Days present', '22')),
              SizedBox(width: 8),
              Expanded(child: StatCard('Late', '3', danger: true)),
              SizedBox(width: 8),
              Expanded(child: StatCard('Left early', '1', danger: true)),
            ]),
            Text('Flagged days',
                style: ts(13, w: FontWeight.w500, color: C.muted)),
            Column(children: [
              LineRow('Thu 1 Oct', '7:10 AM - Late', rightColor: C.red),
              LineRow('Mon 5 Oct', '7:12 AM - Late', rightColor: C.red),
              LineRow('Wed 7 Oct', '12:30 PM - Left early', rightColor: C.red),
              LineRow('Fri 9 Oct', '7:05 AM - Late', rightColor: C.red),
            ]),
            Text('Export this record as a PDF to show an auditor or print it.',
                style: ts(12, color: C.hint)),
          ],
        ),
      );
}

class TeacherProfile extends StatelessWidget {
  const TeacherProfile({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: app,
        builder: (context, _) {
          final akp = app.isAkp;
          return PageBody(
            footer: [
              AppButton('Sign out',
                  outlined: true,
                  onTap: () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (r) => false)),
            ],
            children: [
              Text('Account', style: ts(20, w: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: C.surface, borderRadius: BorderRadius.circular(12)),
                child: Row(children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration:
                        BoxDecoration(color: C.blueBg, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text(akp ? 'EH' : 'CZ',
                        style: ts(16, w: FontWeight.w600, color: C.blue)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(akp ? 'En. Hafiz' : 'Cikgu Zanibah',
                            style: ts(15, w: FontWeight.w600)),
                        Text(
                            akp
                                ? 'Support staff (AKP), SK Paya Mebi'
                                : 'Teacher, SK Paya Mebi',
                            style: ts(12, color: C.muted)),
                      ],
                    ),
                  ),
                ]),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => showLanguageSheet(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: C.line),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    Icon(Icons.language, size: 18, color: C.ink),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text('Language',
                            style: ts(14, w: FontWeight.w500))),
                    Text(app.language, style: ts(13, color: C.muted)),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right, size: 18, color: C.muted),
                  ]),
                ),
              ),
              Text('Email accounts',
                  style: ts(13, w: FontWeight.w500, color: C.muted)),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: C.line),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!akp) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('DELIMa ID (main)',
                              style: ts(13, w: FontWeight.w500)),
                          Pill('Verified', fg: C.green, bg: C.greenBg),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('zanibah@moe-dl.edu.my',
                          style: ts(12, color: C.muted)),
                      Divider(height: 20, color: C.line),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Personal email',
                            style: ts(13, w: FontWeight.w500)),
                        Pill(akp ? 'Verified' : 'Pending',
                            fg: akp ? C.green : C.amber,
                            bg: akp ? C.greenBg : C.amberBg),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(akp ? 'hafiz.it@gmail.com' : 'zanibah.kawi@gmail.com',
                        style: ts(12, color: C.muted)),
                  ],
                ),
              ),
              Text(
                  'You can sign in with either email. If you cannot use DELIMa, ask your admin to verify your personal email.',
                  style: ts(11, color: C.hint)),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () =>
                    showPasswordSheet(context, title: 'Change password'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: C.line),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    Icon(Icons.lock_outline, size: 18, color: C.ink),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text('Change password',
                            style: ts(14, w: FontWeight.w500))),
                    Icon(Icons.chevron_right, size: 18, color: C.muted),
                  ]),
                ),
              ),
              Text('Appearance',
                  style: ts(13, w: FontWeight.w500, color: C.muted)),
              const ThemeChips(),
              Text('Demo controls',
                  style: ts(13, w: FontWeight.w500, color: C.muted)),
              AppButton('Reset to mockup state', outlined: true, onTap: () {
                app.resetToMockup();
                toast(context, 'Reset: checked in ${app.checkIn}');
              }),
              AppButton('Start a new day (not checked in)', outlined: true,
                  onTap: () {
                app.newDay();
                toast(context, 'New day: scan to check in');
              }),
            ],
          );
        },
      );
}
