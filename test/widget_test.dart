import 'package:flutter_test/flutter_test.dart';
import 'package:edusync/main.dart'; // Ensure this matches your pubspec.yaml package name

void main() {
  testWidgets('EduSync app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EduSyncApp()); // <-- Replace with the exact class name from main.dart
    expect(find.byType(EduSyncApp), findsOneWidget); // <-- Same class name here
  });
}