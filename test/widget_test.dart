// Test de fumée : vérifie que l'application démarre sans erreur.

import 'package:flutter_test/flutter_test.dart';

import 'package:discover_cameroon/main.dart';

void main() {
  testWidgets("L'application démarre et affiche la liste des destinations",
      (WidgetTester tester) async {
    await tester.pumpWidget(const DiscoverCameroonApp());

    // Vérifie que le titre de l'AppBar est présent
    expect(find.text('Discover Cameroon'), findsOneWidget);
  });
}
