import 'package:atlas_veterinario/Proxy/introducaoproxy.dart';
import 'package:flutter/material.dart';

class Introducao extends StatefulWidget {
  const Introducao({super.key});

  @override
  State<Introducao> createState() => _IntroducaoState();
}

class _IntroducaoState extends State<Introducao> {
  List<Widget> testes = [];
  ProxyIntroducao proxyIntroducao = ProxyIntroducao().getInterface();
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
      padding: const EdgeInsets.only(left: 15.0, top: 10),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(left: BorderSide(width: 6, color: Colors.black)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
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
    Map resultados = await proxyIntroducao.findFull();
    testes = [
      const Text(
        'INTRODUÇÃO',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      SizedBox(height: 30)
    ];
    for (Map introducao in resultados.values) {
      testes.add(Text('${introducao['Introducao']}'));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
