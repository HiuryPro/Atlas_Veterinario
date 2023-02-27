import 'package:atlas_veterinario/Login_Cadastro/cadastrar.dart';
import 'package:atlas_veterinario/testes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Login_Cadastro/Login.dart';
import 'app_controller.dart';
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
              initialRoute: '/cadastro',
              routes: {
                '/home': (context) => const Home(
                      pagina: 1,
                    ),
                '/hometeste': (context) => const HomeTeste(
                      pagina: 1,
                    ),
                '/cadastro': (context) => const Cadastro(),
                '/login': (context) => const Login()
              });
        });
  }
}
