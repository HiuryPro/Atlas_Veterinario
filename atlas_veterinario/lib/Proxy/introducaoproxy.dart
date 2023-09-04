// ignore_for_file: prefer_conditional_assignment, prefer_initializing_formals, unnecessary_this

import 'package:atlas_veterinario/Proxy/introducao.dart';
import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

class ProxyIntroducao implements ProxyInterface {
  static ProxyIntroducao? instance;
  late IntroducaoP introducao;

  ProxyIntroducao() {
    introducao = IntroducaoP();
  }

  ProxyIntroducao getInterface() {
    if (instance == null) {
      instance = ProxyIntroducao();
    }
    return instance!;
  }

  @override
  find(int id, bool atualizar) async {
    if (introducao.introducao[id] == null || atualizar) {
      print('Busca do banco');
      await introducao.buscadoBanco(id);
    } else {
      print('Busca da memoria');
    }

    return introducao.find(id, atualizar);
  }

  @override
  Future<Map> findFull(bool atualizar) async {
    if (introducao.introducao.isEmpty || atualizar) {
      print('Busca do banco');
      await introducao.buscadoBancoFull();
    } else {
      print('Busca da memoria');
    }
    return introducao.findFull(atualizar);
  }
}
