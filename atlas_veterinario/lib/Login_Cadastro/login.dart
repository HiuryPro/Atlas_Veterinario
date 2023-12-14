// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Proxy/proxycapa.dart';
import 'package:flutter/material.dart';

import '../Utils/app_controller.dart';
import '../Utils/vetthemes.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  VetThemes temas = VetThemes();
  String? erroemail;
  String? errosenha;
  String? imagem;
  Image? imagemWiget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      var resultados = await ProxyCapa.instance.find(1, false);
      print(resultados);
      imagem = resultados['Capa'];
      print(imagem);
      imagemWiget = Image.memory(
        base64.decode(imagem!),
        fit: BoxFit.fill,
      );

      setState(() {});
    });
  }

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  if (MediaQuery.of(context).size.width > 1024 &&
                      MediaQuery.of(context).size.height > 600)
                    Expanded(child: imagem == null ? SizedBox() : imagemWiget!),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(right: 40, left: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 200,
                            width: 200,
                            child: Image.asset('assets/images/AtlasLogo.png')),
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
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                errosenha = null;
                                erroemail = null;
                              });
                            },
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Senha',
                                errorText: errosenha)),
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/novasenha');
                                },
                                child: const Text('Esqueceu a senha?',
                                    style: TextStyle(fontSize: 20)))),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () async {
                              RegExp emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                              String email = emailController.text;
                              String senha = senhaController.text;

                              final bool emailValid =
                                  emailRegex.hasMatch(email);

                              if (emailValid) {
                                try {
                                  Codec<String, String> stringToBase64 =
                                      utf8.fuse(base64);

                                  String senhaDec =
                                      stringToBase64.encode(senha);
                                  List user = await SupaDB
                                      .instance.clienteSupaBase
                                      .from('Usuario')
                                      .select('*')
                                      .match(
                                          {'Email': email, 'Senha': senhaDec});

                                  if (user.isEmpty) {
                                    setState(() {
                                      erroemail = 'Email/Senha Incorreto';
                                    });
                                  } else {
                                    AppController.instance.email = email;
                                    AppController.instance.senha = senha;
                                    AppController.instance.nome =
                                        user[0]['Nome'];
                                    AppController.instance.isAdmin =
                                        user[0]['IsAdmin'];
                                    AppController.instance.isFirstTime =
                                        user[0]['IsFirstTime'];

                                    if (user[0]['IsAtivo']) {
                                      Navigator.of(context).pushNamed('/home');
                                    } else {
                                      Navigator.of(context)
                                          .pushNamed('/confirmarCadastro');
                                    }
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              } else {
                                print('Email invalido');
                                setState(() {
                                  erroemail = 'Email invalido';
                                });
                              }
                            },
                            child: const Text('Entrar',
                                style: TextStyle(fontSize: 20))),
                        const SizedBox(
                          height: 20,
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/cadastro');
                                },
                                child: const Text(
                                  'Cadastrar-se',
                                  style: TextStyle(fontSize: 20),
                                )))
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/images/loginbackblue.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Theme(data: temas.loginCad(), child: body())
      ]),
    );
  }
}
