// ignore_for_file: use_build_context_synchronously

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:atlas_veterinario/Utils/mensagens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  List imagens = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      partes = await ProxyIndices().getInterface().findFull();
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
          if (parteAtual != null) {
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
                onChanged: (value) {
                  setState(() {
                    valueImagem = value;
                    imagemAtual = null;
                  });
                });
          }

          return const SizedBox();
        }),
        Builder(builder: (context) {
          if (unidadeAtual != null) {
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

          if (imagemAtual == null && valueImagem != null) {
            imagemAtual = int.parse(valueImagem!.split(" ")[0]);
            return BuscarImagem(
              id: imagemAtual!,
            );
          }

          return const SizedBox();
        }),
        SizedBox(
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
                      await SupaDB.instance
                          .insert('Pagina', {'IdPagina': pagina});

                      if (value == 'Parte' && parteAtual != null) {
                        cadPaginaParte(parteAtual!, pagina);
                      }
                      if (value == 'Unidade' && unidadeAtual != null) {
                        cadPaginaUnidade(parteAtual!, unidadeAtual!, pagina);
                      }
                      if (value == 'Capitulo' && capituloAtual != null) {
                        cadPaginaCapitulo(
                            parteAtual!, unidadeAtual!, capituloAtual!, pagina);
                      }
                    } catch (e) {
                      print(e);
                      mensagem.mensagem(
                          context,
                          'Erro ao cadastrar pagina $pagina',
                          'Essa página já está cadastrada',
                          null);
                    }
                  }
                }
              },
              child: const Text('Cadastrar Página')),
        )
      ],
    );
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

  cadPaginaParte(int parteAtual, int pagina) async {
    await SupaDB.instance
        .insert('Pagina_Partes', {'IdPagina': pagina, 'IdParte': parteAtual});
    mensagem.mensagem(context, 'Cadastro feito com sucesso',
        'Página cadastrada com sucesso', null);
  }

  cadPaginaUnidade(int parteAtual, int unidadeAtual, int pagina) async {
    await SupaDB.instance.insert('Pagina_Partes',
        {'IdPagina': pagina, 'IdParte': parteAtual, 'IdUnidade': unidadeAtual});
    mensagem.mensagem(context, 'Cadastro feito com sucesso',
        'Página cadastrada com sucesso', null);
  }

  cadPaginaCapitulo(
      int parteAtual, int unidadeAtual, int capituloAtual, int pagina) async {
    await SupaDB.instance.insert('Pagina_Partes', {
      'IdPagina': pagina,
      'IdParte': parteAtual,
      'IdUnidade': unidadeAtual,
      'IdCapitulo': capituloAtual
    });
    mensagem.mensagem(context, 'Cadastro feito com sucesso',
        'Página cadastrada com sucesso', null);
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
