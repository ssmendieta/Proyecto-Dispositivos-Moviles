import 'package:flutter_test/flutter_test.dart';
import 'package:salud_piel_app/main.dart';

void main() {
  testWidgets('App debe iniciar correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(App), findsOneWidget);
  });
}
