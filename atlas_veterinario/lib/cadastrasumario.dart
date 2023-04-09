// ignore_for_file: use_build_context_synchronously

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'Auxiliadores/mensagens.dart';

class CadastraSumario extends StatefulWidget {
  const CadastraSumario({super.key});

  @override
  State<CadastraSumario> createState() => _CadastraSumarioState();
}

class _CadastraSumarioState extends State<CadastraSumario> {
  TextEditingController parteController = TextEditingController();
  TextEditingController descricaoParteController = TextEditingController();
  TextEditingController numUnidadeController = TextEditingController();
  TextEditingController nomeUnidadeController = TextEditingController();
  TextEditingController numCapituloController = TextEditingController();
  TextEditingController nomeCapituloController = TextEditingController();
  Mensagem mensagem = Mensagem();

  Map<String, List<String>> mapPartes = {'IdParte': [], 'Parte': []};
  Map<String, List<String>> mapUnidades = {
    'IdUnidade': [],
    'NumUnidade': [],
    'NomeUnidade': []
  };
  String? parteUnidade;
  String? parteCapitulo;
  String? unidadeCapitulo;

  Future<void> partesSelect() async {
    List<String> idParte = [];
    List<String> parteNum = [];
    var dados = await SupaDB.instance.clienteSupaBase
        .from('Parte')
        .select('IdParte, Parte');
    print(dados);
    for (var parte in dados) {
      idParte.add(parte['IdParte'].toString());
      parteNum.add(parte['Parte'].toString());
    }
    setState(() {
      mapPartes.addAll({'IdParte': idParte, 'Parte': parteNum});
    });
  }

