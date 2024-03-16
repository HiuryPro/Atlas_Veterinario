import 'package:atlas_veterinario/Capa_Sumario/capa.dart';
import 'package:atlas_veterinario/Capa_Sumario/folharosto.dart';
import 'package:atlas_veterinario/Login_Cadastro/cadastrar.dart';
import 'package:atlas_veterinario/Login_Cadastro/confirmarcadastro.dart';
import 'package:atlas_veterinario/atualizasumario.dart';
import 'package:atlas_veterinario/cadastrarcapa.dart';
import 'package:atlas_veterinario/cadastrarintroducao.dart';
import 'package:atlas_veterinario/cadastrarpagina.dart';
import 'package:atlas_veterinario/cadastrasumario.dart';
import 'package:atlas_veterinario/deletapagina.dart';
import 'package:atlas_veterinario/deletarimagem.dart';
import 'package:atlas_veterinario/sumario.dart';
import 'package:atlas_veterinario/CadImagem/testeputimage.dart';
import 'package:atlas_veterinario/testefuture.dart';
import 'package:atlas_veterinario/testegeral.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Capa_Sumario/indice.dart';
import 'Capa_Sumario/introducao.dart';
import 'Login_Cadastro/Login.dart';
import 'Utils/app_controller.dart';
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
              initialRoute: '/login',
              routes: {
                '/home': (context) => const Home(
                      pagina: 1,
                    ),
                '/hometeste': (context) => const HomeTeste(
                      pagina: 1,
                    ),
                '/testegeral': (context) => const TesteGeral(),
                '/cadastracapa': (context) => const CadastrarCapa(),
                '/cadastrarintroducao': (context) =>
                    const CadastrarIntroducao(),
                '/cadastro': (context) => const Cadastro(),
                '/login': (context) => const Login(),
                '/confirmarCadastro': (context) => const ConfirmarCadastro(),
                '/novasenha': (context) => const NovaSenha(),
                '/sumario': (context) => const Sumario(),
                '/cadastrarsumario': (context) => const CadastraSumario(),
                '/atualizasumario': (context) => const AtualizaSumario(),
                '/cadastrarpaginas': (context) => const CadPagina(),
                '/atualizarpaginas': (context) => const AtualizaPagina(),
                '/deletarpaginas': (context) => const DeletarPagina(),
                '/deletarimagem': (context) => const DeletarImagem(),
                '/teste': (context) => const TesteGeral(),
                '/cadastrarimagem': (context) => const CadastrarImagem(),
                '/capa': (context) => const CapaTela(),
                '/rosto': (context) => const FolhaRosto(),
                '/indices': (context) => const Indices(),
                '/introducao': (context) => const Introducao(),
                '/testefuturo': (context) => const TesteFuture()
              });
        });
  }
}
