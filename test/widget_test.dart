import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:entretien_chaudiere_flutter/main.dart';

Future<void> pumpScreen(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('Home menu shows main actions', (WidgetTester tester) async {
    await tester.pumpWidget(const BoilerCareApp());

    expect(find.text('Logo'), findsOneWidget);
    expect(find.text('Fiche client'), findsOneWidget);
    expect(find.text('Depannage'), findsOneWidget);
    expect(find.text('Entretien'), findsOneWidget);
    expect(find.text('Reglage'), findsOneWidget);
  });

  testWidgets('Client entry opens list before read only detail',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BoilerCareApp());

    await tester.tap(find.text('Fiche client'));
    await pumpScreen(tester);

    expect(find.text('Clients'), findsOneWidget);
    expect(find.text('Ajouter un client'), findsOneWidget);
    expect(find.text('Jean Martin'), findsOneWidget);
    expect(find.text('Rechercher un client'), findsOneWidget);

    await tester.tap(find.text('Jean Martin'));
    await pumpScreen(tester);

    expect(find.text('Fiche client'), findsOneWidget);
    expect(find.text('Modifier la fiche'), findsOneWidget);
    expect(find.byType(AppField), findsNothing);
  });

  testWidgets('Report actions require client selection first',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BoilerCareApp());

    await tester.ensureVisible(find.text('Depannage'));
    await tester.tap(find.text('Depannage'));
    await pumpScreen(tester);

    expect(find.text('Choisir client'), findsOneWidget);
    expect(find.text('Selectionne le client avant de saisir le rapport.'),
        findsOneWidget);
    expect(find.text('Jean Martin'), findsOneWidget);
    expect(find.text('Tirage (Pa)'), findsNothing);

    await tester.tap(find.text('Jean Martin'));
    await pumpScreen(tester);

    expect(find.text('Depannage'), findsOneWidget);
    expect(find.text('Tirage (Pa)'), findsOneWidget);
    expect(find.text('CO ambiant (ppm)'), findsOneWidget);
  });

  testWidgets('Billing adapts to entretien and depannage',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BoilerCareApp());

    await tester.ensureVisible(find.text('Entretien'));
    await tester.tap(find.text('Entretien'));
    await pumpScreen(tester);
    await tester.tap(find.text('Jean Martin'));
    await pumpScreen(tester);

    expect(find.text('Facturation'), findsOneWidget);
    expect(find.text('Forfait entretien'), findsOneWidget);
    expect(find.widgetWithText(AppField, 'Montant forfait HT'), findsOneWidget);
    expect(find.text('5.5 %'), findsOneWidget);
    expect(find.text('10 %'), findsOneWidget);
    expect(find.text('20 %'), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_back).first);
    await pumpScreen(tester);
    await tester.tap(find.byIcon(Icons.arrow_back).first);
    await pumpScreen(tester);

    await tester.ensureVisible(find.text('Depannage'));
    await tester.tap(find.text('Depannage'));
    await pumpScreen(tester);
    await tester.tap(find.text('Jean Martin'));
    await pumpScreen(tester);

    expect(find.text('Ajouter une ligne'), findsOneWidget);
    expect(find.widgetWithText(AppField, 'Designation'), findsOneWidget);
    expect(find.widgetWithText(AppField, 'Montant HT'), findsOneWidget);
    expect(find.text('20 %'), findsOneWidget);

    await tester.ensureVisible(find.text('Ajouter une ligne'));
    await tester.tap(find.text('Ajouter une ligne'));
    await pumpScreen(tester);

    expect(find.text('Ligne 2'), findsOneWidget);
  });

  testWidgets(
      'Settings expose company identity and transparent PNG logo import',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BoilerCareApp());

    await tester.ensureVisible(find.text('Reglage'));
    await tester.tap(find.text('Reglage'));
    await pumpScreen(tester);

    expect(find.text('Entreprise'), findsOneWidget);
    expect(find.widgetWithText(AppField, 'Nom entreprise'), findsOneWidget);
    expect(find.widgetWithText(AppField, 'Adresse'), findsOneWidget);
    expect(find.widgetWithText(AppField, 'Email entreprise'), findsOneWidget);
    expect(find.text('Logo entreprise'), findsOneWidget);
    expect(find.text('Importer logo PNG transparent'), findsOneWidget);
    expect(find.textContaining('PNG avec fond transparent'), findsOneWidget);
  });

  testWidgets('Saved report appears in client history',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BoilerCareApp());

    await tester.ensureVisible(find.text('Entretien'));
    await tester.tap(find.text('Entretien'));
    await pumpScreen(tester);

    await tester.tap(find.text('Jean Martin'));
    await pumpScreen(tester);

    await tester.enterText(
        find.widgetWithText(AppField, 'Technicien'), 'Shadow');
    await tester.enterText(find.widgetWithText(AppField, 'Tirage (Pa)'), '12');
    await tester.ensureVisible(find.text('Enregistrer et generer les PDF'));
    await tester.tap(find.text('Enregistrer et generer les PDF'));
    await pumpScreen(tester);

    expect(find.text('Rapport enregistre'), findsOneWidget);
    expect(find.text('Telecharger le rapport'), findsOneWidget);
    expect(find.text('Telecharger la facture'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back).first);
    await pumpScreen(tester);
    await tester.tap(find.byIcon(Icons.arrow_back).first);
    await pumpScreen(tester);

    await tester.tap(find.text('Fiche client'));
    await pumpScreen(tester);
    await tester.tap(find.text('Jean Martin'));
    await pumpScreen(tester);

    expect(find.text('Historique client'), findsOneWidget);
    expect(find.text('Objet : Entretien'), findsOneWidget);
    expect(find.text('Documents : rapport + facturation'), findsOneWidget);
    expect(find.textContaining('Shadow'), findsNothing);

    await tester.ensureVisible(find.text('Objet : Entretien'));
    await tester.tap(find.text('Objet : Entretien'));
    await pumpScreen(tester);

    expect(find.text('Rapport'), findsOneWidget);
    expect(find.text('Telecharger le rapport'), findsOneWidget);
    expect(find.text('Telecharger la facture'), findsOneWidget);
    expect(find.text('Shadow'), findsOneWidget);
  });
}
