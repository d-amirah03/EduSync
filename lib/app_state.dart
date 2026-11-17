import 'package:flutter/foundation.dart';

enum ScanOutcome { ok, late, expired, far, offline }

class AppState extends ChangeNotifier {
  String? checkIn = '6:42 AM';
  bool isLate = false;
  String? checkOut;
  bool pendingSync = false;

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
    checkIn = '6:42 AM';
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
