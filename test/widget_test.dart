import 'package:app_previsao_tempo/features/previsao/models/cidade.dart';
import 'package:app_previsao_tempo/features/previsao/models/previsao_tempo.dart';
import 'package:app_previsao_tempo/features/previsao/presentation/screens/tela_busca_cidade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xml/xml.dart';

void main() {
  test('parses city XML using statically typed XML elements', () {
    final xml = XmlDocument.parse(
      '<cidade><nome>São José dos Campos</nome><uf>SP</uf><id>4963</id></cidade>',
    );

    final cidade = Cidade.fromXml(xml.rootElement);

    expect(cidade.id, 4963);
    expect(cidade.nome, 'São José dos Campos');
    expect(cidade.uf, 'SP');
  });

  test('parses CPTEC forecast field names', () {
    final xml = XmlDocument.parse(
      '<cidade><nome>São José dos Campos</nome><uf>SP</uf>'
      '<atualizacao>2026-11-11</atualizacao>'
      '<previsao><dia>2026-11-12</dia><tempo>c</tempo>'
      '<maxima>26</maxima><minima>16</minima><iuv>0.0</iuv></previsao>'
      '</cidade>',
    );

    final previsao = CidadePrevisaoDetalhe.fromXml(xml).previsoes.single;

    expect(previsao.tempoMin, 16);
    expect(previsao.tempoMax, 26);
    expect(previsao.codigoCondicao, 'c');
    expect(previsao.descricaoCondicao, 'Chuva');
    expect(previsao.diaFormatado, '12/11/2026');
    expect(previsao.iuv, 0);
  });

  testWidgets('shows a visible search button below the city field', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: TelaBuscaCidade()));

    final input = tester.getTopLeft(find.byType(TextField));
    final button = tester.getTopLeft(find.text('Pesquisar cidade'));

    expect(find.text('Pesquisar cidade').hitTestable(), findsOneWidget);
    expect(find.byType(FaIcon), findsOneWidget);
    expect(
      tester.widget<FaIcon>(find.byType(FaIcon)).icon?.codePoint,
      FontAwesomeIcons.magnifyingGlass.codePoint,
    );
    expect(button.dy, greaterThan(input.dy));
  });
}
