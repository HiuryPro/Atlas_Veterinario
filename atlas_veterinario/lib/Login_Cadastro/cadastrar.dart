import 'dart:convert';
import 'dart:math';

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:flutter/material.dart';

import '../Utils/mensagens.dart';
import '../Utils/telacarregamento.dart';
import '../Utils/vetthemes.dart';
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
  VetThemes temas = VetThemes();

  bool carregando = false;
  late TelaCarregamento telaCarregamento;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      telaCarregamento = TelaCarregamento();
    });
  }

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
                obscureText: true,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Senha',
                    errorText: errosenha)),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  var enviaemail = EnviaEmail();
                  var mensagem = Mensagem();
                  RegExp emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                  String email = emailController.text;
                  String senha = senhaController.text;
                  String nome = nomeController.text;

                  final bool emailValid = emailRegex.hasMatch(email);

                  if (emailValid) {
                    if (email.endsWith('@unipam.edu.br')) {
                      if (senha.length >= 8) {
                        setState(() {
                          carregando = true;
                        });
                        var random = Random();
                        String codigo = '';
                        for (int i = 0; i < 6; i++) {
                          var randomNumber = random.nextInt(
                              10); // gera um número aleatório entre 0 e 9
                          codigo += randomNumber.toString();
                        }
                        try {
                          Codec<String, String> stringToBase64 =
                              utf8.fuse(base64);
                          await SupaDB.instance.clienteSupaBase
                              .from('Usuario')
                              .insert({
                            'Nome': nome,
                            'Email': email,
                            'Senha': stringToBase64.encode(senha),
                            'Codigo': codigo,
                            'IsAtivo': false
                          });
                          await enviaemail.enviaEmailConfirmacao(email, codigo);
                          // ignore: use_build_context_synchronously
                          await mensagem.mensagem(
                              context,
                              'Usuário criado com Sucesso!!',
                              'Um email com codigo de acesso foi enviado para o seu email. Utilize-o ao fazer o primeiro login',
                              '/login');
                          setState(() {
                            carregando = false;
                          });
                        } catch (e) {
                          print(e);
                          setState(() {
                            erroemail = 'Esse email já está em uso';
                            carregando = false;
                          });
                        }
                      } else {
                        setState(() {
                          errosenha =
                              'Senha dever ser maior ou igual a 8 caracteres';
                        });
                      }
                    } else {
                      setState(() {
                        erroemail = 'Este email não é do dominio Unipam';
                      });
                    }
                  } else {
                    setState(() {
                      erroemail = 'Este email é invalido';
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
      title: const Text("Usuário Cadastrado com Sucesso!!"),
      content: const Text(
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
      body: Theme(
        data: temas.loginCad(),
        child: Stack(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/images/loginback.jpg',
              fit: BoxFit.cover,
            ),
          ),
          body(),
          if (carregando) telaCarregamento.telaCarrega(context)[0],
          if (carregando) telaCarregamento.telaCarrega(context)[1]
        ]),
      ),
    );
  }
}
