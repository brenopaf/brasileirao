import 'package:brasileirao/widgets/escudo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JogosPage extends StatefulWidget {
  const JogosPage({Key? key}) : super(key: key);

  @override
  State<JogosPage> createState() => _JogosPageState();
}

class _JogosPageState extends State<JogosPage> {
  List<dynamic> partidas = [];
  int rodadaAtual = 1;
  bool loading = true;

  buscaCampeonato() async {
    var url = Uri.parse('https://api.api-futebol.com.br/v1/campeonatos/10');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer live_8eb32c90afd40777e788da2e2ba88f'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      setState(() {
        rodadaAtual = json['rodada_atual']['rodada'];
      });
      await buscaRodada();
    }
  }

  buscaRodada() async {
    setState(() {
      loading = true;
      partidas = [];
    });
    var url = Uri.parse(
        'https://api.api-futebol.com.br/v1/campeonatos/10/rodadas/' +
            rodadaAtual.toString());
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer live_8eb32c90afd40777e788da2e2ba88f'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      setState(() {
        partidas = json['partidas'];
        loading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao realizar a consulta'),
        ),
      );
    }
  }

  init() async {
    await buscaCampeonato();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogos'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: loading
                ? const LinearProgressIndicator()
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        // Botão para voltar uma rodada
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              if (rodadaAtual > 1) {
                                setState(() {
                                  rodadaAtual--;
                                  buscaRodada();
                                });
                              }
                            },
                            child: const Icon(Icons.arrow_back_ios),
                          ),
                        ),

                        Text(
                          'Rodada ${rodadaAtual.toString()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Botão para avançar uma rodada
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              if (rodadaAtual < 38) {
                                setState(() {
                                  rodadaAtual++;
                                  buscaRodada();
                                });
                              }
                            },
                            child: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 65),
            child: ListView.separated(
              itemBuilder: (_, index) {
                final partida = partidas[index];

                final dataRealizacao = partida['data_realizacao'] ?? '';
                final horaRealizacao = partida['hora_realizacao'] ?? '';
                final status = partida['status'] ?? '';

                final nomeMandante = partida['time_mandante']['sigla'];
                final placarMandante = partida['placar_mandante'] ?? '-';

                final siglaMandante = partida['time_mandante']['sigla'];

                final nomeVisitante = partida['time_visitante']['sigla'];
                final placarVisitante = partida['placar_visitante'] ?? '-';
                final siglaVisitante = partida['time_visitante']['sigla'];

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(dataRealizacao),
                        const Text(' '),
                        Text(horaRealizacao),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Column(
                            children: [
                              Text(nomeMandante),
                              EscudoWidget(sigla: siglaMandante),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            placarMandante.toString(),
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('X'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            placarVisitante.toString(),
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                        SizedBox(
                          child: Column(
                            children: [
                              Text(nomeVisitante),
                              EscudoWidget(sigla: siglaVisitante)
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(status),
                        ),
                      ],
                    ),
                  ],
                );
              },
              separatorBuilder: (_, __) => const Divider(
                height: 30,
              ),
              itemCount: partidas.length,
            ),
          ),
        ],
      ),
    );
  }
}
