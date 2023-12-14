// ignore: implementation_imports
// ignore: implementation_imports
import 'dart:convert';

import 'package:atlas_veterinario/CadImagem/buscarimagem.dart';
import 'package:atlas_veterinario/Capa_Sumario/capitulo.dart';
import 'package:atlas_veterinario/Capa_Sumario/folharosto.dart';
import 'package:atlas_veterinario/Capa_Sumario/introducao.dart';
import 'package:atlas_veterinario/Capa_Sumario/parte.dart';
import 'package:atlas_veterinario/Capa_Sumario/vazio.dart';
import 'package:atlas_veterinario/Fala/textoprafala.dart';
import 'package:atlas_veterinario/Proxy/proxycapa.dart';
import 'package:atlas_veterinario/Utils/IconButtonVoice.dart';
import 'package:atlas_veterinario/Utils/mensagens.dart';
import 'package:atlas_veterinario/Utils/tutorial.dart';
import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:turn_page_transition/src/turn_direction.dart';
import 'package:flutter/material.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

import 'Capa_Sumario/indice.dart';
import 'Capa_Sumario/unidade.dart';
import 'Proxy/proxypagina.dart';
import 'Utils/app_controller.dart';

class Home extends StatefulWidget {
  final int pagina;

  const Home({super.key, required this.pagina});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _keyS = GlobalKey();

  String? imagem;
  Image? imagemWiget;
  Utils util = Utils();
  Future<Map<String, dynamic>?>? conteudos;
  bool isImage = false;
  Map<int, Widget> parteInicial = {
    2: const FolhaRosto(),
    3: const Indices(),
    4: const Introducao()
  };
  bool legendas = false;
  int paginaAntes = 1;
  int pagina = 1;
  bool isOpen = false;
  bool isFalando = false;

  TextEditingController fontController = TextEditingController();
  TextEditingController paginaController = TextEditingController();

  AnimationController? bottomSheetController;

  Color corFonte = AppController.instance.theme1;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      var resultados = await ProxyCapa.instance.find(1, false);
      print(resultados);
      imagem = resultados['Capa'];
      print(imagem);
      imagemWiget = Image.memory(base64.decode(imagem!), fit: BoxFit.contain);

