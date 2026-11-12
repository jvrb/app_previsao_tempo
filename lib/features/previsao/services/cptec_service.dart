import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../models/cidade.dart';
import '../models/previsao_tempo.dart';

class CptecService {
  static Future<List<Cidade>> buscarCidades(String nomeCidade) async {
    final url = Uri.http(
      'servicos.cptec.inpe.br',
      '/XML/listaCidades',
      {'city': nomeCidade},
    );
    final resposta = await http.get(url);

    if (resposta.statusCode != 200) {
      throw Exception('Falha ao carregar cidades. Código: ${resposta.statusCode}');
    }

    final documento = XmlDocument.parse(latin1.decode(resposta.bodyBytes));
    final elementosCidade = documento.findAllElements('cidade');

    return elementosCidade.map((el) => Cidade.fromXml(el)).toList();
  }

  static Future<CidadePrevisaoDetalhe> buscarPrevisaoCidade(int idCidade) async {
    final url = Uri.parse('http://servicos.cptec.inpe.br/XML/cidade/$idCidade/previsao.xml');

    final resposta = await http.get(url);

    if (resposta.statusCode != 200) {
      throw Exception('Falha ao carregar previsão. Código: ${resposta.statusCode}');
    }

    final documento = XmlDocument.parse(latin1.decode(resposta.bodyBytes));
    return CidadePrevisaoDetalhe.fromXml(documento);
  }
}