import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:atlas_veterinario/Proxy/proxypagina.dart';
import 'package:atlas_veterinario/Utils/app_controller.dart';

class SumarioP {
  static SumarioP instance = SumarioP();

  List<Map<String, dynamic>> sumarioLista = [];

  preencheSumario() async {
    Map partes = await ProxyIndices.instance.findFull(false);
    Map<dynamic, dynamic>? resultados = await buscaTelaConteudo();
    print(resultados);
    print(resultados!.keys);
    print('Teset');
    for (int i = 5; i <= AppController.instance.totalPaginas; i++) {
      print(i);
      Map<String, dynamic> sumarioItem = {'pagina': i};

      if (resultados.containsKey(i)) {
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
          } else if (resultados[i]!['Parte'] != null) {
            parte = partes[resultados[i]!['Parte']];

            sumarioItem.addAll({'Tipo': 'Parte'});
            sumarioItem.addAll(parte);

            sumarioItem.remove('Unidade');
            sumarioLista.add(sumarioItem);
          }
        } else {
          int idImagem = resultados[i]!['IdImagem'];
          List imagens = await SupaDB.instance.select(
              'Imagem', 'NomeImagem', {'IdImagem': idImagem}, 'IdImagem', true);
          (imagens[0]);
          sumarioItem.addAll({'Tipo': 'Imagem'});
          sumarioItem.addAll(imagens[0]);
          sumarioLista.add(sumarioItem);
        }
      } else {
        sumarioItem.addAll({'Tipo': 'Vazio'});
        sumarioLista.add(sumarioItem);
      }
    }
  }

  Future<Map<dynamic, dynamic>?> buscaTelaConteudo() async {
    ProxyPagina instance = ProxyPagina.instance;
    instance.pagina.paginas.clear();
    Map<dynamic, dynamic>? resultado = await instance.findFull(false);

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
