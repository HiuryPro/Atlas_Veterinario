import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Capitulo extends StatefulWidget {
  final int id;
  final int unidade;
  final int capitulo;
  const Capitulo(
      {super.key,
      required this.id,
      required this.capitulo,
      required this.unidade});

  @override
  State<Capitulo> createState() => _CapituloState();
}

class _CapituloState extends State<Capitulo> {
  ProxyIndices proxyIndice = ProxyIndices().getInterface();
  List<Widget> testes = [const Text('')];
  @override
  void initState() {
    super.initState();
    testeW();
    setState(() {});
  }

  Widget body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(width: 6, color: Colors.black)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: testes),
            ),
          ),
        ),
      ),
    );
  }

  testeW() async {
    Map resultados = await proxyIndice.find(widget.id);
    Map unidade = resultados['Unidade'][widget.unidade];
    Map capitulo = unidade['Capitulo'][widget.capitulo];
    print(resultados.keys);
    print(resultados);

    testes = [
      const Flexible(flex: 1, child: SizedBox()),
      Flexible(
        flex: 1,
        child: Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 4, color: Colors.black))),
          child: Center(
            child: AutoSizeText(
              'Cap${capitulo['NumCapitulo']}- ${capitulo['NomeCapitulo']}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              maxLines: 2,
              minFontSize: 5,
            ),
          ),
        ),
      ),
      const Flexible(flex: 4, child: SizedBox()),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
