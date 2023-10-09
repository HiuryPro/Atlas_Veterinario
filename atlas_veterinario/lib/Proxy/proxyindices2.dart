// ignore_for_file: prefer_conditional_assignment, prefer_initializing_formals, unnecessary_this

import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

import 'indices2.dart';

class ProxyIndices2 implements ProxyInterface {
  static ProxyIndices2? instance;
  late IndicesP2 indice;

  ProxyIndices2() {
    indice = IndicesP2();
  }

  ProxyIndices2 getInterface() {
    if (instance == null) {
      instance = ProxyIndices2();
    }
    return instance!;
  }

  @override
  Future<Map> find(int id, bool atualizar) async {
    if (indice.indices[id] == null || atualizar) {
      print('Busca do banco');
      await indice.buscadoBanco(id);
    } else {
      print('Busca da memoria');
    }

    return indice.find(id, atualizar);
  }

  @override
  Future<Map> findFull(bool atualizar) async {
    if (indice.indices.isEmpty || atualizar) {
      print('Busca do banco');
      await indice.buscadoBancoFull();
    } else {
      print('Busca da memoria');
    }
    return indice.findFull(atualizar);
  }
}
