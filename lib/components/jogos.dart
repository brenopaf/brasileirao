import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JogosPage extends StatefulWidget {
  const JogosPage({Key? key}) : super(key: key);

  @override
  State<JogosPage> createState() => _JogosPageState();
}

class _JogosPageState extends State<JogosPage> {
  List<dynamic> rodadas = [];

  buscaRodada(rodada) async {
    var url = Uri.parse(
        'https://api.api-futebol.com.br/v1/campeonatos/10/rodadas/' +
            rodada.toString());
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer live_8eb32c90afd40777e788da2e2ba88f'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      setState(() {
        rodadas = json;
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
    // TODO: implement initState
    super.initState();

    buscaRodada(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogos'),
      ),
      body: Column(
        children: [
          Text("rodata 1"),
          ListView.separated(
              itemBuilder: (context, index){
                return ListTile(
                  title: Text('aaaa'),
                );
              },
              separatorBuilder: (_, __) => Divider(),
              itemCount: 5)
        ],
      ),
    );
  }
}
