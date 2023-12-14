import 'package:atlas_veterinario/Proxy/proxypagina.dart';
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
  List<Map<String, dynamic>> listaSumario = [];
  var myGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      listaSumario = await SumarioP.instance.findFull();
      print(listaSumario);
      setState(() {});
    });
  }

  Future<Map?> buscaTelaConteudo() async {
    ProxyPagina instance = ProxyPagina.instance;
    Map<int, Map>? resultado = await instance.findFull(false);
    print(resultado);
    if (resultado != null) {
      resultado.forEach((key, value) {
        value.removeWhere((key, value) => value == null);
      });
    }

    return resultado;
  }

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: listaSumario.map((e) {
              switch (e['Tipo']) {
                case 'Imagem':
                  return retornaLinhaSumario(
                      e['NomeImagem'], e['pagina'], Colors.yellow);

                case 'Parte':
                  return retornaLinhaSumario(
                      'Parte ${'I' * e['Parte']}', e['pagina'], Colors.green);

                case 'Unidade':
                  return retornaLinhaSumario(
                      e['NomeUnidade'], e['pagina'], Colors.purple);

                case 'Capitulo':
                  return retornaLinhaSumario(
                      e['NomeCapitulo'], e['pagina'], Colors.red);
                case 'Vazio':
                  return retornaLinhaSumario(
                      'Não possuiu conteúdo', e['pagina'], Colors.yellow);
              }
              return Text(e['Tipo']);
            }).toList(),
          ),
        ));
  }

  AutoSizeText formataTexto(String texto) {
    return AutoSizeText(texto,
        style: TextStyle(fontSize: 40),
        maxFontSize: 40,
        minFontSize: 9,
        maxLines: 2);
  }

  ListTile retornaLinhaSumario(String texto, int pagina, Color cor) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Home(pagina: pagina),
        ));
      },
      title: formataTexto(texto),
      tileColor: cor,
      trailing: formataTexto(pagina.toString()),
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
                  Color(0xff1a4d34),
                  Color(0xff386e41),
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
