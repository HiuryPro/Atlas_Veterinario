import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Parte extends StatefulWidget {
  final int parte;
  final int pagina;
  const Parte({super.key, required this.parte, required this.pagina});

  @override
  State<Parte> createState() => _ParteState();
}

class _ParteState extends State<Parte> {
  List<Widget> testes = [];
  ProxyIndices proxyParte = ProxyIndices.instance;
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
        padding: const EdgeInsets.only(left: 40.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(width: 6, color: Colors.black)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 40.0),
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
    Map resultados = await proxyParte.find(widget.parte, false);
    testes.add(Center(
        child: AutoSizeText(
      'PARTE ${'I' * resultados['Parte']}',
      style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
      maxLines: 1,
      minFontSize: 30,
    )));
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
