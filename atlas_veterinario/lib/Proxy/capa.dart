// ignore_for_file: prefer_initializing_formals, unnecessary_this

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

class Capa implements ProxyInterface {
  // a key representa o IdImagem e o value o nome e o bytecode
  Map capas = {};

  buscadoBanco(int id) async {
    List resultados = await SupaDB.instance
        .select('Capa', 'IdCapa, Capa', {'IdCapa': id}, 'IdCapa', true);

    capas[id] = resultados[0];
    capas[id]!.remove('IdCapa');
  }

  @override
  find(int id, bool atualizar) async {
    print('Dados da imagem buscada');
    return capas[id];
  }

  @override
  findFull(bool atualizar) {
    print('Dados da imagem buscada');
    return capas;
  }
}
