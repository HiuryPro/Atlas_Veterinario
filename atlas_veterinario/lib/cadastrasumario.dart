import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
      idUnidade.add(parte['IdParte'].toString());
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
        ElevatedButton(onPressed: () {}, child: const Text('Cadastrar Parte'))
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
                      int index = mapPartes['Parte']!.indexOf(value!);
                      print(mapPartes['IdParte']![index]);
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
            controller: descricaoParteController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome Unidade',
            )),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Cadastrar Unidade'))
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
                    int index = mapPartes['Parte']!.indexOf(value!) + 1;
                    print(index);
                    setState(() {
                      parteCapitulo = value;
                      mapUnidades.updateAll((key, value) => value = []);
                    });

                    await unidadesSelect(index);
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
            controller: descricaoParteController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nome Unidade',
            )),
        const SizedBox(
          height: 15,
        ),
        ElevatedButton(onPressed: () {}, child: const Text('Cadastrar Unidade'))
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