  Future<void> unidadesSelect(int parte) async {
    List<String> idUnidade = [];
    List<String> unidadeNum = [];
    List<String> unidadeNome = [];
    var dados = await SupaDB.instance.clienteSupaBase
        .from('Unidade')
        .select('IdUnidade, NumUnidade, NomeUnidade')
        .match({'IdParte': parte});
    print(dados);
    for (var parte in dados) {
      idUnidade.add(parte['IdUnidade'].toString());
      unidadeNum.add(parte['NumUnidade'].toString());
      unidadeNome.add(parte['NomeUnidade'].toString());
    }
    setState(() {
      mapUnidades.addAll({
        'IdUnidade': idUnidade,
        'NumUnidade': unidadeNum,
        'NomeUnidade': unidadeNome
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await partesSelect();
    });
  }

  Widget parteWidget() {
    return Center(
        child: ListView(
      shrinkWrap: true,
      children: [
        TextField(
          controller: parteController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Parte',
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
            controller: descricaoParteController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Descrição',
            )),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(
            onPressed: () async {
              List resultado = await SupaDB.instance.clienteSupaBase
                  .from('Parte')
                  .select('*')
                  .match({"Parte": int.parse(parteController.text)});
              if (resultado.isEmpty) {
                await SupaDB.instance.clienteSupaBase.from("Parte").insert({
                  "Parte": int.parse(parteController.text),
                  "Descricao": descricaoParteController.text
                });
                await partesSelect();
                await mensagem.mensagem(context, 'Cadastro feito com sucesso',
                    'A parte foi cadastrada com sucesso', null);
              } else {
                print('Essa parte já existe');
                await mensagem.mensagem(context, 'Falha ao Cadastrar',
                    'Essa parte já está cadastrada', null);
              }
            },
            child: const Text('Cadastrar Parte'))
      ],
    ));
  }

  Widget unidadeWidget() {
    return Center(
        child: ListView(
      shrinkWrap: true,
      children: [
        DecoratedBox(
          decoration: const ShapeDecoration(
            color: Colors.cyan,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1.0, style: BorderStyle.solid, color: Colors.cyan),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: Center(
              child: DropdownButton(
                  alignment: Alignment.center,
                  hint: const Text('Escolha a Parte'),
                  value: parteUnidade,
                  items: mapPartes['Parte']!
                      .toList()
                      .map((String valor) => buildMenuItem(valor, null))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      parteUnidade = value;
                    });
                  }),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          controller: numUnidadeController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Numero Unidade',
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
            controller: nomeUnidadeController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome Unidade',
            )),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(
            onPressed: () async {
              int index = mapPartes['Parte']!.indexOf(parteUnidade.toString());
              int idParte = int.parse(mapPartes['IdParte']![index]);

              List resultado = await SupaDB.instance.clienteSupaBase
                  .from('Unidade')
                  .select("*")
                  .match({
                'IdParte': idParte,
                'NumUnidade': int.parse(numUnidadeController.text)
              });
              if (resultado.isEmpty) {
                print(mapPartes['IdParte']![index]);
                await SupaDB.instance.clienteSupaBase.from('Unidade').insert({
                  'IdParte': idParte,
                  "NumUnidade": int.parse(numUnidadeController.text),
                  'NomeUnidade': nomeUnidadeController.text
                });
                await mensagem.mensagem(context, 'Cadastro feito com sucesso',
                    'A unidade foi cadastrada com sucesso', null);
              } else {
                print('Já existe');
                await mensagem.mensagem(context, 'Falha ao Cadastrar',
                    'Essa unidade já está cadastrada nesta parte', null);
              }
            },
            child: const Text('Cadastrar Unidade'))
      ],
    ));
  }

  Widget capituloWidget() {
    return Center(
        child: ListView(
      shrinkWrap: true,
      children: [
        DecoratedBox(
          decoration: const ShapeDecoration(
            color: Colors.cyan,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1.0, style: BorderStyle.solid, color: Colors.cyan),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: Center(
              child: DropdownButton(
                  alignment: Alignment.center,
                  hint: const Text('Escolha a Parte'),
                  value: parteCapitulo,
                  items: mapPartes['Parte']!
                      .map((String valor) => buildMenuItem(valor, null))
                      .toList(),
                  onChanged: (value) async {
                    print(mapPartes);
                    int index = mapPartes['Parte']!.indexOf(value!);
                    int idParte = int.parse(mapPartes['IdParte']![index]);
                    print(idParte);
                    setState(() {
                      unidadeCapitulo = null;
                      parteCapitulo = value;
                      mapUnidades.updateAll((key, value) => value = []);
                    });

                    await unidadesSelect(idParte);
                  }),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        DecoratedBox(
          decoration: const ShapeDecoration(
            color: Colors.cyan,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 1.0, style: BorderStyle.solid, color: Colors.cyan),
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: Center(
              child: DropdownButton(
                  alignment: Alignment.center,
                  hint: const Text('Escolha a Parte'),
                  value: unidadeCapitulo,
                  items: mapUnidades['NumUnidade']!
                      .toList()
                      .map((String valor) => buildMenuItem(
                          valor,
                          mapUnidades['NomeUnidade']![
                              mapUnidades['NumUnidade']!.indexOf(valor)]))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      unidadeCapitulo = value;
                    });
                  }),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          controller: numCapituloController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Numero Capítulo',
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
            controller: nomeCapituloController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome Capítulo',
            )),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(
            onPressed: () async {
              int index = mapUnidades['NumUnidade']!
                  .indexOf(unidadeCapitulo.toString().split(' ')[0]);
              int idUnidade = int.parse(mapUnidades['IdUnidade']![index]);
              print(idUnidade);
              List resultado = await SupaDB.instance.clienteSupaBase
                  .from('Capitulo')
                  .select("*")
                  .match({
                'IdUnidade': idUnidade,
                'NumCapitulo': int.parse(numCapituloController.text)
              });
              print(resultado);
              if (resultado.isEmpty) {
                await SupaDB.instance.clienteSupaBase.from('Capitulo').insert({
                  'IdUnidade': idUnidade,
                  "NumCapitulo": int.parse(numCapituloController.text),
                  'NomeCapitulo': nomeCapituloController.text
                });
                await mensagem.mensagem(context, 'Cadastro feito com sucesso',
                    'O capítulo foi cadastrada com sucesso', null);
              } else {
                print('Já existe');
                await mensagem.mensagem(context, 'Falha ao Cadastrar',
                    'Esse capítulo já está cadastrada nesta unidade', null);
              }
            },
            child: const Text('Cadastrar Capítulo'))
      ],
    ));
  }

  Widget body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: TabBarView(
            children: [parteWidget(), unidadeWidget(), capituloWidget()]),
      ),
    );
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
}
