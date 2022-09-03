import 'package:flutter/material.dart';

class EscudoWidget extends StatelessWidget {

  final String sigla;
  const EscudoWidget({Key? key, required this.sigla}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final svg = Image.asset(
      './lib/assets/$sigla.png',
      fit: BoxFit.contain,
    );

    return SizedBox(child: svg, width: 50, height: 50);
  }
}
