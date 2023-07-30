import 'package:atlas_veterinario/DadosDB/supa.dart';
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
                    var teste = await SupaDB.instance.select(
                        'Imagem',
                        'IdImagem, NomeImagem, Imagem_Texto(Texto), Imagem_Seta(*), Imagem_Contorno(*)',
                        {'IdImagem': 18});

                    print(teste);
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