      setState(() {});
    });
    setState(() {
      pagina = widget.pagina;
      print(pagina);
      paginaAntes = pagina;
      fontController.text =
          AppController.instance.tamanhoFonte.toInt().toString();
    });

    conteudos = buscaTelaConteudo();

    setState(() {});
  }

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        iconSize: 48,
                        tooltip: 'Abre opções do Aplicativo',
                        onPressed: () => _keyS.currentState!.openDrawer(),
                        icon: const Icon(Icons.menu)),
                    const IconButtonVoice(
                      fala: 'Clique para abrir opções do app',
                      cor: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xff386e41), shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () {
                            AppController.instance.mudaTutorial1();
                          },
                          icon: const Icon(Icons.question_mark)),
                    ),
                    const IconButtonVoice(
                      fala: 'Clique para Ajuda',
                      cor: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Expanded(child: SizedBox()),
                    const SizedBox(
                      width: 5,
                    ),
                    const IconButtonVoice(
                        cor: Colors.black, fala: 'Clique para Opções de texto'),
                    opcoesdaPagina()
                  ]),
            ),
            Expanded(
              child: buscaTela(),
            ),
            Container(
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
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: SizedBox(),
                    ),
                    const IconButtonVoice(
                        cor: Colors.black,
                        fala: 'Clique para Pesquisar as páginas'),
                    Expanded(child: paginaSelector()),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image.asset(
                        'assets/images/unipam.png',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget buscaTela() {
    if (widget.pagina == 1) {
      return imagemWiget == null
          ? SizedBox()
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              child: InteractiveViewer(maxScale: 10, child: imagemWiget!));
    } else if (parteInicial.containsKey(widget.pagina)) {
      return parteInicial[widget.pagina]!;
    } else {
      return FutureBuilder(
        future: conteudos,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox(
                child: Column(
              children: [
                Expanded(child: SizedBox()),
                Text(
                    'Essa página não possui conteudo, entrar em contato com o professor'),
                Expanded(child: SizedBox()),
              ],
            ));
          }
          return criaTela(snapshot.data!);
        },
      );
    }
  }

  Future<Map<String, dynamic>?> buscaTelaConteudo() async {
    ProxyPagina instance = ProxyPagina.instance;
    Map<String, dynamic>? resultado = await instance.find(widget.pagina, false);

    return resultado;
  }

  Widget criaTela(Map<String, dynamic> conteudo) {
    print(conteudo);
    int paginaParte = conteudo['Pagina'];
    if (!conteudo.containsKey('IdImagem')) {
      int parteId;
      int unidadeId;
      int capituloId;
      if (conteudo['Capitulo'] != null) {
        capituloId = conteudo['Capitulo']!;
        unidadeId = conteudo['Unidade']!;
        parteId = conteudo['Parte']!;
        return Capitulo(
          parte: parteId,
          capitulo: capituloId,
          unidade: unidadeId,
          pagina: paginaParte,
        );
      } else if (conteudo['Unidade'] != null) {
        unidadeId = conteudo['Unidade']!;
        parteId = conteudo['Parte']!;
        return Unidade(parte: parteId, unidade: unidadeId, pagina: paginaParte);
      } else if (conteudo['Parte'] != null) {
        parteId = conteudo['Parte']!;

        return Parte(parte: parteId, pagina: paginaParte);
      } else {
        return Vazio(pagina: paginaParte);
      }
    } else {
      isImage = true;
      return BuscarImagemPainter(
        dadosPaginaImagem: conteudo,
      );
    }
  }

  PopupMenuButton<dynamic> opcoesdaPagina() {
    return PopupMenuButton(
        iconSize: 35,
        tooltip: "Abre opções de Texto",
        icon: const Icon(Icons.settings, color: Colors.black),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(child: StatefulBuilder(
                builder: ((context, setState) {
                  return Column(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          tooltip: 'Clique para fechar',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close)),
                    ),
                    Row(
                      children: [
                        const Text('Tamanho da fonte'),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: TextField(
                          onChanged: (value) {
                            if (value != '') {
                              int fonte = int.parse(value);
                              if (fonte >= 9 && fonte <= 100) {
                                this.setState(() {
                                  AppController.instance.tamanhoFonte = fonte;
                                });
                              }
                            }
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: fontController,
                        ))
                      ],
                    ),
                    Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: const Icon(Icons.text_decrease),
                                onPressed: () {
                                  this.setState(() {
                                    AppController.instance.tamanhoFonte -= 1;
                                    fontController.text = AppController
                                        .instance.tamanhoFonte
                                        .toInt()
                                        .toString();
                                  });
                                }),
                            const SizedBox(width: 5),
                            IconButton(
                                icon: const Icon(Icons.text_increase),
                                onPressed: () {
                                  this.setState(() {
                                    AppController.instance.tamanhoFonte += 1;
                                    fontController.text = AppController
                                        .instance.tamanhoFonte
                                        .toInt()
                                        .toString();
                                  });
                                }),
                          ]),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text('Cor da Fonte'),
                    const SizedBox(
                      height: 5,
                    ),
                    coresFonte(),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text('Cor do Tema'),
                    const SizedBox(
                      height: 5,
                    ),
                    escolheThemas(),
                    const SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Modo Noturno'),
                          Switch(
                              value: AppController.instance.isDarkTheme,
                              onChanged: ((value) {
                                setState(() {
                                  AppController.instance.changeTheme();
                                });
                                this.setState(() {
                                  corFonte = AppController.instance.theme1;
                                });
                              }))
                        ],
                      ),
                    ),
                  ]);
                }),
              )),
            ]);
  }

  TurnPageRoute passaPagina(var direcao) {
    return TurnPageRoute(
      barrierColor: AppController.instance.isTema
          ? AppController.instance.themeCustom
          : AppController.instance.isDarkTheme
              ? const Color(0xff303030)
              : const Color(0xFFfafafa),
      fullscreenDialog: true,
      direction: direcao,
      overleafColor: AppController.instance.isTema
          ? AppController.instance.themeCustom
          : AppController.instance.isDarkTheme
              ? const Color(0xff303030)
              : const Color(0xFFfafafa),
      turningPoint: 0.1,
      transitionDuration: const Duration(milliseconds: 1300),
      builder: (context) => Home(pagina: (pagina).toInt()),
    );
  }

  TextField paginaSelector() {
    return TextField(
      textAlign: TextAlign.center,
      controller: paginaController,
      decoration: InputDecoration(
          prefixIconColor: Colors.green,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.greenAccent),
              borderRadius: BorderRadius.all(Radius.circular(30)),
              gapPadding: 4 //<-- SEE HERE
              ),
          hintText:
              'Pesquise uma página $pagina de ${AppController.instance.totalPaginas}',
          prefixIcon: IconButton(
              onPressed: () {
                String value = paginaController.text;
                if (value != '') {
                  int paginaDigitada = int.parse(value);
                  if (paginaDigitada >= 1 &&
                      paginaDigitada <= AppController.instance.totalPaginas) {
                    setState(() {
                      pagina = paginaDigitada;
                    });

                    if (pagina < paginaAntes) {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .push(passaPagina(TurnDirection.leftToRight));
                    } else if (pagina > paginaAntes) {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .push(passaPagina(TurnDirection.rightToLeft));
                    }
                  }
                }
              },
              icon: const Icon(Icons.search)),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)))),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  coresFonte() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (() {
                // ignore: unnecessary_this
                this.setState(() {
                  corFonte = Colors.orange;
                });
              }),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: (() {
                // ignore: unnecessary_this
                this.setState(() {
                  corFonte = AppController.instance.theme1;
                });
              }),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  color: AppController.instance.theme1,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  escolheThemas() {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (() {
                // ignore: unnecessary_this

                setState(() {
                  AppController.instance.ativaTema();
                  AppController.instance.corVerde();
                });
              }),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: (() {
                // ignore: unnecessary_this
                setState(() {
                  AppController.instance.desativaTema();
                });
              }),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  color: AppController.instance.theme2,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Drawer drawerApp() {
    return Drawer(
        child: Container(
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
      child: Column(children: [
        UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: AppController.instance.theme2,
                image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/PatoUlt.png'))),
            accountName: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(AppController.instance.email)),
            accountEmail: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(AppController.instance.nome))),
        Expanded(
          child: ListView(shrinkWrap: true, children: [
            GestureDetector(
              onLongPress: () async {
                await Fala.instance.flutterTts.stop();
                await Fala.instance.flutterTts
                    .speak('Clique para acessar o Sumário');
              },
              onDoubleTap: () async {
                await Fala.instance.flutterTts.stop();
              },
              child: Tooltip(
                message: 'Clique para acessar o Sumário',
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed('/sumario');
                  },
                  leading: const Icon(Icons.manage_search),
                  title: const Text('Sumário'),
                  trailing: const IconButtonVoice(
                      cor: Colors.black, fala: 'Clique para acessar o sumario'),
                ),
              ),
            ),
            if (AppController.instance.isAdmin) ...optionsAdmin()
          ]),
        ),
        Tooltip(
          message: 'Clique para fazer Logout',
          child: ListTile(
            onTap: () async {
              var mensagem = Mensagem();
              await mensagem.mensagemOpcao(context, 'Fazer Logout',
                  'Deseja realmente fazer logout?', '/login');
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            trailing: const IconButtonVoice(
                cor: Colors.black, fala: 'Clique para fazer logout'),
          ),
        ),
      ]),
    ));
  }

  List<Widget> optionsAdmin() {
    return [
      Tooltip(
        message: 'Clique para cadastrar o Sumário',
        child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/cadastrarsumario');
          },
          leading: const Icon(Icons.edit_document),
          title: const Text('Cadastrar Sumário'),
          trailing: const IconButtonVoice(
              cor: Colors.black, fala: 'Clique para cadastrar o Sumário'),
        ),
      ),
      Tooltip(
        message: 'Clique para Atualizar o Sumário',
        child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/atualizasumario');
          },
          leading: const Icon(Icons.edit_square),
          title: const Text('Atualizar Sumário'),
          trailing: const IconButtonVoice(
              cor: Colors.black, fala: 'Clique para atualizar o Sumário'),
        ),
      ),
      Tooltip(
        message: 'Clique para Cadastrar a Capa',
        child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/cadastracapa');
          },
          leading: const Icon(Icons.add_a_photo),
          title: const Text('Cadastrar Capa'),
          trailing: const IconButtonVoice(
              cor: Colors.black, fala: 'Clique para Cadastrar a Capa'),
        ),
      ),
      Tooltip(
        message: 'Clique para Cadastrar a Introdução',
        child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/cadastrarintroducao');
          },
          leading: const Icon(Icons.article),
          title: const Text('Cadastrar Introdução'),
          trailing: const IconButtonVoice(
              cor: Colors.black, fala: 'Clique para Cadastrar a Introdução'),
        ),
      ),
      Tooltip(
        message: 'Clique para Cadastrar as Imagens',
        child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/cadastrarimagem');
          },
          leading: const Icon(Icons.image),
          title: const Text('Cadastrar Imagens'),
          trailing: const IconButtonVoice(
              cor: Colors.black, fala: 'Clique para cadastrar as Imagens'),
        ),
      ),
      Tooltip(
        message: 'Clique para Cadastrar as Páginas',
        child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/cadastrarpaginas');
          },
          leading: const Icon(Icons.note_add),
          title: const Text('Cadastrar Páginas'),
          trailing: const IconButtonVoice(
              cor: Colors.black, fala: 'Clique para cadastrar as Imagens'),
        ),
      ),
      Tooltip(
        message: 'Clique para Atualizar as Páginas',
        child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed('/atualizarpaginas');
          },
          leading: const Icon(Icons.edit_note),
          title: const Text('Atualizar Páginas'),
          trailing: const IconButtonVoice(
              cor: Colors.black, fala: 'Clique para atualizar as Páginas'),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (context, snapshot) {
          return Scaffold(
              key: _keyS,
              drawer: drawerApp(),
              body: Stack(
                children: [
                  body(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.3)),
                      child: IconButton(
                        onPressed: () {
                          if (pagina > 1) {
                            setState(() {
                              pagina -= 1;
                            });

                            Navigator.of(context)
                                .push(passaPagina(TurnDirection.leftToRight));
                          }
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.3)),
                      child: IconButton(
                        onPressed: () {
                          if (pagina < AppController.instance.totalPaginas) {
                            setState(() {
                              pagina += 1;
                            });
                            Navigator.of(context)
                                .push(passaPagina(TurnDirection.rightToLeft));
                          }
                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                  if (AppController.instance.tutorial1 ||
                      AppController.instance.isFirstTime)
                    const Tutorial1(),
                ],
              ));
        });
  }
}
