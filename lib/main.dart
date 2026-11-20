import 'package:flutter/material.dart';
import 'theme.dart';
import 'app_state.dart';
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

Future<void> showLanguageSheet(BuildContext context) async {
  String selected = app.language;
  const languages = [
    ('English', 'English'),
    ('Bahasa Melayu', 'Malay'),
    ('中文', 'Chinese (Simplified)'),
    ('தமிழ்', 'Tamil'),
  ];
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Language', style: ts(18, w: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Choose the language for menus, buttons and messages.',
                  style: ts(12, color: C.muted)),
              const SizedBox(height: 12),
              for (final lang in languages) ...[
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setS(() => selected = lang.$1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: selected == lang.$1 ? C.blueBg : C.bg,
                      border: Border.all(
                          color: selected == lang.$1 ? C.blueLine : C.line),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lang.$1,
                                style: ts(14,
                                    w: FontWeight.w500,
                                    color:
                                        selected == lang.$1 ? C.blue : C.ink)),
                            Text(lang.$2, style: ts(12, color: C.muted)),
                          ],
                        ),
                        if (selected == lang.$1)
                          Icon(Icons.check, size: 18, color: C.blue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              NoteBox(Icons.info_outline,
                  'Your choice is saved to your account and works on every device.',
                  fg: C.muted, bg: C.surface),
              const SizedBox(height: 12),
              AppButton('Apply language', onTap: () {
                app.setLanguage(selected);
                Navigator.pop(ctx);
                toast(context, 'Language set to $selected');
              }),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> showPasswordSheet(BuildContext context,
    {String title = 'Create password'}) async {
  String pwd = '';
  String confirm = '';
  bool hide1 = true;
  bool hide2 = true;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) {
        final hasLen = pwd.length >= 8;
        final hasUpper = RegExp(r'[A-Z]').hasMatch(pwd);
        final hasLower = RegExp(r'[a-z]').hasMatch(pwd);
        final hasDigit = RegExp(r'[0-9]').hasMatch(pwd);
        final hasSpec = RegExp(r'[^A-Za-z0-9]').hasMatch(pwd);
        final score = [hasLen, hasUpper, hasLower, hasDigit, hasSpec]
            .where((e) => e)
            .length;
        final strong = score == 5;
        final canSave = strong && confirm == pwd;

        Widget rule(bool ok, String text) => Row(children: [
              Icon(ok ? Icons.check : Icons.close,
                  size: 16, color: ok ? C.green : C.red),
              const SizedBox(width: 8),
              Expanded(
                  child:
                      Text(text, style: ts(12, color: ok ? C.green : C.red))),
            ]);

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title, style: ts(18, w: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                      'Pick a strong password. It protects your attendance record.',
                      style: ts(12, color: C.muted)),
                  const SizedBox(height: 12),
                  Text('New password', style: ts(12, color: C.muted)),
                  const SizedBox(height: 6),
                  TextField(
                    obscureText: hide1,
                    onChanged: (v) => setS(() => pwd = v),
                    decoration: InputDecoration(
                      hintText: 'Enter new password',
                      suffixIcon: IconButton(
                        icon: Icon(
                            hide1
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 18,
                            color: C.muted),
                        onPressed: () => setS(() => hide1 = !hide1),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: pwd.isEmpty
                                  ? C.line
                                  : (strong ? C.green : C.red))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: strong ? C.green : C.blue)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    for (var idx = 0; idx < 5; idx++) ...[
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: idx < score
                                ? (strong ? C.green : C.red)
                                : C.line,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      if (idx < 4) const SizedBox(width: 4),
                    ],
                  ]),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Password strength', style: ts(12, color: C.muted)),
                      Text(
                        pwd.isEmpty ? '-' : (strong ? 'Strong' : 'Weak'),
                        style: ts(12,
                            w: FontWeight.w600,
                            color: pwd.isEmpty
                                ? C.muted
                                : (strong ? C.green : C.red)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: C.surface,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: gap([
                        rule(hasLen, 'At least 8 characters'),
                        rule(hasUpper, 'A-Z (a capital letter)'),
                        rule(hasLower, 'a-z (a small letter)'),
                        rule(hasDigit, '0-9 (a number)'),
                        rule(hasSpec,
                            'A special character, for example ! @ # \$ %'),
                      ], 6),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (pwd.isNotEmpty)
                    NoteBox(
                      strong ? Icons.check_circle_outline : Icons.error_outline,
                      strong
                          ? 'This password meets all rules.'
                          : 'This password is too weak. Add the missing items to continue.',
                      fg: strong ? C.green : C.red,
                      bg: strong ? C.greenBg : C.redBg,
                    ),
                  const SizedBox(height: 10),
                  Text('Confirm password', style: ts(12, color: C.muted)),
                  const SizedBox(height: 6),
                  TextField(
                    obscureText: hide2,
                    onChanged: (v) => setS(() => confirm = v),
                    decoration: InputDecoration(
                      hintText: 'Re-enter password',
                      suffixIcon: IconButton(
                        icon: Icon(
                            hide2
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 18,
                            color: C.muted),
                        onPressed: () => setS(() => hide2 = !hide2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: C.line)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: C.blue)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppButton(
                    'Save password',
                    onTap: canSave
                        ? () {
                            Navigator.pop(ctx);
                            toast(context, 'Password updated');
                          }
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String role = 'Teacher';
  bool usePersonalEmail = false;
  bool hidePassword = true;
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }

  Widget _roleChip(String r) {
    final sel = role == r;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() {
          role = r;
          if (r == 'Support staff') {
            usePersonalEmail = true;
          }
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: sel ? C.blueBg : C.bg,
            border: Border.all(color: sel ? C.blueLine : C.line),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(r,
              textAlign: TextAlign.center,
              style: ts(13, w: FontWeight.w500, color: sel ? C.blue : C.ink)),
        ),
      ),
    );
  }

  Widget _emailModeChip(String label, bool personal) {
    final sel = usePersonalEmail == personal;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => setState(() => usePersonalEmail = personal),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: sel ? C.blueBg : C.bg,
            border: Border.all(color: sel ? C.blueLine : C.line),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label,
              style: ts(12, w: FontWeight.w500, color: sel ? C.blue : C.ink)),
        ),
      ),
    );
  }

  InputDecoration _dec(String hint, {IconData? prefix, Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: ts(14, color: C.hint),
        prefixIcon:
            prefix != null ? Icon(prefix, size: 18, color: C.muted) : null,
        suffixIcon: suffix,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: C.line)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: C.blue)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: C.red)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: C.red)),
      );

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) {
      return usePersonalEmail
          ? 'Please enter your personal email'
          : 'Please enter your DELIMa ID email';
    }
    final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return usePersonalEmail
          ? 'Enter a valid email (e.g. name@gmail.com)'
          : 'Enter a valid email (e.g. name@moe-dl.edu.my)';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    final value = v ?? '';
    if (value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _signIn() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (role == 'Admin') {
      app.setRole(UserRole.admin);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminShell()));
    } else if (role == 'Support staff') {
      app.setRole(UserRole.akp);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const TeacherShell()));
    } else {
      app.setRole(UserRole.teacher);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const TeacherShell()));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 900) return const DesktopLogin();
    return _mobile(context);
  }

  Widget _mobile(BuildContext context) => Screen(
        child: ListenableBuilder(
          listenable: app,
          builder: (context, _) => Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => showLanguageSheet(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          color: C.surface,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(children: [
                        Icon(Icons.language, size: 15, color: C.ink),
                        const SizedBox(width: 4),
                        Text(app.language, style: ts(12, w: FontWeight.w500)),
                        const SizedBox(width: 2),
                        Icon(Icons.keyboard_arrow_down,
                            size: 16, color: C.muted),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const ThemeIconButton(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: Form(
                  key: _formKey,
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
                            child:
                                Icon(Icons.qr_code_2, size: 34, color: C.blue),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                            child: Text('EduSync',
                                style: ts(24, w: FontWeight.w600))),
                        const SizedBox(height: 6),
                        Center(
                            child: Text(
                                '"Smart Attendance, Smarter Management."',
                                style: ts(13, color: C.muted))),
                        const SizedBox(height: 14),
                        Row(children: [
                          _roleChip('Teacher'),
                          const SizedBox(width: 6),
                          _roleChip('Admin'),
                          const SizedBox(width: 6),
                          _roleChip('Support staff'),
                        ]),
                        if (role == 'Support staff') ...[
                          const SizedBox(height: 10),
                          NoteBox(
                            Icons.badge_outlined,
                            'AKP: school support staff such as IT, office and other staff.',
                            fg: C.blue,
                            bg: C.blueBg,
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(children: [
                          _emailModeChip('DELIMa ID', false),
                          const SizedBox(width: 8),
                          _emailModeChip('Personal email', true),
                        ]),
                        const SizedBox(height: 12),
                        TextFormField(
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            decoration: _dec(
                              usePersonalEmail
                                  ? 'name@gmail.com'
                                  : 'name@moe-dl.edu.my',
                              prefix: Icons.mail_outline,
                            )),
                        if (usePersonalEmail) ...[
                          const SizedBox(height: 10),
                          NoteBox(
                            Icons.info_outline,
                            'Personal email works after your admin links it to your account.',
                            fg: C.amber,
                            bg: C.amberBg,
                          ),
                        ],
                        const SizedBox(height: 12),
                        TextFormField(
                            controller: pass,
                            obscureText: hidePassword,
                            validator: _validatePassword,
                            decoration: _dec(
                              'Password',
                              prefix: Icons.lock_outline,
                              suffix: IconButton(
                                icon: Icon(
                                    hidePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                    color: C.muted),
                                onPressed: () => setState(
                                    () => hidePassword = !hidePassword),
                              ),
                            )),
                        const SizedBox(height: 6),
                        Text(
                            'Use 8+ characters with A-Z, a-z, a number and a symbol.',
                            style: ts(11, color: C.hint)),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => showPasswordSheet(context,
                                title: 'Create password'),
                            child: Text('Forgot password?',
                                style:
                                    ts(12, w: FontWeight.w500, color: C.blue)),
                          ),
                        ),
                        AppButton('Sign in', onTap: _signIn),
                        const SizedBox(height: 12),
                        Center(
                            child: Text('New here? Ask your admin to add you.',
                                style: ts(12, color: C.hint))),
                      ]),
                ),
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
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const StationScreen())),
              child: Text('Open QR station display',
                  style: ts(12, w: FontWeight.w500, color: C.blue)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text('By Nexus Devs', style: ts(12, color: C.hint)),
            ),
          ]),
        ),
      );
}
