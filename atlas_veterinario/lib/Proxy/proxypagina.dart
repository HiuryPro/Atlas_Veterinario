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
  find(int id) async {
    if (pagina.paginas[id] == null) {
      print('Busca do banco');
      await pagina.buscadoBanco(id);
    } else {
      print('Busca da memoria');
    }

    return pagina.find(id);
  }

  @override
  findFull() async {
    if (pagina.paginas.isEmpty) {
      print('Busca do banco');
      await pagina.buscadoBancoFull();
    } else {
      print('Busca da memoria');
    }
    return pagina.findFull();
  }
}
