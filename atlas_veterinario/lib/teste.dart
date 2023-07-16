import 'package:flutter/material.dart';

import 'Proxy/proxyimagens.dart';

class TesteWidget extends StatefulWidget {
  const TesteWidget({super.key});

  @override
  State<TesteWidget> createState() => _TesteWidgetState();
}

class _TesteWidgetState extends State<TesteWidget> {
  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(shrinkWrap: true, children: [
              const Text('Acessa a tela que salva a imagem no banco'),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/testeImage');
                  },
                  child: Text('Vai para a tela de cadastro de imagem')),
              const Text("Testar funções que busca Imagem"),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () async {
                    Map imagem = {};
                    ProxyImagens imagemProxy = ProxyImagens.instance;
                    imagem = await imagemProxy.find(1);
                    // print(imagem);
                    imagem = await imagemProxy.find(1);
                    setState(() {});
                    // print(imagem);
                  },
                  child: const Text('Teste'))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
