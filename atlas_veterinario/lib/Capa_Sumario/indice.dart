import 'package:atlas_veterinario/Fala/textoprafala.dart';
import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Indices extends StatefulWidget {
  const Indices({super.key});

  @override
  State<Indices> createState() => _IndicesState();
}

class _IndicesState extends State<Indices> {
  List<Widget> testes = [];
  ScrollController controllerScroll = ScrollController();
  bool isFalando = false;
  ProxyIndices proxyIndices = ProxyIndices.instance;
  Utils util = Utils();
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
        padding: const EdgeInsets.only(left: 30.0, top: 10),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(width: 6, color: Colors.black)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Center(
              child: ListView(
                controller: controllerScroll,
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

  void falar(String fala) async {
    setState(() {
      isFalando = !isFalando;
    });

    if (isFalando) {
      await Fala.instance.flutterTts.stop();
      await Fala.instance.flutterTts.speak(fala);
    } else {
      await Fala.instance.flutterTts.stop();
    }

    setState(() {
      isFalando = false;
    });
  }

  teste() async {
    Map resultados = await proxyIndices.findFull(false);

    testes = [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
                onPressed: () {
                  // falar(
                  //  'Ajuda Observação: Clique no Icone de fala para ouvir o que está escrito. Clique novamente para parar.');
                },
                icon: const Icon(Icons.record_voice_over)),
          ),
        ],
      ),
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
      body: Stack(
        children: [
          body(),
          util.numeroPagina('3'),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 5, right: 10),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.4)),
                child: IconButton(
                    onPressed: () {
                      controllerScroll.animateTo(0,
                          duration: const Duration(
                              milliseconds: 500), //duration of scroll
                          curve: Curves.fastOutSlowIn //scroll type
                          );
                      print(controllerScroll.offset);
                      print(controllerScroll.position.maxScrollExtent);
                      print(MediaQuery.of(context).size.height);
                    },
                    icon: const Icon(Icons.arrow_upward)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 5, right: 10),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.4)),
                child: IconButton(
                    onPressed: () {
                      controllerScroll.animateTo(
                          controllerScroll.position.maxScrollExtent,
                          duration: const Duration(
                              milliseconds: 500), //duration of scroll
                          curve: Curves.fastOutSlowIn //scroll type
                          );
                      print(controllerScroll.offset);
                      print(controllerScroll.position.maxScrollExtent);
                      print(MediaQuery.of(context).size.height);
                    },
                    icon: const Icon(Icons.arrow_downward)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
