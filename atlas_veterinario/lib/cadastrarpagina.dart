// ignore_for_file: use_build_context_synchronously

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:atlas_veterinario/Utils/mensagens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase/supabase.dart';

import 'CadImagem/burcarsoimagem.dart';

class CadPagina extends StatefulWidget {
  const CadPagina({super.key});

  @override
  State<CadPagina> createState() => _CadPaginaState();
}

class _CadPaginaState extends State<CadPagina> {
  Mensagem mensagem = Mensagem();
  Map partes = {};
  List<String> itemsParte = ['Parte', 'Unidade', 'Capitulo', 'Imagem'];
  TextEditingController controllerPagina = TextEditingController();
  String? value;
  String? valueParte;
  String? valueUnidade;
  String? valueCapitulo;
  String? valueImagem;
  List<DropdownMenuItem<String>>? listaUnidades;
  int? parteAtual;
  int? unidadeAtual;
  int? capituloAtual;
  int? imagemAtual;
  BuscarImagem? imagem;

  List imagens = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      partes = await ProxyIndices().getInterface().findFull(false);
      print(partes.values.toList());
    });
    setState(() {});
  }

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(8), child: cadastrarPagina()));
  }

  reseta() {
    valueParte = null;
    valueUnidade = null;
    valueCapitulo = null;
    unidadeAtual = null;
    capituloAtual = null;
    parteAtual = null;
    imagemAtual = null;
    valueImagem = null;
    imagem = null;
  }

  Widget cadastrarPagina() {
    return ListView(
      shrinkWrap: true,
      children: [
        TextField(
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: controllerPagina,
          decoration: const InputDecoration(label: Text('Página')),
        ),
        const SizedBox(height: 10),
        DropdownButton(
            value: value,
            items: itemsParte.map((e) => buildMenuItem(e, null)).toList(),
            onChanged: (value) async {
              setState(() {
                this.value = value;
                reseta();
              });
              if (value == 'Imagem' && imagens.isEmpty) {
                imagens = await SupaDB.instance.clienteSupaBase
                    .from('Imagem')
                    .select('IdImagem, NomeImagem');
                print(imagens);
              }
              setState(() {});
            }),
        const SizedBox(height: 10),
        Builder(builder: (context) {
          if (value != 'Imagem' && value != null) {
            return DropdownButton(
                value: valueParte,
                items: partes.values
                    .toList()
                    .map(
                        (e) => buildMenuItem('PARTE ${'I' * e['Parte']}', null))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    valueParte = value;
                    parteAtual = 'I'.allMatches(valueParte!).length;
                    valueUnidade = null;
                    valueCapitulo = null;
                    unidadeAtual = null;
                    capituloAtual = null;
                  });
                });
          }

          return const SizedBox();
        }),
        const SizedBox(height: 10),
        Builder(builder: (context) {
          if (parteAtual != null && value == 'Unidade') {
            print('Teste');
            return DropdownButton(
                value: valueUnidade,
                items: partes[parteAtual]['Unidade']
                    .values
                    .toList()
                    .map<DropdownMenuItem<String>>((e) {
                  return buildMenuItem(
                      '${e['NumUnidade']}  ${e['NomeUnidade']}', null);
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    valueUnidade = value;
                    unidadeAtual = int.parse(value!.split(" ")[0]);
                    print(unidadeAtual);
                    valueCapitulo = null;
                    capituloAtual = null;
                  });
                });
          }

          if (value == 'Imagem' && imagens.isNotEmpty) {
            return DropdownButton(
                value: valueImagem,
                items: imagens.map<DropdownMenuItem<String>>((e) {
                  return buildMenuItem(
                      '${e['IdImagem']}  ${e['NomeImagem']}', null);
                }).toList(),
                onChanged: (value) async {
                  setState(() {
                    imagem = null;
                  });
                  await Future.delayed(const Duration(milliseconds: 1));
                  setState(() {
                    valueImagem = value;
                    imagemAtual = int.parse(valueImagem!.split(" ")[0]);
                    imagem = BuscarImagem(
                      id: imagemAtual!,
                    );
                  });
                });
          }

          return const SizedBox();
        }),
        Builder(builder: (context) {
          if (unidadeAtual != null && value == 'Capitulo') {
            return DropdownButton(
                value: valueCapitulo,
                items: partes[parteAtual]['Unidade'][unidadeAtual]['Capitulo']
                    .values
                    .toList()
                    .map<DropdownMenuItem<String>>((e) {
                  return buildMenuItem(
                      '${e['NumCapitulo']}  ${e['NomeCapitulo']}', null);
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    valueCapitulo = value;
                    capituloAtual = int.parse(value!.split(" ")[0]);
                    print(unidadeAtual);
                  });
                });
          }

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
                //SupaDB.instance.insert('Pagina_Partes', insert)

                if (controllerPagina.text != '') {
                  if (value != null) {
                    int pagina = int.parse(controllerPagina.text);
                    try {
                      await fazInsert(pagina);
                      mensagem.mensagem(context, 'Cadastro feito com sucesso',
                          'Página cadastrada com sucesso', null);
                    } on PostgrestException catch (e) {
                      print(e);
                      mensagemInsert(context, pagina);
                    }
                  }
                }
              },
              child: const Text('Cadastrar Página')),
        )
      ],
    );
  }

  fazInsert(int pagina) async {
    if (value == 'Parte' && parteAtual != null) {
      await SupaDB.instance.clienteSupaBase
          .from('Pagina')
          .insert({'IdPagina': pagina, 'Parte': parteAtual});
    } else if (value == 'Unidade' && unidadeAtual != null) {
      await SupaDB.instance.clienteSupaBase.from('Pagina').insert(
          {'IdPagina': pagina, 'Parte': parteAtual, 'Unidade': unidadeAtual});
    } else if (value == 'Capitulo' && capituloAtual != null) {
      await SupaDB.instance.clienteSupaBase.from('Pagina').insert({
        'IdPagina': pagina,
        'Parte': parteAtual,
        'Unidade': unidadeAtual,
        'Capitulo': capituloAtual
      });
    } else if (value == 'Imagem' && imagemAtual != null) {
      await SupaDB.instance.clienteSupaBase
          .from('Pagina')
          .insert({"IdPagina": pagina, 'IdImagem': imagemAtual});
    }
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

  Widget alert(BuildContext context, int pagina) {
    return AlertDialog(
      title: const Text('Pagina já existe'),
      content: Text(
          'Deseja inserir ela no lugar da página $pagina e mudar o número das posteriores?'),
      actions: [
        TextButton(
            onPressed: () async {
              int maxPagina =
                  await SupaDB.instance.clienteSupaBase.rpc('max_value_pagina');
              while (maxPagina >= pagina) {
                print(maxPagina);
                await SupaDB.instance.clienteSupaBase.from('Pagina').update(
                    {'IdPagina': maxPagina + 1}).match({'IdPagina': maxPagina});
                print(maxPagina + 1);
                maxPagina--;
              }
              await fazInsert(pagina);

              Navigator.of(context).pop();
            },
            child: Text('Inserir')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancelar"))
      ],
    );
  }

  Future<dynamic> mensagemInsert(BuildContext context, int pagina) async {
    return await showDialog(
      context: context,
      builder: (_) => alert(context, pagina),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cadastrar Página'),
        ),
        body: body());
  }
}
