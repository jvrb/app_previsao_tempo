import 'package:xml/xml.dart';

class Cidade {
  final int id;
  final String nome;
  final String uf;

  Cidade({required this.id, required this.nome, required this.uf});

  // Fábrica para criar uma Cidade a partir de um elemento XML
  factory Cidade.fromXml(XmlElement xmlElement) {
    return Cidade(
      id: int.parse(xmlElement.findElements('id').single.innerText),
      nome: xmlElement.findElements('nome').single.innerText,
      uf: xmlElement.findElements('uf').single.innerText,
    );
  }
}
