import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:flutter/material.dart';
import '../Auxiliadores/app_controller.dart';
import '../Auxiliadores/mensagens.dart';
import '../Auxiliadores/vetthemes.dart';

class ConfirmarCadastro extends StatefulWidget {
  const ConfirmarCadastro({super.key});

  @override
  State<ConfirmarCadastro> createState() => _ConfirmarCadastroState();
}

class _ConfirmarCadastroState extends State<ConfirmarCadastro> {
  TextEditingController condigoController = TextEditingController();
  VetThemes temas = VetThemes();

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(shrinkWrap: true, children: [
            const Center(
                child: Text(
                    'Digite seu código de Acesso para ativar seu Usuário!!',
                    style: TextStyle(
                      color: Colors.black,
                    ))),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                  'Obs: Essa ação é necessaria apenas uma vez, depois disto você terá total acesso ao Atlas Veterinário',
                  style: TextStyle(
                    color: Colors.black,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: condigoController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Codigo')),
            ),
            ElevatedButton(
                onPressed: () async {
                  var mensagem = Mensagem();
                  try {
                    await SupaDB.instance.clienteSupaBase
                        .from('Usuario')
                        .update({'IsAtivo': true, 'Codigo': null}).match({
                      'Email': AppController.instance.email,
                      'Senha': AppController.instance.senha,
                      'Codigo': condigoController.text
                    });
                    // ignore: use_build_context_synchronously
                    await mensagem.mensagem(context, 'Conta Ativada!!',
                        'Agora você tem acesso ao Atlas Veterinário', '/home');
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('Confirmar'))
          ]),
        ));
  }

  Widget alert() {
    return AlertDialog(
      title: const Text("Usuário Ativado com Sucesso!!"),
      content: const Text(
          'Seu Usuário foi ativado com sucesso!! Clique em Ok para continuar'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/home');
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
        Theme(data: temas.loginCad(), child: body())
      ]),
    );
  }
}
