import 'package:flutter/material.dart';

import 'CadImagem/buscarimagem.dart';
import 'Proxy/proxyimagens.dart';

class TesteWidget extends StatefulWidget {
  const TesteWidget({super.key});

  @override
  State<TesteWidget> createState() => _TesteWidgetState();
}

class _TesteWidgetState extends State<TesteWidget> {
  ProxyImagens imagemProxy = ProxyImagens().getInterface();
  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: BuscarImagemPainter(
                  id: 3,
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
