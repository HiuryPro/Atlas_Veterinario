import 'package:flutter/material.dart';

import 'CadImagem/buscarimagem.dart';
import 'Proxy/proxyimagens.dart';

class TesteWidget extends StatefulWidget {
  const TesteWidget({super.key});

  @override
  State<TesteWidget> createState() => _TesteWidgetState();
}

class _TesteWidgetState extends State<TesteWidget> {
  ProxyImagens imagemProxy = ProxyImagens.instance;
  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView(
            children: const [
              SizedBox(
                width: 300,
                height: 300,
                child: BuscarImagemPainter(
                  id: 2,
                ),
              ),
              SizedBox(
                width: 300,
                height: 300,
                child: BuscarImagemPainter(
                  id: 1,
                ),
              ),
              SizedBox(
                width: 300,
                height: 300,
                child: BuscarImagemPainter(
                  id: 1,
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
