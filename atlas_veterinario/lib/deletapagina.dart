// ignore_for_file: use_build_context_synchronously

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyimagens.dart';
import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:atlas_veterinario/Proxy/proxypagina.dart';
import 'package:atlas_veterinario/Utils/mensagens.dart';
import 'package:flutter/material.dart';

import 'CadImagem/burcarsoimagem.dart';

class DeletarPagina extends StatefulWidget {
  const DeletarPagina({super.key});

  @override
  State<DeletarPagina> createState() => _DeletarPaginaState();
}

class _DeletarPaginaState extends State<DeletarPagina> {
  Mensagem mensagem = Mensagem();
  Map partes = {};
  Map? paginas;
  Future<dynamic>? teste;
  List<String> itemsParte = ['Parte', 'Unidade', 'Capitulo', 'Imagem'];
  TextEditingController controllerPagina = TextEditingController();
  String? value;
  String? paginaAtual;
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
  bool deletar = false;

  List imagens = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      partes = await ProxyIndices.instance.findFull(false);
      paginas = await ProxyPagina.instance.findFull(true);

      setState(() {});
    });
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
        Builder(builder: (context) {
          if (paginas != null) {
            return DropdownButton(
                value: paginaAtual,
                items: paginas!.keys
                    .map((e) => buildMenuItem(e.toString(), null))
                    .toList(),
                onChanged: (item) async {
                  reseta();
                  int idParte;
                  int idUnidade;
                  int idCapitulo;

                  setState(() {
                    paginaAtual = item;
                  });
                  Map conteudos;
                  Map unidadeMap;
                  Map capituloMap;
                  Map paginaEscolhida = paginas![int.parse(paginaAtual!)];

                  print(paginaEscolhida);

                  if (paginaEscolhida['IdImagem'] != null) {
                    print('Entrou');
                    conteudos = await ProxyImagens.instance
                        .find(paginaEscolhida['IdImagem'], false);
                    print(conteudos);
                    setState(() {
                      value = 'Imagem';
                      print(value);
                      valueImagem =
                          '${paginaEscolhida['IdImagem']}  ${conteudos['NomeImagem']}';
                      imagemAtual = paginaEscolhida['IdImagem'];
                    });
                    print(value);
                    imagens = await SupaDB.instance.clienteSupaBase
                        .from('Imagem')
                        .select('IdImagem, NomeImagem');
                    setState(() {
                      imagem = null;
                    });
                    await Future.delayed(const Duration(milliseconds: 1));
                    setState(() {
                      imagem = BuscarImagem(
                        id: paginaEscolhida['IdImagem'],
                      );
                    });

                    setState(() {});
                  } else if (paginaEscolhida['Capitulo'] != null) {
                    idParte = paginaEscolhida['Parte'];
                    idUnidade = paginaEscolhida['Unidade'];
                    idCapitulo = paginaEscolhida['Capitulo'];

                    conteudos =
                        await ProxyIndices.instance.find(idParte, false);
                    unidadeMap = conteudos['Unidade'][idUnidade];
                    capituloMap = unidadeMap['Capitulo'][idCapitulo];

                    setState(() {
                      value = 'Capitulo';

                      valueParte = 'PARTE ${'I' * idParte}';
                      parteAtual = idParte;

                      valueUnidade =
                          '${unidadeMap['NumUnidade']}  ${unidadeMap['NomeUnidade']}';
                      unidadeAtual = unidadeMap['NumUnidade'];

                      valueCapitulo =
                          '${capituloMap['NumCapitulo']}  ${capituloMap['NomeCapitulo']}';
                      capituloAtual = capituloMap['NumCapitulo'];
                    });
                  } else if (paginaEscolhida['Unidade'] != null) {
                    idParte = paginaEscolhida['Parte'];
                    idUnidade = paginaEscolhida['Unidade'];
                    conteudos =
                        await ProxyIndices.instance.find(idParte, false);
                    unidadeMap = conteudos['Unidade'][idUnidade];

                    setState(() {
                      value = 'Unidade';
                      print(value);
                      valueParte = 'PARTE ${'I' * idParte}';
                      parteAtual = idParte;

                      valueUnidade =
                          '${unidadeMap['NumUnidade']}  ${unidadeMap['NomeUnidade']}';
                      unidadeAtual = unidadeMap['NumUnidade'];
                    });
                  } else if (paginaEscolhida['Parte'] != null) {
                    idParte = paginaEscolhida['Parte'];
                    setState(() {
                      this.value = 'Parte';

                      valueParte = 'PARTE ${'I' * idParte}';
                      parteAtual = idParte;
                    });
                  }
                });
          }
          return const SizedBox();
        }),
        const SizedBox(height: 10),
        Builder(builder: (context) {
          if (paginaAtual != null) {
            return Text(
                style: TextStyle(fontSize: 20), value == null ? '' : value!);
          }
          return const SizedBox();
        }),
        const SizedBox(height: 10),
        Builder(builder: (context) {
          if (value != 'Imagem' && value != null) {
            return Text(
                style: TextStyle(fontSize: 20),
                valueParte == null ? '' : valueParte!);
          }

          return const SizedBox();
        }),
        const SizedBox(height: 10),
        Builder(builder: (context) {
          if (parteAtual != null &&
              (value == 'Unidade' || value == 'Capitulo')) {
            print('Teste');
            return Text(
                style: TextStyle(fontSize: 20),
                valueUnidade == null ? '' : valueUnidade!);
          }

          if (value == 'Imagem' && imagens.isNotEmpty) {
            return Text(
                style: TextStyle(fontSize: 20),
                valueImagem == null ? '' : valueImagem!);
          }

          return const SizedBox();
        }),
        Builder(builder: (context) {
          if (unidadeAtual != null && value == 'Capitulo') {
            return Text(
                style: TextStyle(fontSize: 20),
                valueCapitulo == null ? '' : valueCapitulo!);
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
                if (paginaAtual != null) {
                  int pagina = int.parse(paginaAtual!);
                  await mensagemDelete(context, pagina);
                  if (deletar) {
                    await fazDelete(pagina);

                    int maxPagina = await SupaDB.instance.clienteSupaBase
                        .rpc('max_value_pagina');
                    while (maxPagina >= pagina) {
                      await SupaDB.instance.clienteSupaBase
                          .from('Pagina')
                          .update({'IdPagina': pagina}).match(
                              {'IdPagina': pagina + 1});
                      pagina += 1;
                    }
                  }
                  setState(() {
                    deletar = false;
                    paginaAtual = null;
                  });
                  reseta();
                  paginas = await ProxyPagina.instance.findFull(true);

                  setState(() {});
                }
              },
              child: const Text('Deletar Página')),
        )
      ],
    );
  }

  fazDelete(int pagina) async {
    await SupaDB.instance.clienteSupaBase
        .from('Pagina')
        .delete()
        .match({'IdPagina': pagina});
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
      title: Text('Deletar a página $pagina?'),
      content: const Text('Deseja deletar está página?'),
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

  Future<dynamic> mensagemDelete(BuildContext context, int pagina) async {
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
          title: const Text('Atualizar de Pagina'),
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
                  Color(0xff1a4d34),
                  Color(0xff386e41),
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
