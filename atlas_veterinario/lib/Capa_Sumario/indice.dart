import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Indices extends StatefulWidget {
  const Indices({super.key});

  @override
  State<Indices> createState() => _IndicesState();
}

class _IndicesState extends State<Indices> {
  List<Widget> testes = [];
  ProxyIndices proxyIndices = ProxyIndices().getInterface();
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await teste();
    });
    setState(() {});
    super.initState();
  }

  Widget body() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 10),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(width: 6, color: Colors.black)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: testes.isEmpty
                    ? [
                        const SizedBox(
                          height: 50,
                          child: Center(
                              child: CircularProgressIndicator.adaptive()),
                        )
                      ]
                    : testes,
              ),
            ),
          ),
        ),
      ),
    );
  }

  teste() async {
    Map resultados = await proxyIndices.findFull();
    testes = [
      const AutoSizeText(
        'ÍNDICE',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        minFontSize: 10,
      ),
    ];
    for (Map parte in resultados.values) {
      setState(() {
        testes.add(Padding(
          padding: const EdgeInsets.only(bottom: 15, top: 15),
          child: Center(
              child: AutoSizeText("PARTE ${'I' * parte['Parte']}",
                  style: const TextStyle(fontSize: 20), minFontSize: 10)),
        ));
      });

      List idsUnidades = parte['Unidade'].keys.toList();
      idsUnidades.sort();

      for (int idUnidade in idsUnidades) {
        Map unidade = parte['Unidade'][idUnidade];
        setState(() {
          testes.add(Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: AutoSizeText(
              'Unidade ${unidade['NumUnidade']}- ${unidade['NomeUnidade']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
              minFontSize: 10,
              maxLines: 3,
            ),
          ));
        });

        List idsCapitulos = unidade['Capitulo'].keys.toList();
        idsCapitulos.sort();

        for (int idCapitulo in idsCapitulos) {
          Map capitulo = unidade['Capitulo'][idCapitulo];
          setState(
            () {
              testes.add(Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: AutoSizeText(
                  'Cap${capitulo['NumCapitulo']}- ${capitulo['NomeCapitulo']}',
                  minFontSize: 10,
                  maxLines: 3,
                ),
              ));
            },
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
