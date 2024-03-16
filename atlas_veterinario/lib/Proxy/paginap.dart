import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

import '../DadosDB/supa.dart';

class PaginaP implements ProxyInterface {
  Map paginas = {};

  buscadoBanco(int id) async {
    List resultados = await SupaDB.instance.select(
        'Pagina',
        'IdPagina, Parte, Unidade, Capitulo, IdImagem',
        {'IdPagina': id},
        'IdPagina',
        true);
    if (resultados.isNotEmpty) {
      paginas[resultados[0]['IdPagina']] = resultados[0];
      paginas[resultados[0]['IdPagina']]!.remove('IdPagina');

      int cap = 1;

      paginas[id].removeWhere((key, value) => value == null);
      if (paginas[id].containsKey('Capitulo')) {
        cap = paginas[id]['Capitulo'];
      } else if (paginas[id].containsKey('IdImagem')) {
        Map<String, int> map = {'Capitulo': cap};
        paginas[id].addAll(map);
      }
      paginas[id].addAll({'Pagina': id});
    }
  }

  buscadoBancoFull() async {
    paginas.clear();
    List resultados = await SupaDB.instance.select('Pagina',
        'IdPagina, Parte, Unidade, Capitulo,IdImagem', {}, 'IdPagina', true);

    for (Map resultado in resultados) {
      paginas[resultado['IdPagina']] = resultado;
      paginas[resultado['IdPagina']]!.remove('IdPagina');
    }

    int cap = 1;

    paginas.forEach((key, value) {
      value.removeWhere((key, value) => value == null);
      if (value.containsKey('Capitulo')) {
        cap = value['Capitulo'];
      } else if (value.containsKey('IdImagem')) {
        Map<String, int> map = {'Capitulo': cap};
        value.addAll(map);
      }
      value.addAll({'Pagina': key});
    });
  }

  @override
  find(int id, bool atualizar) async {
    print('Dados da Pagina buscada');
    if (paginas.containsKey(id)) {
      return paginas[id];
    } else {
      return null;
    }
  }

  @override
  Future<Map> findFull(bool atualizar) async {
    print('Dados da Pagina buscada');
    return paginas;
  }
}
