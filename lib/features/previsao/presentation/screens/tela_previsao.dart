import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/previsao_tempo.dart';
import '../../services/cptec_service.dart';

class TelaPrevisao extends StatefulWidget {
  final int idCidade;
  final String nomeCidade;

  const TelaPrevisao({
    super.key,
    required this.idCidade,
    required this.nomeCidade,
  });

  @override
  State<TelaPrevisao> createState() => _TelaPrevisaoState();
}

class _TelaPrevisaoState extends State<TelaPrevisao> {
  late Future<CidadePrevisaoDetalhe> _futuroPrevisao;

  @override
  void initState() {
    super.initState();
    _carregarPrevisao();
  }

  void _carregarPrevisao() {
    _futuroPrevisao = CptecService.buscarPrevisaoCidade(widget.idCidade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeCidade),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.house),
          tooltip: 'Voltar para o início',
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.arrowRotateRight),
            onPressed: () {
              setState(() {
                _carregarPrevisao();
              });
            },
            tooltip: 'Atualizar previsão',
          ),
        ],
      ),
      body: FutureBuilder<CidadePrevisaoDetalhe>(
        future: _futuroPrevisao,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Erro ao carregar previsão: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.previsoes.isEmpty) {
            return const Center(
              child: Text('Nenhuma previsão disponível para esta localidade.'),
            );
          }

          final dados = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${dados.nome} - ${dados.uf}',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Última atualização: ${dados.atualizacao}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Previsão fornecida pelo CPTEC/INPE',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                ),
                const Divider(),
                const SizedBox(height: 8),

                // Lista de previsões diárias
                Expanded(
                  child: ListView.builder(
                    itemCount: dados.previsoes.length,
                    itemBuilder: (context, index) {
                      final previsao = dados.previsoes[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                previsao.diaFormatado,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.indigo,
                                ),
                              ),
                              const Divider(),
                              Text(
                                'Condição do tempo',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(previsao.descricaoCondicao),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 20,
                                runSpacing: 8,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.snowflake,
                                        color: Colors.lightBlue,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Text('Mín: ${previsao.tempoMin} °C'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const FaIcon(
                                        FontAwesomeIcons.sun,
                                        color: Colors.orange,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 6),
                                      Text('Máx: ${previsao.tempoMax} °C'),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.sun,
                                    color: Colors.deepOrange,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    previsao.iuv > 0
                                        ? 'Índice UV: ${previsao.iuv}'
                                        : 'Índice UV: indisponível',
                                  ),
                                ],
                              ),
                              if (previsao.iuv <= 0)
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    'O CPTEC retornou 0,0 para este período; '
                                    'o índice não foi informado.',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
