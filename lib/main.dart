import 'package:flutter/material.dart';
import 'theme.dart';
import 'teacher.dart';
import 'admin.dart';
import 'desktop.dart';
import 'station.dart';

void main() => runApp(const EduSyncApp());

class EduSyncApp extends StatelessWidget {
  const EduSyncApp({super.key});
  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (context, mode, _) => MaterialApp(
          title: 'EduSync',
          debugShowCheckedModeBanner: false,
          theme: buildTheme(false),
          darkTheme: buildTheme(true),
          themeMode: mode,
          builder: (ctx, child) {
            final d = Theme.of(ctx).brightness == Brightness.dark;
            if (d != C.dark) {
              C.dark = d;
              WidgetsBinding.instance.addPostFrameCallback((_) => rebuildAll());
            }
            return ValueListenableBuilder<bool>(
              valueListenable: phoneMode,
              builder: (c, phone, _) {
                final mq = MediaQuery.of(c);
                if (!phone || mq.size.width < 900) return child!;
                return ColoredBox(
                  color: C.surface,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: MediaQuery(
                        data: mq.copyWith(size: Size(420, mq.size.height)),
                        child: child!,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          home: const LoginScreen(),
        ),
      );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String role = 'Teacher';
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  Widget _role(String r) {
    final sel = role == r;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => role = r),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: sel ? C.blueBg : C.bg,
            border: Border.all(color: sel ? C.blueLine : C.line),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(r,
              style: ts(15, w: FontWeight.w500, color: sel ? C.blue : C.ink)),
        ),
      ),
    );
  }

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: ts(14, color: C.hint),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: C.line)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: C.blue)),
      );

  void _signIn() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) =>
          role == 'Teacher' ? const TeacherShell() : const AdminShell(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 900) return const DesktopLogin();
    return _mobile(context);
  }

  Widget _mobile(BuildContext context) => Screen(
        child: Column(children: [
          const Align(
              alignment: Alignment.centerRight, child: ThemeIconButton()),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                            color: C.blueBg,
                            borderRadius: BorderRadius.circular(16)),
                        child: Icon(Icons.qr_code_2, size: 34, color: C.blue),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                        child:
                            Text('EduSync', style: ts(24, w: FontWeight.w600))),
                    const SizedBox(height: 14),
                    Center(
                        child: Text('"Smart Attendance, Smarter Management."',
                            style: ts(13, color: C.muted))),
                    const SizedBox(height: 14),
                    Row(children: [
                      _role('Teacher'),
                      const SizedBox(width: 8),
                      _role('Admin')
                    ]),
                    const SizedBox(height: 14),
                    TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _dec('name@school.edu.my')),
                    const SizedBox(height: 14),
                    TextField(
                        controller: pass,
                        obscureText: true,
                        decoration: _dec('Password')),
                    const SizedBox(height: 14),
                    AppButton('Sign in', onTap: _signIn),
                    const SizedBox(height: 14),
                    Center(
                        child: Text('New here? Ask your admin to add you.',
                            style: ts(12, color: C.hint))),
                  ]),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: phoneMode,
            builder: (c, phone, _) => phone
                ? TextButton(
                    onPressed: () {
                      phoneMode.value = false;
                      Navigator.of(c).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (r) => false);
                    },
                    child: Text('Back to desktop admin view',
                        style: ts(12, w: FontWeight.w500, color: C.blue)),
                  )
                : const SizedBox.shrink(),
          ),
          TextButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const StationScreen())),
            child: Text('Open QR station display',
                style: ts(12, w: FontWeight.w500, color: C.blue)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text('By Nexus Devs', style: ts(12, color: C.hint)),
          ),
        ]),
      );
}
