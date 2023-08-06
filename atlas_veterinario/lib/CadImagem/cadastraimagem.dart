import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';

import '../DadosDB/supa.dart';

class CadastraImagem {
  Utils utils = Utils();

  cadastraImagem(Uint8List logoBase64, String nomeImagem, double width,
      double height) async {
    Map imagemDb = {'Imagem': '', 'NomeImagem': ''};
    String encodedString = base64.encode(logoBase64);
    imagemDb['Imagem'] = encodedString;
    imagemDb['NomeImagem'] = nomeImagem;
    imagemDb['Width'] = width;
    imagemDb['Height'] = height;

    return await SupaDB.instance.insert('Imagem', imagemDb);
  }

  cadastrarImagemTexto(int idImagem, String legenda, Color corDestaque,
      TextDrawable textD) async {
    Map imagemTextoDb = {};

    imagemTextoDb['IdImagem'] = idImagem;
    imagemTextoDb['Numero'] = textD.text;
    imagemTextoDb['FontSize'] = textD.style.fontSize!.toInt();
    imagemTextoDb['CorDestaque'] = corDestaque.value;
    imagemTextoDb['Zoom'] = textD.scale;
    imagemTextoDb['Dx'] = textD.position.dx;
    imagemTextoDb['Dy'] = textD.position.dy;
    imagemTextoDb['Rotation'] = textD.rotationAngle;
    imagemTextoDb['Legenda'] = legenda;

    return await SupaDB.instance.insert('Imagem_Texto', imagemTextoDb);
  }
}
