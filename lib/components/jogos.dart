import 'package:flutter/material.dart';
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

  buscaRodada() async {
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
        print(partidas[1]);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao realizar a consulta'),
        ),
      );
    }
  }

  @override
  void initState() {
    buscaRodada();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Rodada ${rodadaAtual.toString()}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView.separated(
                itemBuilder: (_, index) {
                  final partida = partidas[index];
                  return Row(
                    children: [
                      SizedBox(
                        child: Center(
                          child: Text(partida['placar'],
                          style: TextStyle(fontSize: 20),),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                      )
                    ],
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: partidas.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
