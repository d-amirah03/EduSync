import 'package:flutter/foundation.dart';

enum ScanOutcome { ok, late, expired, far, offline }

enum UserRole { teacher, admin, akp }

String formatMinutes(int totalMinutes) {
  final normalized = ((totalMinutes % 1440) + 1440) % 1440;
  final h24 = normalized ~/ 60;
  final m = normalized % 60;
  final h12 = h24 % 12 == 0 ? 12 : h24 % 12;
  final period = h24 < 12 ? 'AM' : 'PM';
  return '$h12:${m.toString().padLeft(2, '0')} $period';
}

class AppState extends ChangeNotifier {
  UserRole currentRole = UserRole.teacher;
  String language = 'English';

  String? checkIn = '6:42 AM';
  bool isLate = false;
  String? checkOut;
  bool pendingSync = false;

  // Configurable attendance rules (stored as minutes from midnight)
  int teacherLateMin = 6 * 60 + 50; // 6:50 AM
  int teacherGraceMin = 5;
  int teacherEarlyMin = 12 * 60 + 50; // 12:50 PM

  int akpLateMin = 7 * 60 + 30; // 7:30 AM
  int akpGraceMin = 5;
  int akpEarlyMin = 16 * 60 + 30; // 4:30 PM

  int qrRefreshSeconds = 3; // 3, 4, or 5 seconds

  bool get isAkp => currentRole == UserRole.akp;
  String get teacherLateStr => formatMinutes(teacherLateMin);
  String get teacherEarlyStr => formatMinutes(teacherEarlyMin);
  String get akpLateStr => formatMinutes(akpLateMin);
  String get akpEarlyStr => formatMinutes(akpEarlyMin);

  void setRole(UserRole role) {
    currentRole = role;
    if (role == UserRole.akp && checkIn == '6:42 AM') {
      checkIn = '7:28 AM';
    } else if (role == UserRole.teacher && checkIn == '7:28 AM') {
      checkIn = '6:42 AM';
    }
    notifyListeners();
  }

  void setLanguage(String lang) {
    language = lang;
    notifyListeners();
  }

  void updateRules({
    required bool forAkp,
    required int lateMin,
    required int graceMin,
    required int earlyMin,
    required int qrSeconds,
  }) {
    if (forAkp) {
      akpLateMin = lateMin;
      akpGraceMin = graceMin;
      akpEarlyMin = earlyMin;
    } else {
      teacherLateMin = lateMin;
      teacherGraceMin = graceMin;
      teacherEarlyMin = earlyMin;
    }
    qrRefreshSeconds = qrSeconds;
    notifyListeners();
  }

  void setCheckIn(String t, {bool late = false, bool offline = false}) {
    checkIn = t;
    isLate = late;
    pendingSync = offline;
    notifyListeners();
  }

  void setCheckOut(String t, {bool offline = false}) {
    checkOut = t;
    pendingSync = offline;
    notifyListeners();
  }

  void resetToMockup() {
    checkIn = isAkp ? '7:28 AM' : '6:42 AM';
    isLate = false;
    checkOut = null;
    pendingSync = false;
    notifyListeners();
  }

  void newDay() {
    checkIn = null;
    isLate = false;
    checkOut = null;
    pendingSync = false;
    notifyListeners();
  }
}

final app = AppState();
