import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Unidade extends StatefulWidget {
  final int parte;
  final int unidade;
  const Unidade({super.key, required this.parte, required this.unidade});

  @override
  State<Unidade> createState() => _UnidadeState();
}

class _UnidadeState extends State<Unidade> {
  ProxyIndices proxyUnidade = ProxyIndices().getInterface();
  List<Widget> testes = [const Text('')];
  @override
  void initState() {
    super.initState();
    testeW();
    setState(() {});
  }

  Widget body() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(width: 6, color: Colors.black)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Center(
              child: ListView(shrinkWrap: true, children: testes),
            ),
          ),
        ),
      ),
    );
  }

  testeW() async {
    Map resultados = await proxyUnidade.find(widget.parte, false);
    Map unidade = resultados['Unidade'][widget.unidade];

    testes = [
      Row(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 100,
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(width: 4, color: Color(0xff2a4c09)),
                        top: BorderSide(width: 4, color: Color(0xff2a4c09)))),
              ),
            ),
          ),
          Flexible(
            flex: 4,
            child: Center(
                child: AutoSizeText(
              'Unidade ${unidade['NumUnidade']}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              maxLines: 2,
              minFontSize: 5,
            )),
          ),
          const Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: SizedBox(),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: SizedBox(),
          ),
          Flexible(
            flex: 4,
            child: Center(
                child: AutoSizeText(
              '${unidade['NomeUnidade']}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              maxLines: 4,
              minFontSize: 5,
            )),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 100,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 4, color: Color(0xff2a4c09)),
                        right: BorderSide(width: 4, color: Color(0xff2a4c09)))),
              ),
            ),
          ),
        ],
      ),
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
