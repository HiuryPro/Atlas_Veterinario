// ignore_for_file: prefer_conditional_assignment, prefer_initializing_formals, unnecessary_this

import 'package:atlas_veterinario/Proxy/paginap.dart';
import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

class ProxyPagina implements ProxyInterface {
  static ProxyPagina? instance;
  late PaginaP pagina;

  ProxyPagina() {
    pagina = PaginaP();
  }

  ProxyPagina getInstance() {
    if (instance == null) {
      instance = ProxyPagina();
    }
    return instance!;
  }

  @override
  find(int id, bool atualizar) async {
    if (pagina.paginas[id] == null || atualizar) {
      print('Busca do banco');
      await pagina.buscadoBanco(id);
    } else {
      print('Busca da memoria');
    }

    return pagina.find(id, atualizar);
  }

  @override
  findFull(bool atualizar) async {
    if (pagina.paginas.isEmpty || atualizar) {
      print('Busca do banco');
      await pagina.buscadoBancoFull();
    } else {
      print('Busca da memoria');
    }
    return pagina.findFull(atualizar);
  }
}
