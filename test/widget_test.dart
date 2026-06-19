// Test de fumée : vérifie que l'application démarre sans erreur.

import 'package:flutter_test/flutter_test.dart';

import 'package:discover_cameroon/main.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets("L'application démarre et affiche le splash screen KmerTour",
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: DiscoverCameroonApp()));
    await tester.pump(); // Attend une frame (le splash screen a des animations infinies, donc pumpAndSettle() timeout)

    // Vérifie que le texte du splash screen est présent
    expect(find.text("Explorez l'Afrique en miniature"), findsOneWidget);
  });
}
