// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Auxiliadores/mensagens.dart';
import 'DadosDB/supa.dart';

class AtualizaPagina extends StatefulWidget {
  const AtualizaPagina({super.key});

  @override
  State<AtualizaPagina> createState() => _AtualizaPaginaState();
}

class _AtualizaPaginaState extends State<AtualizaPagina> {
  ScrollController _scrollController = ScrollController();
  TextEditingController conteudoPaginaController = TextEditingController();
  TextEditingController paginaController = TextEditingController();
  Mensagem mensagem = Mensagem();

  Map<String, List<String>> mapPartes = {
    'IdParte': ['1'],
    'Parte': ['1']
  };
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

  Map<String, List<String>> mapPaginas = {
    'IdPagina': [],
    'NumPagina': [],
    'ConteudoPagina': []
  };

  String? parteCapitulo;
  String? unidadeCapitulo;
  String? capitulo;
  String? pagina;

  Future<void> partesSelect() async {
    List<String> idParte = [];
    List<String> parteNum = [];
    List<String> descricao = [];
    var dados = await SupaDB.instance.clienteSupaBase
        .from('Parte')
        .select(
          'IdParte, Parte, Descricao',
        )
        .order('IdParte', ascending: true);
    print(dados);
    for (var parte in dados) {
      idParte.add(parte['IdParte'].toString());
      parteNum.add(parte['Parte'].toString());
      descricao.add(parte['Descricao'].toString());
    }
    setState(() {
      mapPartes.addAll(
          {'IdParte': idParte, 'Parte': parteNum, 'Descricao': descricao});
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

  Future<void> paginasSelect(int capitulo) async {
    List<String> idPagina = [];
    List<String> paginaNum = [];
    List<String> conteudoPagina = [];
    var dados = await SupaDB.instance.clienteSupaBase
        .from('Pagina')
        .select('IdPagina, NumPagina, Conteudo')
        .match({'IdCapitulo': capitulo});
    print(dados);
    for (var parte in dados) {
      idPagina.add(parte['IdPagina'].toString());
      paginaNum.add(parte['NumPagina'].toString());
      conteudoPagina.add(parte['Conteudo'].toString());
    }
    setState(() {
      mapPaginas.addAll({
        'IdPagina': idPagina,
        'NumPagina': paginaNum,
        'ConteudoPagina': conteudoPagina
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

  Widget body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                          capitulo = null;
                          parteCapitulo = value;
                          mapCapitulos.updateAll((key, value) => value = []);
                          mapUnidades.updateAll((key, value) => value = []);
                          mapPaginas.updateAll((key, value) => value = []);
                          conteudoPaginaController.text = '';
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
                          conteudoPaginaController.text = '';
                        });
                        int index = mapUnidades['NumUnidade']!
                            .indexOf(unidadeCapitulo.toString().split(' ')[0]);
                        int idUnidade =
                            int.parse(mapUnidades['IdUnidade']![index]);
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
                      onChanged: (value) async {
                        setState(() {
                          capitulo = value;
                          conteudoPaginaController.text = '';
                          pagina = null;
                        });
                        int index = mapCapitulos['NumCapitulo']!
                            .indexOf(capitulo.toString().split(' ')[0]);
                        int idCapitulo =
                            int.parse(mapCapitulos['IdCapitulo']![index]);
                        await paginasSelect(idCapitulo);
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
                      hint: const Text('Escolha a Página'),
                      value: pagina,
                      items: mapPaginas['NumPagina']!
                          .toList()
                          .map((String valor) => buildMenuItem(valor, null))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          pagina = value;
                          int index = mapPaginas['NumPagina']!
                              .indexOf(pagina.toString().split(' ')[0]);
                          String conteudoPagina =
                              mapPaginas['ConteudoPagina']![index];
                          conteudoPaginaController.text = conteudoPagina;
                        });
                      }),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: conteudoPaginaController,
              scrollController: _scrollController,
              autofocus: true,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              autocorrect: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  int index = mapPaginas['NumPagina']!
                      .indexOf(pagina.toString().split(' ')[0]);
                  int idPagina = int.parse(mapPaginas['IdPagina']![index]);
                  print(idPagina);

                  await SupaDB.instance.clienteSupaBase.from('Pagina').update({
                    'Conteudo': conteudoPaginaController.text
                  }).match({'IdPagina': idPagina});

                  mensagem.mensagem(context, 'Atualização feita com sucesso',
                      'A página foi atulizada com sucesso', null);
                },
                child: const Text('Atualizar Página'))
          ],
        )),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: body());
  }
}
