import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:flutter/material.dart';

class Vazio extends StatefulWidget {
  final int pagina;
  const Vazio({super.key, required this.pagina});

  @override
  State<Vazio> createState() => _VazioState();
}

class _VazioState extends State<Vazio> {
  Utils util = Utils();

  Widget body() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(width: 6, color: Colors.black)),
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 30.0),
            child: Center(
              child: Column(
                children: [
                  Expanded(child: SizedBox()),
                  Text('Essa página não possui conteudo'),
                  Expanded(child: SizedBox())
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
