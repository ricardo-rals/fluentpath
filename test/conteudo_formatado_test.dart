import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluentpath/widgets/conteudo_formatado.dart';

TextSpan? trechoCom(WidgetTester tester, String texto) {
  for (final elemento in find.byType(RichText).evaluate()) {
    TextSpan? achado;

    (elemento.widget as RichText).text.visitChildren((filho) {
      if (filho is TextSpan && filho.text == texto) {
        achado = filho;

        return false;
      }

      return true;
    });

    if (achado != null) {
      return achado;
    }
  }

  return null;
}

void main() {
  test('textoSimples tira a marcacao para a previa do card', () {
    const texto = '# Exemplos\n- I **am** a __student__.';

    expect(textoSimples(texto), 'Exemplos I am a student.');
  });

  testWidgets('ConteudoFormatado aplica negrito, sublinhado, titulo e lista',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ConteudoFormatado(
            texto: '# Exemplos\n- I **am** a __student__.',
          ),
        ),
      ),
    );

    expect(find.text('Exemplos'), findsOneWidget);

    expect(find.text('I am a student.'), findsOneWidget);

    expect(find.textContaining('**'), findsNothing);

    expect(trechoCom(tester, 'am')?.style?.fontWeight, FontWeight.bold);

    expect(
      trechoCom(tester, 'student')?.style?.decoration,
      TextDecoration.underline,
    );
  });
}
