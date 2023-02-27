import 'dart:io';
import 'dart:math';

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../SendEmail/enviaemail.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
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
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {},
                    child: const Text('Esqueceu a senha?',
                        style: TextStyle(fontSize: 20)))),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () async {
                  RegExp emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                  String email = emailController.text;
                  String senha = senhaController.text;

                  final bool emailValid = emailRegex.hasMatch(email);

                  if (emailValid) {
                    List user = await SupaDB.instance.clienteSupaBase
                        .from('usuario')
                        .select('*')
                        .match({'Email': email, 'Senha': senha});
                    if (user.isEmpty) {
                      setState(() {
                        erroemail = 'Email/Senha Incorretos';
                      });
                    } else {}
                  } else {
                    print('Email invalido');
                    setState(() {
                      erroemail = 'Email invalido';
                    });
                  }
                },
                child: const Text('Entrar', style: TextStyle(fontSize: 20))),
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
        )),
      ),
    );
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
            'assets/images/loginback.jpg',
            fit: BoxFit.cover,
          ),
        ),
        body()
      ]),
    );
  }
}