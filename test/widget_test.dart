import 'package:flutter_test/flutter_test.dart';
import 'package:pierre_feuille_ciseaux/main.dart';

void main() {
  testWidgets('joue une manche', (tester) async {
    await tester.pumpWidget(const MonApp());
    expect(find.text('Fais ton choix !'), findsOneWidget);
    await tester.tap(find.text('Pierre'));
    await tester.pump();
    expect(find.text('VS'), findsOneWidget);
    expect(find.text('Recommencer'), findsOneWidget);
  });
}
