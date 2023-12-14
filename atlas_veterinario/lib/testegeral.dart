import 'package:atlas_veterinario/Proxy/proxypagina.dart';
import 'package:flutter/material.dart';

class TesteGeral extends StatefulWidget {
  const TesteGeral({super.key});

  @override
  State<TesteGeral> createState() => _TesteGeralState();
}

class _TesteGeralState extends State<TesteGeral> {
  body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(children: [
        ElevatedButton(
            onPressed: () async {
              Map<int, Map>? dados = await ProxyPagina.instance.findFull(false);
              print(dados);
              // print(dados);
              // for (var dado in dados!.entries) {
              //   print(dado.key);
              //   print(dado.value);
              //   if (dado.value.containsKey('Capitulo')) {
              //     cap = dado.value['Capitulo'];
              //     print('Existe');
              //   } else if (dado.value.containsKey('IdImagem')) {
              //     Map<String, int> map = {'Capitulo': cap};
              //     print(map.runtimeType);
              //     dados2![dado.key]!.addAll(map);
              //   }

              //   print(dados2);
              // }
            },
            child: Text('Teste'))
      ]),
    );
  }

  Future<Map<int, Map>?> buscaTelaConteudo() async {
    ProxyPagina instance = ProxyPagina.instance;
    Map<int, Map>? resultado = await instance.findFull(false);
    int cap = 1;
    if (resultado != null) {
      resultado.forEach((key, value) {
        value.removeWhere((key, value) => value == null);
        if (value.containsKey('Capitulo')) {
          cap = value['Capitulo'];
        } else if (value.containsKey('IdImagem')) {
          Map<String, int> map = {'Capitulo': cap};
          value.addAll(map);
        }
      });
    }

    return resultado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
