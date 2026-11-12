import 'package:flutter/material.dart';
import 'theme.dart';
import 'teacher.dart';

void _home(BuildContext c) => Navigator.of(c).popUntil((r) => r.isFirst);
void _back(BuildContext c) => Navigator.of(c).pop();

class ResultScreen extends StatelessWidget {
  final IconData icon;
  final Color fg;
  final Color bg;
  final String title;
  final String? time;
  final String? badge;
  final Color? badgeFg;
  final Color? badgeBg;
  final String body;
  final String button;
  final void Function(BuildContext) onTap;
  const ResultScreen({
    super.key,
    required this.icon,
    required this.fg,
    required this.bg,
    required this.title,
    this.time,
    this.badge,
    this.badgeFg,
    this.badgeBg,
    required this.body,
    required this.button,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Screen(
        child: PageBody(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                child: Icon(icon, size: 36, color: fg),
              ),
            ),
            Center(child: Text(title, textAlign: TextAlign.center, style: ts(20, w: FontWeight.w600))),
            if (time != null) Center(child: Text(time!, style: ts(32, w: FontWeight.w600))),
            if (badge != null) Center(child: Pill(badge!, fg: badgeFg!, bg: badgeBg!)),
            Text(body, textAlign: TextAlign.center, style: ts(13, color: C.muted)),
          ],
          footer: [AppButton(button, onTap: () => onTap(context))],
        ),
      );
}

Widget checkedInResult({required bool late}) => ResultScreen(
      icon: late ? Icons.schedule : Icons.check,
      fg: late ? C.red : C.green,
      bg: late ? C.redBg : C.greenBg,
      title: late ? 'Checked in late' : 'Checked in',
      time: late ? '7:05 AM' : '6:42 AM',
      badge: late ? 'Late: after 6:50 AM' : 'On time',
      badgeFg: late ? C.red : C.green,
      badgeBg: late ? C.redBg : C.greenBg,
      body: late
          ? 'Your administrator will see this entry in red. Late arrivals are detected automatically.'
          : 'Location verified. Your check-in is saved and visible to your administrator.',
      button: 'Done',
      onTap: _home,
    );

Widget expiredResult() => ResultScreen(
      icon: Icons.refresh,
      fg: C.amber,
      bg: C.amberBg,
      title: 'This QR code has expired',
      body: 'The code at the station refreshes regularly so it cannot be shared. Scan the code that is showing now.',
      button: 'Scan again',
      onTap: _back,
    );

Widget farResult() => ResultScreen(
      icon: Icons.place_outlined,
      fg: C.red,
      bg: C.redBg,
      title: 'You are too far from the school',
      body: 'Move closer to the attendance station and try again. Location is checked to stop attendance being recorded for someone else.',
      button: 'Try again',
      onTap: _back,
    );

Widget offlineResult(String time) => ResultScreen(
      icon: Icons.cloud_outlined,
      fg: C.blue,
      bg: C.blueBg,
      title: 'Saved on this phone',
      time: time,
      badge: 'Pending sync',
      badgeFg: C.amber,
      badgeBg: C.amberBg,
      body: 'No signal. Your scan will sync automatically when you are back online.',
      button: 'Done',
      onTap: _home,
    );

class ReminderNotificationScreen extends StatelessWidget {
  const ReminderNotificationScreen({super.key});
  @override
  Widget build(BuildContext context) => Screen(
        child: PageBody(children: [
          const BackHeader('Reminder'),
          const SizedBox(height: 8),
          Center(child: Text('Monday, 12 October', style: ts(16, color: C.muted))),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => ScanScreen(checkingOut: true)),
            ),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: C.surface, borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(color: C.blueBg, borderRadius: BorderRadius.circular(6)),
                    child: Icon(Icons.qr_code_2, size: 14, color: C.blue),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text('EduSync', style: ts(12, color: C.muted))),
                  Text('now', style: ts(12, color: C.hint)),
                ]),
                const SizedBox(height: 8),
                Text("You haven't scanned out yet", style: ts(14, w: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Scan the QR code at the admin office before you leave.', style: ts(13, color: C.muted)),
              ]),
            ),
          ),
          Center(child: Text('Tap the notification to open the scanner', style: ts(12, color: C.hint))),
        ]),
      );
}
