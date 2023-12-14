// ignore_for_file: prefer_conditional_assignment, prefer_initializing_formals, unnecessary_this

import 'package:atlas_veterinario/Proxy/capa.dart';
import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

class ProxyCapa implements ProxyInterface {
  static ProxyCapa instance = ProxyCapa();
  late Capa capa;

  ProxyCapa() {
    capa = Capa();
  }

  @override
  find(int id, bool atualizar) async {
    if (capa.capas[id] == null || atualizar) {
      print('Busca do banco');
      await capa.buscadoBanco(id);
    } else {
      print('Busca da memoria');
    }

    return capa.find(id, atualizar);
  }

  @override
  findFull(bool atualizar) async {
    return capa.findFull(atualizar);
  }
}
