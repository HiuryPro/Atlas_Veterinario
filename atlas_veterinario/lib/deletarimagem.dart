// ignore_for_file: use_build_context_synchronously

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxypagina.dart';
import 'package:atlas_veterinario/Utils/mensagens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CadImagem/burcarsoimagem.dart';

class DeletarImagem extends StatefulWidget {
  const DeletarImagem({super.key});

  @override
  State<DeletarImagem> createState() => _DeletarImagemState();
}

class _DeletarImagemState extends State<DeletarImagem> {
  Mensagem mensagem = Mensagem();

  Map partes = {};
  String? value;
  String? valueImagem;
  int? imagemAtual;
  BuscarImagem? imagem;
  bool deletar = false;
  String? nomeImagem;

  List imagens = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      imagens = await SupaDB.instance.clienteSupaBase
          .from('Imagem')
          .select('IdImagem, NomeImagem');
      setState(() {});
    });
    setState(() {});
    print(imagens);
  }

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(8), child: cadastrarPagina()));
  }

  Widget cadastrarPagina() {
    return ListView(
      shrinkWrap: true,
      children: [
        Builder(builder: (context) {
          if (imagens.isNotEmpty) {
            return DropdownButton(
                isExpanded: true,
                hint: const Text('Clique para escolher qual Imagem'),
                value: valueImagem,
                items: imagens.map<DropdownMenuItem<String>>((e) {
                  return buildMenuItem(
                      '${e['IdImagem']}  ${e['NomeImagem']}', null);
                }).toList(),
                onChanged: (value) async {
                  setState(() {
                    imagem = null;
                  });
                  await Future.delayed(const Duration(milliseconds: 100));
                  setState(() {
                    valueImagem = value;
                    imagemAtual = int.parse(valueImagem!.split(" ")[0]);
                    nomeImagem = valueImagem!.split(" ")[1];
                    imagem = BuscarImagem(
                      id: imagemAtual!,
                    );
                  });
                });
          }

          return const SizedBox();
        }),
        Builder(builder: (context) {
          if (imagem != null) {
            return BuscarImagem(id: imagemAtual!);
          }

          return const SizedBox();
        }),
        const SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              onPressed: () async {
                if (imagemAtual != null) {
                  await mensagemDelete(context, nomeImagem!);
                  if (deletar) {
                    await fazDelete(imagemAtual!);
                  }
                  setState(() {
                    deletar = false;
                    imagemAtual = null;
                    imagem = null;
                    valueImagem = null;
                  });

                  imagens = await SupaDB.instance.clienteSupaBase
                      .from('Imagem')
                      .select('IdImagem, NomeImagem');

                  ProxyPagina.instance.findFull(true);

                  setState(() {});
                }
              },
              child: const Text('Deletar Imagem')),
        )
      ],
    );
  }

  fazDelete(int imagem) async {
    await SupaDB.instance.clienteSupaBase
        .from('Pagina')
        .delete()
        .match({'IdPagina': imagem});

    await SupaDB.instance.clienteSupaBase
        .from('Imagem')
        .delete()
        .match({'IdImagem': imagem});
  }

  DropdownMenuItem<String> buildMenuItem(String item, var map) =>
      DropdownMenuItem(
          value: item,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text((map == null) ? item : '$item $map',
                style: const TextStyle(
                  fontSize: 20,
                )),
          ));

  Widget alert(BuildContext context, String nomeImagem) {
    return AlertDialog(
      title: Text('Deletar a imagem $nomeImagem?'),
      content: const Text('Deseja deletar está imagem?'),
      actions: [
        TextButton(
            onPressed: () async {
              setState(() {
                deletar = true;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Deletar')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancelar"))
      ],
    );
  }

  Future<dynamic> mensagemDelete(
      BuildContext context, String nomeImagem) async {
    return await showDialog(
      context: context,
      builder: (_) => alert(context, nomeImagem),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Deletar Imagem'),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/home');
              },
              icon: const Icon(Icons.arrow_back)),
          shadowColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff1a4683),
                  Color(0xff3574cc),
                  Colors.white,
                  Colors.white
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: body());
  }
}
