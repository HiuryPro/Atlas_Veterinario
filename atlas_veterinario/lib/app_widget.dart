import 'package:atlas_veterinario/Login_Cadastro/cadastrar.dart';
import 'package:atlas_veterinario/Login_Cadastro/confirmarcadastro.dart';
import 'package:atlas_veterinario/atualizasumario.dart';
import 'package:atlas_veterinario/cadastrarpagina.dart';
import 'package:atlas_veterinario/cadastrasumario.dart';
import 'package:atlas_veterinario/sumario.dart';
import 'package:atlas_veterinario/teste.dart';
import 'package:atlas_veterinario/salvaimagem.dart';
import 'package:atlas_veterinario/buscaimagem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Login_Cadastro/Login.dart';
import 'Auxiliadores/app_controller.dart';
import 'Login_Cadastro/novasenha.dart';
import 'atualizarpagina.dart';
import 'home.dart';
import 'hometeste.dart';

class Core extends StatelessWidget {
  const Core({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppWidget();
  }
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (context, child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              supportedLocales: const [Locale('pt', 'BR')],
              theme: AppController.instance.isTema
                  ? AppController.instance.temaEmUso
                  : ThemeData(
                      brightness: AppController.instance.isDarkTheme
                          ? Brightness.dark
                          : Brightness.light),
              initialRoute: '/buscaImagem',
              routes: {
                '/home': (context) => const Home(
                      pagina: 1,
                    ),
                '/hometeste': (context) => const HomeTeste(
                      pagina: 1,
                    ),
                '/cadastro': (context) => const Cadastro(),
                '/login': (context) => const Login(),
                '/confirmarCadastro': (context) => const ConfirmarCadastro(),
                '/novasenha': (context) => const NovaSenha(),
                '/sumario': (context) => const Sumario(),
                '/cadastrarsumario': (context) => const CadastraSumario(),
                '/atualizasumario': (context) => const AtualizaSumario(),
                '/cadastrarpaginas': (context) => const CadastraPagina(),
                '/atualizarpaginas': (context) => const AtualizaPagina(),
                '/buscaImagem': (context) => const BuscaImagem(),
                '/salvaImagen': (context) => const SalvaImagem(),
                '/teste': (context) => const TesteWidget()
              });
        });
  }
}
