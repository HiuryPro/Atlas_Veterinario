// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Utils/mensagens.dart';
import 'package:atlas_veterinario/Utils/rowcentralizada.dart';
import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CadastrarCapa extends StatefulWidget {
  const CadastrarCapa({super.key});

  @override
  State<CadastrarCapa> createState() => _CadastrarCapaState();
}

class _CadastrarCapaState extends State<CadastrarCapa> {
  Utils util = Utils();
  Mensagem mensagem = Mensagem();

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
                'Clique para cadastrar a Capa',
                style: TextStyle(fontSize: 20),
              )),
              const SizedBox(height: 10),
              RowCentralizada(
                  componente: ElevatedButton(
                      onPressed: () async {
                        Uint8List? imagem =
                            await util.pickAndConvertImageToBytecode();

                        if (imagem != null) {
                          print(base64.encode(imagem));
                          await SupaDB.instance.clienteSupaBase
                              .from('Capa')
                              .update({'Capa': base64.encode(imagem)}).match(
                                  {'IdCapa': 1});
                          mensagem.mensagemOpcao(context, 'Sucesso',
                              'Capa cadastrada com sucesso', null);
                        } else {
                          mensagem.mensagemOpcao(context, 'Erro a cadastrar',
                              'Imagem invalida', null);
                        }
                      },
                      child: const Text('Clique para cadastrar Imagem')))
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
