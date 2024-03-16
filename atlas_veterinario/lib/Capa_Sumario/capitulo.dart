import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Capitulo extends StatefulWidget {
  final int parte;
  final int unidade;
  final int capitulo;
  final int pagina;
  const Capitulo(
      {super.key,
      required this.parte,
      required this.capitulo,
      required this.unidade,
      required this.pagina});

  @override
  State<Capitulo> createState() => _CapituloState();
}

class _CapituloState extends State<Capitulo> {
  ProxyIndices proxyIndice = ProxyIndices.instance;
  List<Widget> testes = [const Text('')];
  Utils util = Utils();
  @override
  void initState() {
    super.initState();
    testeW();
    setState(() {});
  }

  Widget body() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 40.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(width: 6, color: Colors.black)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 40.0),
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
    Map resultados = await proxyIndice.find(widget.parte, false);
    Map unidade = resultados['Unidade'][widget.unidade];
    Map capitulo = unidade['Capitulo'][widget.capitulo];

    testes = [
      const Flexible(flex: 1, child: SizedBox()),
      Flexible(
        flex: 1,
        child: Container(
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 4, color: Colors.black))),
          child: Center(
            child: AutoSizeText(
              'Capitulo${capitulo['NumCapitulo']} - ${capitulo['NomeCapitulo']}',
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
      body: Stack(
        children: [body(), util.numeroPagina(widget.pagina.toString())],
      ),
    );
  }
}
