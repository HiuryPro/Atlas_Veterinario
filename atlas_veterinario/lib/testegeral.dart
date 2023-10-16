import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:atlas_veterinario/Proxy/proxypagina.dart';
import 'package:atlas_veterinario/Proxy/sumarioP.dart';
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
        const Text(
          '1 2',
          style: TextStyle(
            fontSize: 60,
            shadows: [
              Shadow(
                  color: Colors.yellow, // Border color
                  offset: Offset(-2, -2),
                  blurRadius: 2.5 // Adjust this for border width
                  ),
              Shadow(
                  color: Colors.yellow, // Border color
                  offset: Offset(2, -2),
                  blurRadius: 2.5 // Adjust this for border width
                  ),
              Shadow(
                  color: Colors.yellow, // Border color
                  offset: Offset(-2, 2),
                  blurRadius: 2.5 // Adjust this for border width
                  ),
              Shadow(
                  color: Colors.yellow, // Border color
                  offset: Offset(2, 2),
                  blurRadius: 2.5 // Adjust this for border width
                  ),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              List teste = await SumarioP.instance.findFull();
              print(teste);
            },
            child: Text('Teste2')),
        ElevatedButton(
            onPressed: () async {
              Map sumario = {'pagina': 1};
              Map full = await ProxyIndices().getInterface().findFull(false);
              Map parte = full[1];
              Map unidade = parte['Unidade'][1];
              Map capitulo = unidade['Capitulo'][1];
              print(Colors.yellow.value);
              print(capitulo);
              sumario.addAll(capitulo);
              print(sumario);
            },
            child: Text('Teste')),
        ElevatedButton(
            onPressed: () async {
              List<int> listaNum = [1, 2, 3, 4];

              print(listaNum.contains(1));
            },
            child: Text('Teste5')),
        ElevatedButton(
            onPressed: () async {
              int maxPagina =
                  await SupaDB.instance.clienteSupaBase.rpc('max_value_pagina');
              while (maxPagina >= 12) {
                await SupaDB.instance.clienteSupaBase.from('Pagina').update(
                    {'IdPagina': maxPagina + 1}).match({'IdPagina': maxPagina});
                print(maxPagina + 1);
                maxPagina--;
              }
            },
            child: Text('Teste'))
      ]),
    );
  }

  Future<Map<int, Map>?> buscaTelaConteudo() async {
    ProxyPagina instance = ProxyPagina().getInstance();
    Map<int, Map>? resultado = await instance.findFull(false);
    print(resultado);
    if (resultado != null) {
      resultado.forEach((key, value) {
        value.removeWhere((key, value) => value == null);
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
