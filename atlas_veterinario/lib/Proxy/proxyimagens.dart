// ignore_for_file: prefer_conditional_assignment, prefer_initializing_formals, unnecessary_this

import 'package:atlas_veterinario/Proxy/proxyInteface.dart';

import 'imagens.dart';

class ProxyImagens implements ProxyInteface {
  static ProxyImagens instance = ProxyImagens();
  late Imagem imagem;

  ProxyImagens() {
    imagem = Imagem();
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
}
