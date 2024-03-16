import 'package:atlas_veterinario/Proxy/sumarioP.dart';
import 'package:atlas_veterinario/home.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Sumario extends StatefulWidget {
  const Sumario({super.key});

  @override
  State<Sumario> createState() => _SumarioState();
}

class _SumarioState extends State<Sumario> {
  Future<dynamic>? listaSumario;
  var myGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
    listaSumario = SumarioP.instance.findFull();
  }

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: listaSumario,
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
                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.map<Widget>((e) {
                    switch (e['Tipo']) {
                      case 'Imagem':
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child:
                              retornaLinhaSumario(e['NomeImagem'], e['pagina']),
                        );

                      case 'Parte':
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: retornaLinhaSumario(
                              'PARTE ${'I' * e['Parte']}', e['pagina']),
                        );

                      case 'Unidade':
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: retornaLinhaSumario(
                              "UNIDADE ${e['NumUnidade']} - ${e['NomeUnidade']}",
                              e['pagina']),
                        );

                      case 'Capitulo':
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: retornaLinhaSumario(
                              "Capitulo ${e['NumCapitulo']} - ${e['NomeCapitulo']}",
                              e['pagina']),
                        );
                      case 'Vazio':
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: retornaLinhaSumario(
                              'Não possuiu conteúdo', e['pagina']),
                        );
                    }
                    return Text(e['Tipo']);
                  }).toList(),
                );
              }),
        ));
  }

  AutoSizeText formataTexto(String texto) {
    return AutoSizeText(texto,
        style: const TextStyle(
            fontSize: 20,
            decoration: TextDecoration.underline,
            color: Colors.black),
        maxFontSize: 20,
        minFontSize: 9,
        textAlign: TextAlign.start,
        maxLines: 2);
  }

  Align retornaLinhaSumario(String texto, int pagina) {
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
            const SizedBox(
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
      appBar: AppBar(
        title: const Text('Sumario'),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/home');
            },
            icon: const Icon(Icons.arrow_back)),
        shadowColor: Colors.transparent,
        flexibleSpace: Container(
            height: 56,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff1a4683),
                  Color(0xff3574cc),
                  Colors.white,
                  Colors.white
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const SizedBox()),
      ),
      body: body(),
    );
  }
}
