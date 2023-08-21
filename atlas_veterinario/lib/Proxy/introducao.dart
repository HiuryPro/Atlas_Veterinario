// ignore_for_file: prefer_initializing_formals, unnecessary_this

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

class IntroducaoP implements ProxyInterface {
  // a key representa o IdImagem e o value o nome e o bytecode
  Map introducao = {};

  buscadoBanco(int id) async {
    List resultados = await SupaDB.instance.select('Introducao',
        'IdIntroducao, Introducao', {'IdIntroducao': id}, 'IdIntroducao', true);

    introducao[resultados[0]['IdImagem']] = resultados[0];
    introducao[id]!.remove('IdIntroducao');
  }

  buscadoBancoFull() async {
    List resultados = await SupaDB.instance.select(
        'Introducao', 'IdIntroducao, Introducao', {}, 'IdIntroducao', true);

    for (Map resultado in resultados) {
      introducao[resultado['IdIntroducao']] = resultado;
      introducao[resultado['IdIntroducao']]!.remove('IdIntroducao');
    }
  }

  @override
  find(int id) async {
    print('Dados da introducao buscada');
    return introducao[id];
  }

  @override
  findFull() {
    print('Dados da introducao buscada');
    return introducao;
  }
}
