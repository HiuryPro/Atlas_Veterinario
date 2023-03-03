import 'dart:math';

import 'package:atlas_veterinario/Auxiliadores/mensagens.dart';
import 'package:atlas_veterinario/SendEmail/enviaemail.dart';
import 'package:flutter/material.dart';

import '../Auxiliadores/telacarregamento.dart';
import '../DadosDB/supa.dart';

class NovaSenha extends StatefulWidget {
  const NovaSenha({super.key});

  @override
  State<NovaSenha> createState() => _NovaSenhaState();
}

class _NovaSenhaState extends State<NovaSenha> {
  TextEditingController codigoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmaSenhaController = TextEditingController();

  String? emailError;
  late TelaCarregamento telaCarregamento;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      telaCarregamento = TelaCarregamento();
    });
  }

  bool isEmailVerdadeiro = false;
  bool carregando = false;

  Widget email() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(shrinkWrap: true, children: [
            const Text(
                'Digite seu email para que seja enviado um codigo para alterar sua senha.'),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: emailController,
              onChanged: (value) {
                setState(() {
                  emailError = null;
                });
              },
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: const Text('Codigo'),
                  errorText: emailError),
            ),
            ElevatedButton(
                onPressed: () async {
                  var enviaEmail = EnviaEmail();
                  var mensagem = Mensagem();
                  try {
                    setState(() {
                      carregando = true;
                    });

                    var user = await SupaDB.instance.clienteSupaBase
                        .from('usuario')
                        .select('*')
                        .match({
                      'Email': emailController.text,
                    });

                    if (user.isEmpty) {
                      setState(() {
                        emailError =
                            'Este email está incorreto ou não está cadastrado';
                      });
                      // ignore: use_build_context_synchronously
                      await mensagem.mensagem(context, 'Erro de Email',
                          'Email incorreto ou Usúario inexistente', null);
                    } else {
                      var random = Random();
                      String codigo = '';
                      for (int i = 0; i < 6; i++) {
                        var randomNumber = random.nextInt(
                            10); // gera um número aleatório entre 0 e 9
                        codigo += randomNumber.toString();
                      }
                      await SupaDB.instance.clienteSupaBase
                          .from('usuario')
                          .update({
                        'Codigo': codigo,
                      }).match({'Email': emailController.text});

                      await enviaEmail.enviaEmailRedfinirSenha(
                          emailController.text, codigo);

                      // ignore: use_build_context_synchronously
                      await mensagem.mensagem(
                          context,
                          'Codigo para troca de senha',
                          'Um codigo foi enviado para seu email',
                          null);

                      setState(() {
                        isEmailVerdadeiro = true;
                        carregando = false;
                      });
                    }
                  } catch (e) {
                    print(e);
                    await mensagem.mensagem(context, 'Erro de Email',
                        'Email incorreto ou Usúario inexistente', null);
                    setState(() {
                      emailError = 'Email incorreto ou Usúario inexistente';
                      carregando = false;
                    });
                  }
                },
                child: const Text('Confirmar'))
          ]),
        ));
  }

  Widget novasenha() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(shrinkWrap: true, children: [
            const Text('Digite seu código de Redefinção de Senha'),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: codigoController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Codigo')),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              controller: senhaController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Senha')),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              obscureText: true,
              controller: confirmaSenhaController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Confirmar Senha')),
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    var mensagem = Mensagem();

                    await SupaDB.instance.clienteSupaBase
                        .from('usuario')
                        .update({
                      'Senha': senhaController.text,
                      'Codigo': null
                    }).match({
                      'Email': emailController.text,
                      'Codigo': codigoController.text
                    });

                    // ignore: use_build_context_synchronously
                    await mensagem.mensagem(
                        context,
                        'Sua Senha foi alterada com sucesso',
                        'A senha de seu usuário foi alterada',
                        '/login');
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('Confirmar'))
          ]),
        ));
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
        isEmailVerdadeiro ? novasenha() : email(),
        if (carregando) telaCarregamento.telaCarrega(context)[0],
        if (carregando) telaCarregamento.telaCarrega(context)[1]
      ]),
    );
  }
}
