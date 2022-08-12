import 'package:flutter/material.dart';

class MenuComponent extends StatelessWidget {
  final String title;
  const MenuComponent({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
         ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            title: const Text('Resumo'),
            onTap: () {
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, '/');
            },
          ),
         ListTile(
            leading: const Icon(Icons.table_view_outlined),
            title: const Text('Tabela Completa'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/tabela');            
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('Jogos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/jogos');
            },
          ),
        ],
      ),
    );
  }
}
