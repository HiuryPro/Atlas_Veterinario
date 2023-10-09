import 'package:atlas_veterinario/Proxy/proxyinteface2.dart';

import '../DadosDB/supa.dart';

class IndicesP2 implements ProxyInterface2 {
  Map indices = {};

  buscadoBanco(int id) async {
    List resultados = await SupaDB.instance.select(
        'Parte',
        'Parte, Descricao, Unidade(Parte, NumUnidade, NomeUnidade, Capitulo(*))',
        {'Parte': id},
        'Parte',
        true);

    indices[resultados[0]['Parte']] = resultados[0];

    Map teste = {};
    Map teste2 = {};

    for (Map unidade in indices[id]['Unidade']) {
      teste.addAll({unidade['NumUnidade']: unidade});
      for (Map capitulo in unidade['Capitulo']) {
        teste2.addAll({capitulo['NumCapitulo']: capitulo});
      }
      teste[unidade['NumUnidade']]
          .update('Capitulo', (value) => Map.from(teste2));
      teste2.clear();
    }

    indices[id]['Unidade'] = Map.from(teste);

    print(teste);
  }

  buscadoBancoFull() async {
    List resultados = await SupaDB.instance.select(
        'Parte',
        'Parte, Descricao, Unidade(Parte, NumUnidade, NomeUnidade, Capitulo(*))',
        {},
        'Parte',
        true);

    for (Map resultado in resultados) {
      Map teste = {};
      Map teste2 = {};
      int id = resultado['Parte'];
      indices[id] = resultado;

      for (Map unidade in indices[id]['Unidade']) {
        teste.addAll({unidade['NumUnidade']: unidade});
        for (Map capitulo in unidade['Capitulo']) {
          teste2.addAll({capitulo['NumCapitulo']: capitulo});
        }
        teste[unidade['NumUnidade']]
            .update('Capitulo', (value) => Map.from(teste2));
        teste2.clear();
      }

      indices[id]['Unidade'] = Map.from(teste);
    }
  }

  @override
  Future<Map> find(int id, bool atualizar) async {
    print('Dados da imagem buscada');
    return indices[id];
  }

  @override
  Future<Map> findFull(bool atualizar) async {
    print('Dados da imagem buscada');
    return indices;
  }
}
