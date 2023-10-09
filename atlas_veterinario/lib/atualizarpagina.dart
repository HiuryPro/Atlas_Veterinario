// ignore_for_file: use_build_context_synchronously

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyimagens.dart';
import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:atlas_veterinario/Proxy/proxypagina.dart';
import 'package:atlas_veterinario/Utils/mensagens.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

import 'CadImagem/burcarsoimagem.dart';

class AtualizaPagina extends StatefulWidget {
  const AtualizaPagina({super.key});

  @override
  State<AtualizaPagina> createState() => _AtualizaPaginaState();
}

class _AtualizaPaginaState extends State<AtualizaPagina> {
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
  bool atualizar = false;

  List imagens = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      partes = await ProxyIndices().getInterface().findFull(false);
      paginas = await ProxyPagina().getInstance().findFull(false);

      setState(() {});

      print(partes.values.toList());
      print(paginas);
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
                onChanged: (value) async {
                  reseta();
                  int idParte;
                  int idUnidade;
                  int idCapitulo;

                  setState(() {
                    paginaAtual = value;
                  });
                  Map conteudos;
                  Map unidadeMap;
                  Map capituloMap;
                  Map paginaEscolhida = paginas![int.parse(paginaAtual!)];

                  if (paginaEscolhida['Capitulo'] != null) {
                    idParte = paginaEscolhida['Parte'];
                    idUnidade = paginaEscolhida['Unidade'];
                    idCapitulo = paginaEscolhida['Capitulo'];

                    conteudos = await ProxyIndices()
                        .getInterface()
                        .find(idParte, false);
                    unidadeMap = conteudos['Unidade'][idUnidade];
                    capituloMap = unidadeMap['Capitulo'][idCapitulo];

                    setState(() {
                      this.value = 'Capitulo';

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
                    conteudos = await ProxyIndices()
                        .getInterface()
                        .find(idParte, false);
                    unidadeMap = conteudos['Unidade'][idUnidade];

                    setState(() {
                      this.value = 'Unidade';
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
                  } else if (paginaEscolhida['IdImagem'] != null) {
                    conteudos = await ProxyImagens()
                        .getInterface()
                        .find(paginaEscolhida['IdImagem'], false);
                    print(conteudos);
                    setState(() {
                      this.value = 'Imagem';
                      valueImagem =
                          '${paginaEscolhida['IdImagem']}  ${conteudos['NomeImagem']}';
                      imagemAtual = paginaEscolhida['IdImagem'];
                    });
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
                  }
                });
          }
          return const SizedBox();
        }),
        const SizedBox(height: 10),
        Builder(builder: (context) {
          if (paginaAtual != null) {
            return DropdownButton(
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
                });
          }
          return const SizedBox();
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
          if (parteAtual != null &&
              (value == 'Unidade' || value == 'Capitulo')) {
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

                if (paginaAtual != null) {
                  if (value != null) {
                    await mensagemUpdate(context, int.parse(paginaAtual!));
                    print(atualizar);
                    if (atualizar) {
                      try {
                        await fazUpdate(int.parse(paginaAtual!));
                        mensagem.mensagem(
                            context,
                            'Atualizaçao feita com sucesso',
                            'Página atualizada com sucesso',
                            null);
                      } on PostgrestException catch (e) {
                        print(e);
                      }
                    }
                    setState(() {
                      atualizar = false;
                    });
                    paginas = await ProxyPagina().getInstance().findFull(true);

                    setState(() {});
                  }
                }
              },
              child: const Text('Atualizar Página')),
        )
      ],
    );
  }

  fazUpdate(int pagina) async {
    if (value == 'Parte' && parteAtual != null) {
      await SupaDB.instance.clienteSupaBase.from('Pagina').update({
        'Parte': parteAtual,
        'Unidade': null,
        'Capitulo': null,
        'IdImagem': null
      }).match({'IdPagina': pagina});
    } else if (value == 'Unidade' && unidadeAtual != null) {
      await SupaDB.instance.clienteSupaBase.from('Pagina').update({
        'Parte': parteAtual,
        'Unidade': unidadeAtual,
        'Capitulo': null,
        'IdImagem': null,
      }).match({'IdPagina': pagina});
    } else if (value == 'Capitulo' && capituloAtual != null) {
      await SupaDB.instance.clienteSupaBase.from('Pagina').update({
        'Parte': parteAtual,
        'Unidade': unidadeAtual,
        'Capitulo': capituloAtual,
        'IdImagem': null
      }).match({'IdPagina': pagina});
    } else if (value == 'Imagem' && imagemAtual != null) {
      await SupaDB.instance.clienteSupaBase.from('Pagina').update({
        'Parte': null,
        'Unidade': null,
        'Capitulo': null,
        'IdImagem': imagemAtual
      }).match({'IdPagina': pagina});
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
      title: Text('Atualizar a página $pagina?'),
      content: const Text('Deseja atualizar está página?'),
      actions: [
        TextButton(
            onPressed: () async {
              setState(() {
                atualizar = true;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Atualizar')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancelar"))
      ],
    );
  }

  Future<dynamic> mensagemUpdate(BuildContext context, int pagina) async {
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
          title: const Text('Atualzar Página'),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/home');
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: body());
  }
}
