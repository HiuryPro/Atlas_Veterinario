import 'package:atlas_veterinario/Proxy/sumarioP.dart';
import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:atlas_veterinario/home.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SumarioInd extends StatefulWidget {
  const SumarioInd({super.key});

  @override
  State<SumarioInd> createState() => _SumarioIndState();
}

class _SumarioIndState extends State<SumarioInd> {
  ScrollController controllerScroll = ScrollController();
  Future<dynamic>? listaSumarioInd;
  Utils util = Utils();
  var myGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
    listaSumarioInd = SumarioP.instance.findFull();
  }

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: listaSumarioInd,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox(
                    height: 50,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox(
                      child: Column(
                    children: [
                      Expanded(child: SizedBox()),
                      Text(
                          'Essa página não possui conteudo, entrar em contato com o professor'),
                      Expanded(child: SizedBox()),
                    ],
                  ));
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                  child: ListView(
                    shrinkWrap: true,
                    controller: controllerScroll,
                    children: snapshot.data!.map<Widget>((e) {
                      switch (e['Tipo']) {
                        case 'Imagem':
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: retornaLinhaSumarioInd(
                                e['NomeImagem'], e['pagina']),
                          );

                        case 'Parte':
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: retornaLinhaSumarioInd(
                                'PARTE ${'I' * e['Parte']}', e['pagina']),
                          );

                        case 'Unidade':
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: retornaLinhaSumarioInd(
                                "UNIDADE ${e['NumUnidade']} - ${e['NomeUnidade']}",
                                e['pagina']),
                          );

                        case 'Capitulo':
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: retornaLinhaSumarioInd(
                                "Capitulo ${e['NumCapitulo']} - ${e['NomeCapitulo']}",
                                e['pagina']),
                          );
                        case 'Vazio':
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: retornaLinhaSumarioInd(
                                'Não possuiu conteúdo', e['pagina']),
                          );
                      }
                      return Text(e['Tipo']);
                    }).toList(),
                  ),
                );
              }),
        ));
  }

  AutoSizeText formataTexto(String texto) {
    return AutoSizeText(texto,
        style: TextStyle(
            fontSize: 20,
            decoration: TextDecoration.underline,
            color: Colors.black),
        maxFontSize: 20,
        minFontSize: 9,
        textAlign: TextAlign.start,
        maxLines: 3);
  }

  Align retornaLinhaSumarioInd(String texto, int pagina) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Home(pagina: pagina),
          ));
        },
        child: Row(
          children: [
            Expanded(child: formataTexto(texto)),
            SizedBox(
              width: 5,
            ),
            formataTexto(pagina.toString())
          ],
        ),
      ),
    );
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
