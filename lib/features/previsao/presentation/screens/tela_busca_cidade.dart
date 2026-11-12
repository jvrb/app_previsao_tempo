import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/cidade.dart';
import '../../services/cptec_service.dart';
import 'tela_previsao.dart';

class TelaBuscaCidade extends StatefulWidget {
  const TelaBuscaCidade({super.key});

  @override
  State<TelaBuscaCidade> createState() => _TelaBuscaCidadeState();
}

class _TelaBuscaCidadeState extends State<TelaBuscaCidade> {
  final _controladorBusca = TextEditingController();
  List<Cidade> _cidades = [];
  bool _carregando = false;
  String? _mensagemErro;

  Future<void> _pesquisarCidades() async {
    final nome = _controladorBusca.text.trim();
    if (nome.isEmpty) return;

    setState(() {
      _carregando = true;
      _mensagemErro = null;
      _cidades = [];
    });

    try {
      final resultados = await CptecService.buscarCidades(nome);
      if (!mounted) return;
      setState(() {
        _cidades = resultados;
        if (resultados.isEmpty) {
          _mensagemErro = 'Nenhuma cidade encontrada.';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensagemErro = 'Erro ao buscar cidades: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controladorBusca.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsão do Tempo - CPTEC'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controladorBusca,
              decoration: const InputDecoration(
                labelText: 'Digite o nome da cidade',
                hintText: 'Ex: São José dos Campos',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _pesquisarCidades(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _carregando ? null : _pesquisarCidades,
                icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                label: const Text('Pesquisar cidade'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_carregando)
              const CircularProgressIndicator()
            else if (_mensagemErro != null)
              Text(
                _mensagemErro!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _cidades.length,
                  itemBuilder: (context, index) {
                    final cidade = _cidades[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          cidade.nome,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Estado (UF): ${cidade.uf}'),
                        trailing: const FaIcon(
                          FontAwesomeIcons.arrowRight,
                          size: 16,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TelaPrevisao(
                                idCidade: cidade.id,
                                nomeCidade: cidade.nome,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
