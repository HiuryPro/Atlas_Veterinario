// ignore_for_file: prefer_conditional_assignment, prefer_initializing_formals, unnecessary_this

import 'package:atlas_veterinario/Proxy/indices.dart';
import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

class ProxyIndices implements ProxyInterface {
  static ProxyIndices? instance;
  late IndicesP indice;

  ProxyIndices() {
    indice = IndicesP();
  }

  ProxyIndices getInterface() {
    if (instance == null) {
      instance = ProxyIndices();
    }
    return instance!;
  }

  @override
  find(int id, bool atualizar) async {
    if (indice.indices[id] == null || atualizar) {
      print('Busca do banco');
      await indice.buscadoBanco(id);
    } else {
      print('Busca da memoria');
    }

    return indice.find(id, atualizar);
  }

  findFull(bool atualizar) async {
    if (indice.indices.isEmpty || atualizar) {
      print('Busca do banco');
      await indice.buscadoBancoFull();
    } else {
      print('Busca da memoria');
    }
    return indice.findFull(atualizar);
  }
}
