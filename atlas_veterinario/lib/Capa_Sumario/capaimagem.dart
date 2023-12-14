import 'dart:convert';

import 'package:atlas_veterinario/Proxy/proxycapa.dart';
import 'package:flutter/material.dart';

class CapaImagem extends StatefulWidget {
  const CapaImagem({super.key});

  @override
  State<CapaImagem> createState() => _CapaImagemState();
}

class _CapaImagemState extends State<CapaImagem> {
  String? imagem;
  Image? imagemWiget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      var resultados = await ProxyCapa.instance.find(1, false);
      print(resultados);
      imagem = resultados['Capa'];
      print(imagem);
      imagemWiget = Image.memory(
        base64.decode(imagem!),
        fit: BoxFit.cover,
      );

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return imagemWiget == null ? const SizedBox() : imagemWiget!;
  }
}
