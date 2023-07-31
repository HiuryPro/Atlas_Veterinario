import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:flutter/material.dart';

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
                        'IdImagem, NomeImagem, Imagem_Texto(*), Imagem_Seta(*), Imagem_Contorno(*)',
                        {'IdImagem': 18});

                    Map<int, Map> db = {};
                    db[teste[0]['IdImagem']] = teste[0];
                    db[18]!.remove('IdImagem');

                    for (Map texto in db[18]!['Imagem_Texto']) {
                      texto.remove('IdImagem');
                    }

                    for (Map seta in db[18]!['Imagem_Seta']) {
                      seta.remove('IdImagem');
                    }

                    for (Map contorno in db[18]!['Imagem_Contorno']) {
                      contorno.remove('IdImagem');
                    }
/*
                    print(db);
                    var resultados = await imagemProxy.find(18);
                    MemoryImage memoryImage = MemoryImage(resultados['Imagem']);
                    */
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
