// ignore_for_file: use_build_context_synchronously

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:flutter/material.dart';

import 'Utils/mensagens.dart';

class AtualizaSumario extends StatefulWidget {
  const AtualizaSumario({super.key});

  @override
  State<AtualizaSumario> createState() => _AtualizaSumarioState();
}

class _AtualizaSumarioState extends State<AtualizaSumario> {
  TextEditingController parteController = TextEditingController();
  TextEditingController descricaoParteController = TextEditingController();
  TextEditingController numUnidadeController = TextEditingController();
  TextEditingController nomeUnidadeController = TextEditingController();
  TextEditingController numCapituloController = TextEditingController();
  TextEditingController nomeCapituloController = TextEditingController();
  Mensagem mensagem = Mensagem();

  Map<String, List<String>> mapPartes = {'Parte': []};
  Map<String, List<String>> mapUnidades = {
    'IdUnidade': [],
    'NumUnidade': [],
    'NomeUnidade': []
  };

  Map<String, List<String>> mapCapitulos = {
    'IdCapitulo': [],
    'NumCapitulo': [],
    'NomeCapitulo': []
  };

  String? parteUnidade;
  String? unidade;
  String? parteCapitulo;
  String? unidadeCapitulo;
  String? capitulo;

  Future<void> partesSelect() async {
    List<String> idParte = [];
    List<String> descricao = [];
    var dados = await SupaDB.instance.clienteSupaBase
        .from('Parte')
        .select(
          'Parte, Descricao',
        )
        .order('Parte', ascending: true);
    print(dados);
    for (var parte in dados) {
      idParte.add(parte['Parte'].toString());
      descricao.add(parte['Descricao'].toString());
    }
    setState(() {
      mapPartes.addAll({'Parte': idParte, 'Descricao': descricao});
    });
    print(mapPartes);
  }

