import 'package:brasileirao/components/jogos.dart';
import 'package:brasileirao/components/menu.dart';
import 'package:brasileirao/tabela.dart';
import 'package:brasileirao/widgets/escudo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brasileirão',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const MyHomePage(title: 'Brasileirão 2022'),
        '/tabela': (context) => const TabelaPage(),
        '/jogos': (context) => const JogosPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> tabela = [];

  iniciais(String nome) {
    return (nome[0] + nome[1] + nome[2]).toUpperCase();
  }

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
        title: Center(child: Text(widget.title)),
        actions: [
          IconButton(
            onPressed: () => buscaTabela(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: MenuComponent(title: widget.title),
      body: RefreshIndicator(
        onRefresh: () async {
          buscaTabela();
        },
        color: Colors.red,
        child: ListView.separated(
          itemBuilder: (context, index) {
            final item = tabela[index];         

            final sigla = item['time']['sigla'];

            return ListTile(
              leading: EscudoWidget(sigla: sigla),
              
              title:
                  Text('#${item['posicao']} ${item['time']['nome_popular']}'),
              trailing: CircleAvatar(
                child: Text(item['pontos'].toString()),
                backgroundColor: item['posicao'] == 1
                    ? Colors.green
                    : item['posicao'] < 17
                        ? Colors.blue
                        : Colors.red,
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: tabela.length,
        ),
      ),
    );
  }
}
