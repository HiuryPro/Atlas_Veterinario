// ignore_for_file: prefer_conditional_assignment, prefer_initializing_formals, unnecessary_this

import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

import 'imagens.dart';

class ProxyImagens implements ProxyInterface {
  static ProxyImagens? instance;
  late Imagem imagem;

  ProxyImagens() {
    imagem = Imagem();
  }

  ProxyImagens getInterface() {
    if (instance == null) {
      instance = ProxyImagens();
    }
    return instance!;
  }

  @override
  find(int id) async {
    if (imagem.imagens[id] == null) {
      print('Busca do banco');
      await imagem.buscadoBanco(id);
    } else {
      print('Busca da memoria');
    }

    return imagem.find(id);
  }

  findFull() async {
    if (imagem.imagens.isEmpty) {
      print('Busca do banco');
      await imagem.buscadoBancoFull();
    } else {
      print('Busca da memoria');
    }
    return imagem.findFull();
  }
}
