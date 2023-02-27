import 'dart:io';
import 'dart:math';

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../SendEmail/enviaemail.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  String? erroemail;
  String? errosenha;

  Widget body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
                height: 200,
                width: 200,
                child: Image.asset('assets/images/AtlasLogo.png')),
            const SizedBox(height: 10),
            TextField(
                controller: nomeController,
                onChanged: (value) {
                  setState(() {
                    erroemail = null;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                )),
            const SizedBox(height: 10),
            TextField(
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    erroemail = null;
                  });
                },
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Email',
                    errorText: erroemail)),
            const SizedBox(height: 10),
            TextField(
                controller: senhaController,
                onChanged: (value) {
                  setState(() {
                    errosenha = null;
                  });
                },
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Senha',
                    errorText: errosenha)),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  var enviaemail = EnviaEmail();
                  RegExp emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                  String email = emailController.text;
                  String senha = senhaController.text;
                  String nome = nomeController.text;

                  final bool emailValid = emailRegex.hasMatch(email);

                  if (email.endsWith('@unipam.edu.br') && emailValid) {
                    if (senha.length >= 8) {
                      var random = Random();
                      String codigo = '';
                      for (int i = 0; i < 6; i++) {
                        var randomNumber = random.nextInt(
                            10); // gera um número aleatório entre 0 e 9
                        codigo += randomNumber.toString();
                      }
                      try {
                        await SupaDB.instance.clienteSupaBase
                            .from('usuario')
                            .insert({
                          'Nome': nome,
                          'Email': email,
                          'Senha': senha,
                          'Codigo': codigo,
                          'IsAtivo': false
                        });
                        await enviaemail.enviaEmailConfirmacao(email, codigo);
                      } catch (e) {
                        setState(() {
                          erroemail = 'Esse email já está em uso';
                        });
                      }
                    } else {
                      setState(() {
                        errosenha =
                            'Senha dever ser maior ou igual a 8 caracteres';
                      });
                    }
                  } else {
                    print('Email não unipam');
                    setState(() {
                      erroemail = 'Email invalido';
                    });
                  }
                },
                child: const Text('Cadastrar'))
          ],
        )),
      ),
    );
  }

  Widget alert() {
    return AlertDialog(
      title: Text("Usuário Cadastrado com Sucesso!!"),
      content: Text(
          'Um email com código de acesso foi enviado para o seu email! Use o ao fazer seu primeiro login.'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/login');
            },
            child: const Text("Ok"))
      ],
    );
  }

  Future<dynamic> mensagem() async {
    return await showDialog(
      context: context,
      builder: (_) => alert(),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon((Icons.arrow_back)),
          onPressed: () {
            Navigator.of(context).pushNamed('/login');
          },
        ),
      ),
      body: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/images/loginback.jpg',
            fit: BoxFit.cover,
          ),
        ),
        body()
      ]),
    );
  }
}
