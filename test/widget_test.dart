import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/main.dart';

void main() {
  testWidgets('App initializes with SplashPage', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Memastikan CircularProgressIndicator tampil saat inisialisasi splash
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
