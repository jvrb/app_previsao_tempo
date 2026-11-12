import 'package:xml/xml.dart';

class PrevisaoTempo {
  final String dia;
  final double tempoMin;
  final double tempoMax;
  final String codigoCondicao;
  final double iuv;

  PrevisaoTempo({
    required this.dia,
    required this.tempoMin,
    required this.tempoMax,
    required this.codigoCondicao,
    required this.iuv,
  });

  static const _descricoesCondicao = <String, String>{
    'ec': 'Encoberto com chuvas isoladas',
    'ci': 'Chuvas isoladas',
    'c': 'Chuva',
    'in': 'Instável',
    'pp': 'Possibilidade de pancadas de chuva',
    'cm': 'Chuva pela manhã',
    'cn': 'Chuva à noite',
    'pt': 'Pancadas de chuva à tarde',
    'pm': 'Pancadas de chuva pela manhã',
    'np': 'Nublado com pancadas de chuva',
    'pc': 'Pancadas de chuva',
    'pn': 'Parcialmente nublado',
    'cv': 'Chuvisco',
    'ch': 'Chuvoso',
    't': 'Tempestade',
    'ps': 'Predomínio de sol e encoberto',
    'n': 'Nublado',
    'cl': 'Céu claro',
    'nv': 'Nevoeiro',
    'g': 'Geada',
    'ne': 'Neve',
    'nd': 'Não definido',
    'pnt': 'Pancadas de chuva à noite',
    'psc': 'Possibilidade de chuva',
    'pcm': 'Possibilidade de chuva pela manhã',
    'pct': 'Possibilidade de chuva à tarde',
    'pcn': 'Possibilidade de chuva à noite',
    'npt': 'Nublado com pancadas à tarde',
    'npn': 'Nublado com pancadas à noite',
    'ncn': 'Nublado com possibilidade de chuva à noite',
    'nct': 'Nublado com possibilidade de chuva à tarde',
    'ncm': 'Nublado com possibilidade de chuva pela manhã',
    'npm': 'Nublado com pancadas pela manhã',
    'npp': 'Nublado com possibilidade de pancadas de chuva',
    'vn': 'Variação de nebulosidade',
    'ct': 'Chuva à tarde',
    'ppn': 'Possibilidade de pancadas de chuva à noite',
    'ppt': 'Possibilidade de pancadas de chuva à tarde',
    'ppm': 'Possibilidade de pancadas de chuva pela manhã',
  };

  String get descricaoCondicao =>
      _descricoesCondicao[codigoCondicao] ??
      'Condição não informada (código: $codigoCondicao)';

  String get diaFormatado {
    final data = DateTime.tryParse(dia);
    if (data == null) return dia;

    final diaTexto = data.day.toString().padLeft(2, '0');
    final mesTexto = data.month.toString().padLeft(2, '0');
    return '$diaTexto/$mesTexto/${data.year}';
  }

  factory PrevisaoTempo.fromXml(XmlElement xmlElement) {
    return PrevisaoTempo(
      dia: xmlElement.findElements('dia').single.innerText,
      tempoMin: double.parse(
        xmlElement.findElements('minima').single.innerText,
      ),
      tempoMax: double.parse(
        xmlElement.findElements('maxima').single.innerText,
      ),
      codigoCondicao: xmlElement.findElements('tempo').single.innerText,
      iuv:
          double.tryParse(xmlElement.findElements('iuv').single.innerText) ??
          0.0,
    );
  }
}

class CidadePrevisaoDetalhe {
  final String nome;
  final String uf;
  final String atualizacao;
  final List<PrevisaoTempo> previsoes;

  CidadePrevisaoDetalhe({
    required this.nome,
    required this.uf,
    required this.atualizacao,
    required this.previsoes,
  });

  factory CidadePrevisaoDetalhe.fromXml(XmlDocument documentoXml) {
    final nome = documentoXml.findAllElements('nome').single.innerText;
    final uf = documentoXml.findAllElements('uf').single.innerText;
    final atualizacao = documentoXml
        .findAllElements('atualizacao')
        .single
        .innerText;

    final elementosPrevisao = documentoXml.findAllElements('previsao');
    final listaPrevisoes = elementosPrevisao
        .map((el) => PrevisaoTempo.fromXml(el))
        .toList();

    return CidadePrevisaoDetalhe(
      nome: nome,
      uf: uf,
      atualizacao: atualizacao,
      previsoes: listaPrevisoes,
    );
  }
}
