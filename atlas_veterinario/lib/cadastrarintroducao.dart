// ignore_for_file: use_build_context_synchronously

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/introducaoproxy.dart';
import 'package:atlas_veterinario/Utils/mensagens.dart';
import 'package:atlas_veterinario/Utils/rowcentralizada.dart';
import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:flutter/material.dart';

class CadastrarIntroducao extends StatefulWidget {
  const CadastrarIntroducao({super.key});

  @override
  State<CadastrarIntroducao> createState() => _CadastrarIntroducaoState();
}

class _CadastrarIntroducaoState extends State<CadastrarIntroducao> {
  Utils util = Utils();
  Mensagem mensagem = Mensagem();
  TextEditingController editTextController = TextEditingController();

// Initialise a scroll controller.
  ScrollController scrollController = ScrollController();
  String introducao = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      var resultados = await ProxyIntroducao.instance.find(1, false);
      print(resultados);
      introducao = resultados['Introducao'];
      print(introducao);
      editTextController.text = introducao;

      setState(() {});
    });

    setState(() {});
  }

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
                child: ListView(shrinkWrap: true, children: [
              const Center(
                  child: Text(
                'Cadastrar Introdução',
                style: TextStyle(fontSize: 20),
              )),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Flexible(
                    flex: 4,
                    child: Scrollbar(
                      controller: scrollController,
                      child: TextField(
                        scrollController: scrollController,
                        controller: editTextController,
                        autofocus: true,
                        keyboardType: TextInputType.multiline,
                        maxLines: 7,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        onChanged: (s) => {},
                      ),
                    ),
                  ),
                  const Flexible(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              RowCentralizada(
                  componente: ElevatedButton(
                      onPressed: () async {
                        if (editTextController.text != '') {
                          await SupaDB.instance.clienteSupaBase
                              .from('Introducao')
                              .update({
                            'Introducao': editTextController.text
                          }).match({'IdIntroducao': 1});

                          var resultados =
                              await ProxyIntroducao.instance.find(1, true);
                          print(resultados);
                          introducao = resultados['Introducao'];
                          mensagem.mensagemOpcao(context, 'Sucesso',
                              'Introdução cadastrada com sucesso', null);
                        } else {
                          mensagem.mensagemOpcao(context, 'Erro a cadastrar',
                              'Introdução está vazia', null);
                        }
                      },
                      child: const Text('Clique para cadastrar a Introdução')))
            ]))));
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
