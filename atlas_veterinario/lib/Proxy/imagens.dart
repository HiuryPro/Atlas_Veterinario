// ignore_for_file: prefer_initializing_formals, unnecessary_this

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyinteface.dart';

class Imagem implements ProxyInterface {
  // a key representa o IdImagem e o value o nome e o bytecode
  Map imagens = {};

  buscadoBanco(int id) async {
    List resultados = await SupaDB.instance.select(
        'Imagem',
        'IdImagem, Imagem ,NomeImagem, Width, Height, RotationImage,Imagem_Texto(*)',
        {'IdImagem': id},
        'IdImagem',
        true);

    imagens[resultados[0]['IdImagem']] = resultados[0];
    imagens[id]!.remove('IdImagem');

    for (Map texto in imagens[id]!['Imagem_Texto']) {
      texto.remove('IdImagem');
    }
  }

  buscadoBancoFull() async {
    List resultados = await SupaDB.instance.select(
        'Imagem',
        'IdImagem, Imagem ,NomeImagem, Width, Height,RotationImage,Imagem_Texto(*)',
        {},
        'IdImagem',
        true);

    for (Map resultado in resultados) {
      imagens[resultado['IdImagem']] = resultado;
      imagens[resultado['IdImagem']]!.remove('IdImagem');

      for (Map texto in imagens[resultado['IdImagem']]!['Imagem_Texto']) {
        texto.remove('IdImagem');
      }
    }
  }

  @override
  find(int id) async {
    print('Dados da imagem buscada');
    return imagens[id];
  }

  @override
  findFull() {
    print('Dados da imagem buscada');
    return imagens;
  }
}
