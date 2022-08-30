import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TabelaPage extends StatefulWidget {
  const TabelaPage({Key? key}) : super(key: key);

  @override
  State<TabelaPage> createState() => _TabelaPageState();
}

class _TabelaPageState extends State<TabelaPage> {
  List<dynamic> tabela = [];

  buscaTabela() async {
    var url =
        Uri.parse('https://api.api-futebol.com.br/v1/campeonatos/10/tabela');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer live_8eb32c90afd40777e788da2e2ba88f'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      setState(() {
        tabela = json;
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
    buscaTabela();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabela Completa'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          
          children: [DataTable(
            columnSpacing: 20,
            columns: const [
              DataColumn(label: Text('')),
              DataColumn(label: Text('J')),
              DataColumn(label: Text('V')),
              DataColumn(label: Text('E')),
              DataColumn(label: Text('D')),
              DataColumn(label: Text('GP')),
              DataColumn(label: Text('GC')),
              DataColumn(label: Text('SG')),
              DataColumn(label: Text('PTS')),
            ],
            rows: tabela
                .map((time) => DataRow(
                      cells: [
                        DataCell(Text(time['time']['sigla'])),
                        DataCell(Text(time['jogos'].toString())),
                        DataCell(Text(time['vitorias'].toString())),
                        DataCell(Text(time['empates'].toString())),
                        DataCell(Text(time['derrotas'].toString())),
                        DataCell(Text(time['gols_pro'].toString())),
                        DataCell(Text(time['gols_contra'].toString())),
                        DataCell(Text(time['saldo_gols'].toString())),
                        DataCell(Text(time['pontos'].toString())),
                      ],
                    ))
                .toList(),
          )],
        ),
      ),
    );
  }
}
