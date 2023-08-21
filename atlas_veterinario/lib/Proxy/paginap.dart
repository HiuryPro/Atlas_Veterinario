import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

import '../DadosDB/supa.dart';

class PaginaP implements ProxyInterface {
  Map paginas = {};

  buscadoBanco(int id) async {
    List resultados = await SupaDB.instance.select(
        'Pagina',
        'IdPagina, Pagina_Partes(*), Pagina_Imagem(*)',
        {'IdPagina': id},
        'IdPagina',
        true);
    if (resultados.isNotEmpty) {
      paginas[resultados[0]['IdPagina']] = resultados[0];
      paginas[resultados[0]['IdPagina']].remove('IdPagina');
    }
  }

  buscadoBancoFull() async {
    List resultados = await SupaDB.instance.select('Pagina',
        'IdPagina, Pagina_Partes(*), Pagina_Imagem(*)', {}, 'IdPagina', true);

    for (Map resultado in resultados) {
      paginas[resultado['IdPagina']] = resultado;
      paginas[resultado['IdPagina']].remove('IdPagina');
    }
  }

  @override
  find(int id) async {
    print('Dados da Pagina buscada');
    if (paginas.containsKey(id)) {
      return paginas[id];
    } else {
      return null;
    }
  }

  @override
  findFull() {
    print('Dados da Pagina buscada');
    return paginas;
  }
}
