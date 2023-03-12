import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/home.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Sumario extends StatefulWidget {
  const Sumario({super.key});

  @override
  State<Sumario> createState() => _SumarioState();
}

class _SumarioState extends State<Sumario> {
  Set partes = {};
  List conteudoPartes = [];
  List<Map> listaSumario = [];
  var myGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var res = await SupaDB.instance.clienteSupaBase.from('Capitulo').select(
          'NumCapitulo, NomeCapitulo, PaginaInicio ,Unidade!inner(NumUnidade, NomeUnidade ,Parte!inner(Parte))');
      setState(() {
        for (var pegaPartes in res) {
          partes.add(pegaPartes['Unidade']['Parte']['Parte']);
        }

        print(conteudoPartes);
        setState(() {
          for (int i = 0; i < partes.length; i++) {
            conteudoPartes.add([]);
            for (Map items in res) {
              Map teste = {};
              if (items['Unidade']['Parte']['Parte'] == (i + 1)) {
                teste['NumUnidade'] = items['Unidade']['NumUnidade'];
                teste['NomeUnidade'] = items['Unidade']['NomeUnidade'];
                teste['NumCapitulo'] = items['NumCapitulo'];
                teste['NomeCapitulo'] = items['NomeCapitulo'];
                teste['PaginaInicio'] = items['PaginaInicio'];

                conteudoPartes[i].add(teste);
              }
            }
          }
        });

        print(conteudoPartes[0]);
        print('  dfdfd');
        print(conteudoPartes[1]);
        print(partes.length);
      });
    });
  }

  Widget buttonTeste(parte) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          for (Map sumario in conteudoPartes[parte])
            Column(
              children: [
                InkWell(
                  onTap: () {
                    print(sumario['PaginaInicio']);
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          Home(pagina: sumario['PaginaInicio']),
                    ));
                  },
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 4,
                          fit: FlexFit.tight,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: AutoSizeText(
                              "Capítulo ${sumario['NumCapitulo']}:  ${sumario['NomeCapitulo']}",
                              style: const TextStyle(fontSize: 25),
                              minFontSize: 12,
                              maxLines: 6,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: AutoSizeText(
                              "${sumario['PaginaInicio']}",
                              style: const TextStyle(fontSize: 25),
                              minFontSize: 12,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
        ],
      ),
    );
  }

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
              children: [for (var parte in partes) buttonTeste(parte - 1)]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: partes.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              for (var parte in partes)
                Tab(
                  text: 'Parte ${'I' * parte}',
                ),
            ],
          ),
          title: const Text('Sumario'),
        ),
        body: body(),
      ),
    );
  }
}


/*
Padding(
        padding: const EdgeInsets.all(8.0),
        child:  ListView(
          shrinkWrap: true,
          children: [
            ElevatedButton(
                onPressed: () async {
                  Set partes = {};
                  var res = await SupaDB.instance.clienteSupaBase
                      .from('Capitulo')
                      .select(
                          'NumCapitulo, NomeCapitulo, Unidade!inner(NumUnidade, NomeUnidade ,Parte!inner(Parte))');

                  for (var pegaPartes in res) {
                    partes.add(pegaPartes['Unidade']['Parte']['Parte']);
                  }

                  List conteudoPartes = [];
                  print(conteudoPartes);
                  List dados = [];
                  for (int i = 0; i < partes.length; i++) {
                    conteudoPartes.add([]);
                    for (var items in res) {
                      if (items['Unidade']['Parte']['Parte'] == (i + 1)) {
                        print(items['Unidade']['Parte']['Parte']);
                        conteudoPartes[i].add(items);
                      }
                    }
                  }

                  print(conteudoPartes[0]);
                },
                child: const Text('Faz select'))
          ],
        ),
      ),




 var partesSupa = await SupaDB.instance.clienteSupaBase
                      .from('Parte')
                      .select('Parte');

                  for(var parte in partesSupa){
                    partes.add(parte['Parte']);
                  }

                  for(var parte in partes){
                    
                  }
                  var unidadesCap = await SupaDB.instance.clienteSupaBase
                      .from('Capitulo')
                      .select(
                          'NumCapitulo, NomeCapitulo, Unidade!inner(NumUnidade, NomeUnidade ,Parte!inner(Parte))')
                      .match({'Unidade.Parte.Parte': 2});
                  print(unidadesCap);
*/
