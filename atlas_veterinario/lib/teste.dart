import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:flutter/material.dart';

import 'Proxy/proxyimagens.dart';

class TesteWidget extends StatefulWidget {
  const TesteWidget({super.key});

  @override
  State<TesteWidget> createState() => _TesteWidgetState();
}

class _TesteWidgetState extends State<TesteWidget> {
  ProxyImagens imagemProxy = ProxyImagens.instance;
  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () async {
                    List resultados = await SupaDB.instance.select(
                        'Pagina',
                        'IdPagina, Parte, Unidade, Capitulo,IdImagem',
                        {},
                        'IdPagina',
                        true);
                    print(resultados.runtimeType);
                  },
                  child: Text('Teste'))
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
