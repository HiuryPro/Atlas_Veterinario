import 'dart:convert';
import 'dart:typed_data';

import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';

import '../DadosDB/supa.dart';

class CadastraImagem {
  Utils utils = Utils();

  cadastraImagem(Uint8List logoBase64, String nomeImagem) async {
    Map imagemDb = {'Imagem': '', 'NomeImagem': ''};
    String encodedString = base64.encode(logoBase64);
    imagemDb['Imagem'] = encodedString;
    imagemDb['NomeImagem'] = nomeImagem;

    return await SupaDB.instance.insert('Imagem', imagemDb);
  }

  cadastrarImagemTexto(int idImagem, TextDrawable textD) async {
    Map imagemTextoDb = {};

    imagemTextoDb['IdImagem'] = idImagem;
    imagemTextoDb['Texto'] = textD.text;
    imagemTextoDb['FontSize'] = textD.style.fontSize!.toInt();
    imagemTextoDb['Cor'] = textD.style.color!.value;
    imagemTextoDb['Zoom'] = textD.scale;
    imagemTextoDb['Dx'] = textD.position.dx;
    imagemTextoDb['Dy'] = textD.position.dy;
    imagemTextoDb['Rotation'] = textD.rotationAngle;

    return await SupaDB.instance.insert('Imagem_Texto', imagemTextoDb);
  }

  cadastrarImagemSeta(int idImagem, ArrowDrawable textA) async {
    Map imagemSetaDb = {};

    imagemSetaDb['IdImagem'] = idImagem;
    imagemSetaDb['Cor'] = textA.paint.color.value;
    imagemSetaDb['Zoom'] = textA.scale;
    imagemSetaDb['Largura'] = textA.length;
    imagemSetaDb['Traco'] = textA.paint.strokeWidth;
    imagemSetaDb['Dx'] = textA.position.dx;
    imagemSetaDb['Dy'] = textA.position.dy;
    imagemSetaDb['Rotacao'] = textA.rotationAngle;

    return await SupaDB.instance.insert('Imagem_Seta', imagemSetaDb);
  }

  cadastrarImagemContorno(int idImagem, FreeStyleDrawable textC) async {
    Map imagemSetaDb = {};

    imagemSetaDb['IdImagem'] = idImagem;
    imagemSetaDb['Cor'] = textC.color.value;
    imagemSetaDb['Traco'] = textC.strokeWidth;
    imagemSetaDb['Path'] =
        utils.parseOffsetToListListDouble(textC.path).toString();

    return await SupaDB.instance.insert('Imagem_Contorno', imagemSetaDb);
  }
}
