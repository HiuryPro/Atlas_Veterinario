import '../DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

class IndicesP implements ProxyInteface {
  Map indices = {};

  buscadoBanco(int id) async {
    List resultados = await SupaDB.instance.select(
        'Parte',
        'Parte, Descricao, Unidade(IdParte, NumUnidade, NomeUnidade, Capitulo(*))',
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
        'Parte, Descricao, Unidade(IdParte, NumUnidade, NomeUnidade, Capitulo(*))',
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
  find(int id) async {
    print('Dados da imagem buscada');
    return indices[id];
  }

  @override
  findFull() async {
    print('Dados da imagem buscada');
    return indices;
  }
}
