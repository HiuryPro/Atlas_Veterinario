// ignore_for_file: prefer_conditional_assignment, prefer_initializing_formals, unnecessary_this

import 'package:atlas_veterinario/Proxy/introducao.dart';
import 'package:atlas_veterinario/Proxy/proxyInteface.dart';

class ProxyIntroducao implements ProxyInteface {
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
  find(int id) async {
    if (introducao.introducao[id] == null) {
      print('Busca do banco');
      await introducao.buscadoBanco(id);
    } else {
      print('Busca da memoria');
    }

    return introducao.find(id);
  }

  findFull() async {
    if (introducao.introducao.isEmpty) {
      print('Busca do banco');
      await introducao.buscadoBancoFull();
    } else {
      print('Busca da memoria');
    }
    return introducao.findFull();
  }
}
