import 'package:atlas_veterinario/Proxy/introducaoproxy.dart';
import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Introducao extends StatefulWidget {
  const Introducao({super.key});

  @override
  State<Introducao> createState() => _IntroducaoState();
}

class _IntroducaoState extends State<Introducao> {
  List<Widget> testes = [];
  ProxyIntroducao proxyIntroducao = ProxyIntroducao.instance;
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
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, top: 10),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(width: 6, color: Colors.black)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: ListView(
            shrinkWrap: true,
            children: testes.isEmpty
                ? [
                    const SizedBox(
                      height: 50,
                      child:
                          Center(child: CircularProgressIndicator.adaptive()),
                    )
                  ]
                : testes,
          ),
        ),
      ),
    );
  }

  teste() async {
    Map resultados = await proxyIntroducao.findFull(false);
    testes = [
      const Text(
        'INTRODUÇÃO',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      SizedBox(height: 30)
    ];
    for (Map introducao in resultados.values) {
      testes.add(Padding(
        padding: const EdgeInsets.only(right: 50.0),
        child: AutoSizeText(
          '${introducao['Introducao']}',
          minFontSize: 10,
          maxFontSize: 20,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.justify,
        ),
      ));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [body(), util.numeroPagina('4')],
      ),
    );
  }
}
