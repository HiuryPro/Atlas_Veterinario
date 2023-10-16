import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:atlas_veterinario/Proxy/proxypagina.dart';
import 'package:atlas_veterinario/Utils/app_controller.dart';

class SumarioP {
  static SumarioP instance = SumarioP();

  List<Map<String, dynamic>> sumarioLista = [];

  preencheSumario() async {
    Map partes = await ProxyIndices().getInterface().findFull(false);
    Map<int, Map>? resultados = await buscaTelaConteudo();
    print(resultados!.keys);
    print('Teset');
    for (int i = 5; i <= AppController.instance.totalPaginas; i++) {
      Map<String, dynamic> sumarioItem = {'pagina': i};
      if (!resultados[i]!.containsKey('IdImagem') &&
          resultados[i]!.isNotEmpty) {
        Map<String, dynamic> parte;
        Map<String, dynamic> unidade;
        Map<String, dynamic> capitulo;

        if (resultados[i]!['Capitulo'] != null) {
          parte = partes[resultados[i]!['Parte']];
          unidade = parte['Unidade'][resultados[i]!['Unidade']];
          capitulo = unidade['Capitulo'][resultados[i]!['Capitulo']];

          sumarioItem.addAll({'Tipo': 'Capitulo'});
          sumarioItem.addAll(capitulo);

          sumarioLista.add(sumarioItem);
        } else if (resultados[i]!['Unidade'] != null) {
          parte = partes[resultados[i]!['Parte']];
          unidade = parte['Unidade'][resultados[i]!['Unidade']];

          sumarioItem.addAll({'Tipo': 'Unidade'});
          sumarioItem.addAll(unidade);
          sumarioItem.remove('Capitulo');

          sumarioLista.add(sumarioItem);
        } else {
          parte = partes[resultados[i]!['Parte']];

          sumarioItem.addAll({'Tipo': 'Parte'});
          sumarioItem.addAll(parte);

          sumarioItem.remove('Unidade');
          sumarioLista.add(sumarioItem);
        }
      } else if (resultados[i]!.isEmpty) {
        sumarioItem.addAll({'Tipo': 'Vazio'});
        sumarioLista.add(sumarioItem);
      } else {
        int idImagem = resultados[i]!['IdImagem'];
        List imagens = await SupaDB.instance.select(
            'Imagem', 'NomeImagem', {'IdImagem': idImagem}, 'IdImagem', true);
        (imagens[0]);
        sumarioItem.addAll({'Tipo': 'Imagem'});
        sumarioItem.addAll(imagens[0]);
        sumarioLista.add(sumarioItem);
      }
    }
  }

  Future<Map<int, Map>?> buscaTelaConteudo() async {
    ProxyPagina instance = ProxyPagina().getInstance();
    instance.pagina.paginas.clear();
    Map<int, Map>? resultado = await instance.findFull(false);
    print(resultado);
    if (resultado != null) {
      resultado.forEach((key, value) {
        value.removeWhere((key, value) => value == null);
      });
    }

    return resultado;
  }

  findFull() async {
    if (sumarioLista.isEmpty) {
      await preencheSumario();
      return sumarioLista;
    }

    return sumarioLista;
  }
}
