// ignore_for_file: prefer_initializing_formals, unnecessary_this

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

class Imagem implements ProxyInteface {
  // a key representa o IdImagem e o value o nome e o bytecode
  Map imagens = {};

  buscadoBanco(int id) async {
    List resultados =
        await SupaDB.instance.select('Images', '*', {'IdImages': id});

    for (Map dados in resultados) {
      List<String> selectedKeys = ['Image', 'NomeImagem', 'Zoom', 'Dx', 'Dy'];
      imagens[dados['IdImages']] = Map.fromEntries(dados.entries.where((entry) {
        return selectedKeys.contains(entry.key);
      }));
    }
  }

  @override
  find(int id) async {
    print('Dados da imagem buscada');
    return imagens[id];
  }
}
