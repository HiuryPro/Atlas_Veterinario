// ignore_for_file: use_build_context_synchronously

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxyindices.dart';
import 'package:atlas_veterinario/Utils/mensagens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadPagina extends StatefulWidget {
  const CadPagina({super.key});

  @override
  State<CadPagina> createState() => _CadPaginaState();
}

class _CadPaginaState extends State<CadPagina> {
  Mensagem mensagem = Mensagem();
  Map partes = {};
  List<String> itemsParte = ['Parte', 'Unidade', 'Capitulo'];
  TextEditingController controllerPagina = TextEditingController();
  String? value;
  String? valueParte;
  String? valueUnidade;
  String? valueCapitulo;
  List<DropdownMenuItem<String>>? listaUnidades;
  int? parteAtual;
  int? unidadeAtual;
  int? capAtual;

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
        padding: const EdgeInsets.all(8),
        child: TabBarView(
            children: [paginaImagem(), paginaParte(), paginaCadImagem()]),
      ),
    );
  }

  paginaImagem() {
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
            onChanged: (value) {
              setState(() {
                this.value = value;
              });
            }),
        const SizedBox(height: 10),
        Builder(builder: (context) {
          if (value != null) {
            return DropdownButton(
                value: valueParte,
                items: partes.values
                    .toList()
                    .map(
                        (e) => buildMenuItem('PARTE ${'I' * e['Parte']}', null))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    valueUnidade = value;
                    parteAtual = 'I'.allMatches(valueParte!).length;
                  });
                });
          }

          return const Text('Foda');
        }),
        const SizedBox(height: 10),
        Builder(builder: (context) {
          if (parteAtual != null) {
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
                    valueParte = value;
                    parteAtual = 'I'.allMatches(valueParte!).length;
                  });
                });
          }

          return const Text('Foda');
        }),
        Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton(
              onPressed: () async {
                //SupaDB.instance.insert('Pagina_Partes', insert)

                if (controllerPagina.text != '') {
                  if (valueParte != null) {
                    int pagina = int.parse(controllerPagina.text);
                    try {
                      await SupaDB.instance
                          .insert('Pagina', {'IdPagina': pagina});

                      if (value == 'Parte') {
                        cadPaginaParte(parteAtual!, pagina);
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

  paginaParte() {
    return const SizedBox();
  }

  paginaCadImagem() {
    return const SizedBox();
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Cadastrar Sumário'),
              bottom: const TabBar(tabs: [
                Text(
                  'Cadastrar Parte',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Cadastrar Unidade',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Cadastrar Capítulo',
                  style: TextStyle(fontSize: 15),
                )
              ]),
            ),
            body: body()));
  }
}