  Future<void> unidadesSelect(int parte) async {
    List<String> idUnidade = [];
    List<String> unidadeNum = [];
    List<String> unidadeNome = [];
    var dados = await SupaDB.instance.clienteSupaBase
        .from('Unidade')
        .select('IdUnidade, NumUnidade, NomeUnidade')
        .match({'Parte': parte});
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

  Future<void> capitulosSelect(int unidade) async {
    List<String> idCapitulo = [];
    List<String> capituloNum = [];
    List<String> capituloNome = [];
    var dados = await SupaDB.instance.clienteSupaBase
        .from('Capitulo')
        .select('IdCapitulo, NumCapitulo, NomeCapitulo')
        .match({'IdUnidade': unidade});
    print(dados);
    for (var parte in dados) {
      idCapitulo.add(parte['IdCapitulo'].toString());
      capituloNum.add(parte['NumCapitulo'].toString());
      capituloNome.add(parte['NomeCapitulo'].toString());
    }
    setState(() {
      mapCapitulos.addAll({
        'IdCapitulo': idCapitulo,
        'NumCapitulo': capituloNum,
        'NomeCapitulo': capituloNome
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
                      int index = mapPartes['Parte']!.indexOf(value!);
                      parteUnidade = value;
                      descricaoParteController.text =
                          mapPartes['Descricao']![index];
                    });
                  }),
            ),
          ),
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
              int index = mapPartes['Parte']!.indexOf(parteUnidade!);
              int idParte = int.parse(mapPartes['Parte']![index]);
              await SupaDB.instance.clienteSupaBase
                  .from("Parte")
                  .update({"Descricao": descricaoParteController.text}).match(
                      {'Parte': idParte});
              await partesSelect();
              await mensagem.mensagem(context, 'Atualização feita com sucesso',
                  'A parte foi atulizada com sucesso', null);
            },
            child: const Text('Atualizar Parte'))
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
                  onChanged: (value) async {
                    print(mapPartes);
                    int index = mapPartes['Parte']!.indexOf(value!);
                    int idParte = int.parse(mapPartes['Parte']![index]);
                    print(idParte);
                    setState(() {
                      unidadeCapitulo = null;
                      parteUnidade = value;
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
                  value: unidade,
                  items: mapUnidades['NumUnidade']!
                      .toList()
                      .map((String valor) => buildMenuItem(
                          valor,
                          mapUnidades['NomeUnidade']![
                              mapUnidades['NumUnidade']!.indexOf(valor)]))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      unidade = value;
                      int index = mapUnidades['NumUnidade']!
                          .indexOf(unidade.toString().split(' ')[0]);
                      String nomeUnidade = mapUnidades['NomeUnidade']![index];
                      nomeUnidadeController.text = nomeUnidade;
                    });
                  }),
            ),
          ),
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
              int index =
                  mapUnidades['NumUnidade']!.indexOf(unidade!.split(' ')[0]);
              int idUnidade = int.parse(mapUnidades['IdUnidade']![index]);
              await SupaDB.instance.clienteSupaBase
                  .from("Unidade")
                  .update({"NomeUnidade": nomeUnidadeController.text}).match(
                      {'IdUnidade': idUnidade});
              setState(() {
                mapUnidades['NomeUnidade']![index] = nomeUnidadeController.text;
              });
              await mensagem.mensagem(context, 'Atualização feita com sucesso',
                  'A unidade foi atulizada com sucesso', null);
            },
            child: const Text('Atualizar Unidade'))
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
                    int idParte = int.parse(mapPartes['Parte']![index]);
                    print(idParte);
                    setState(() {
                      unidadeCapitulo = null;
                      capitulo = null;
                      parteCapitulo = value;
                      mapCapitulos.updateAll((key, value) => value = []);
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
                  hint: const Text('Escolha a Unidade'),
                  value: unidadeCapitulo,
                  items: mapUnidades['NumUnidade']!
                      .toList()
                      .map((String valor) => buildMenuItem(
                          valor,
                          mapUnidades['NomeUnidade']![
                              mapUnidades['NumUnidade']!.indexOf(valor)]))
                      .toList(),
                  onChanged: (value) async {
                    setState(() {
                      capitulo = null;
                      unidadeCapitulo = value;
                      mapCapitulos.updateAll((key, value) => value = []);
                    });
                    int index = mapUnidades['NumUnidade']!
                        .indexOf(unidadeCapitulo.toString().split(' ')[0]);
                    int idUnidade = int.parse(mapUnidades['IdUnidade']![index]);
                    await capitulosSelect(idUnidade);
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
                  hint: const Text('Escolha a Capitulo'),
                  value: capitulo,
                  items: mapCapitulos['NumCapitulo']!
                      .toList()
                      .map((String valor) => buildMenuItem(
                          valor,
                          mapCapitulos['NomeCapitulo']![
                              mapCapitulos['NumCapitulo']!.indexOf(valor)]))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      capitulo = value;
                      int index = mapCapitulos['NumCapitulo']!
                          .indexOf(capitulo.toString().split(' ')[0]);
                      String nomeCapitulo =
                          mapCapitulos['NomeCapitulo']![index];
                      nomeCapituloController.text = nomeCapitulo;
                    });
                  }),
            ),
          ),
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
              int index = mapCapitulos['NumCapitulo']!
                  .indexOf(unidadeCapitulo.toString().split(' ')[0]);
              int idCapitulo = int.parse(mapCapitulos['IdCapitulo']![index]);
              print(idCapitulo);

              await SupaDB.instance.clienteSupaBase
                  .from('Capitulo')
                  .update({'NomeCapitulo': nomeCapituloController.text}).match(
                      {'IdCapitulo': idCapitulo});
              await mensagem.mensagem(context, 'Atualização feita com sucesso',
                  'O capítulo foi atulizada com sucesso', null);
            },
            child: const Text('Atualizar Capítulo'))
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
              title: const Text('Atualizar Sumário'),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/home');
                  },
                  icon: const Icon(Icons.arrow_back)),
              bottom: const TabBar(tabs: [
                Text(
                  'Atualizar Parte',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Atualizar Unidade',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'Atualizar Capítulo',
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
