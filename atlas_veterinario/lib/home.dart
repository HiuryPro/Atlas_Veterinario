// ignore: implementation_imports
// ignore: implementation_imports
import 'package:atlas_veterinario/Utils/mensagens.dart';
import 'package:flutter/services.dart';
import 'package:turn_page_transition/src/turn_direction.dart';
import 'package:flutter/material.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

import 'Utils/app_controller.dart';

class Home extends StatefulWidget {
  final int pagina;

  const Home({super.key, required this.pagina});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _keyS = GlobalKey();
  int paginaAntes = 1;
  int pagina = 1;
  bool isOpen = false;
  TextEditingController fontController = TextEditingController();
  TextEditingController paginaController = TextEditingController();

  AnimationController? bottomSheetController;

  Color corFonte = AppController.instance.theme1;

  @override
  void initState() {
    super.initState();
    setState(() {
      pagina = widget.pagina;
      print(pagina);
      paginaAntes = pagina;
      fontController.text =
          AppController.instance.tamanhoFonte.toInt().toString();
    });
  }

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          iconSize: 48,
                          tooltip: 'Abre opções do Aplicativo',
                          onPressed: () => _keyS.currentState!.openDrawer(),
                          icon: Image.asset('assets/images/unipam.png')),
                      const SizedBox(
                        width: 5,
                      ),
                      const Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            prefixIcon: Icon(Icons.search)),
                      )),
                      const SizedBox(
                        width: 5,
                      ),
                      opcoesdaPagina(),
                    ]),
                const SizedBox(height: 15),
                Expanded(
                  child: GestureDetector(
                    onHorizontalDragDown: (details) {
                      if (details.globalPosition.dx >
                              (MediaQuery.of(context).size.width / 2) &&
                          details.globalPosition.dy > 100) {
                        if (pagina < AppController.instance.totalPaginas) {
                          setState(() {
                            pagina += 1;
                          });
                          Navigator.of(context)
                              .push(passaPagina(TurnDirection.rightToLeft));
                        }
                      } else if (details.globalPosition.dx <=
                              (MediaQuery.of(context).size.width / 2) &&
                          details.globalPosition.dy > 100) {
                        if (pagina > 1) {
                          setState(() {
                            pagina -= 1;
                          });
                          Navigator.of(context)
                              .push(passaPagina(TurnDirection.leftToRight));
                        }
                      }
                    },
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Center(
                            child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1300s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1300s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1300s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1300s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1300s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1300s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1300s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1300s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1300s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1300s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1300s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                          style: TextStyle(
                              fontSize: AppController.instance.tamanhoFonte
                                  .toDouble(),
                              color: corFonte),
                          textAlign: TextAlign.justify,
                        )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Tooltip(
                    message: 'Abre opções de passagem de página',
                    child: IconButton(
                      iconSize: 36,
                      icon: const Icon(Icons.arrow_drop_up),
                      onPressed: () {
                        setState(() {
                          isOpen = !isOpen;
                        });
                        paginaSelector();
                      },
                    ),
                  ),
                )
              ],
            )));
  }

  PopupMenuButton<dynamic> opcoesdaPagina() {
    return PopupMenuButton(
        iconSize: 48,
        tooltip: "Abre opções de Texto",
        icon: const Icon(Icons.menu),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(child: StatefulBuilder(
                builder: ((context, setState) {
                  return Column(children: [
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
                    coresFonte(),
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

  Future<dynamic> paginaSelector() {
    return showModalBottomSheet(
        transitionAnimationController: bottomSheetController,
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, setState) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                child: SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: IconButton(
                              iconSize: 50,
                              onPressed: () {
                                setState(() {
                                  pagina -= 1;
                                });
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                    passaPagina(TurnDirection.leftToRight));
                              },
                              icon: const Icon(Icons.arrow_back)),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  '$pagina de ${AppController.instance.totalPaginas}'),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                textAlign: TextAlign.center,
                                controller: paginaController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)))),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    String value = paginaController.text;
                                    if (value != '') {
                                      int paginaDigitada = int.parse(value);
                                      if (paginaDigitada >= 1 &&
                                          paginaDigitada <=
                                              AppController
                                                  .instance.totalPaginas) {
                                        setState(() {
                                          pagina = paginaDigitada;
                                        });

                                        if (pagina < paginaAntes) {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              passaPagina(
                                                  TurnDirection.leftToRight));
                                        } else if (pagina > paginaAntes) {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              passaPagina(
                                                  TurnDirection.rightToLeft));
                                        }
                                      }
                                    }
                                  },
                                  child: const Text('Passar Pagina'))
                            ],
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                              iconSize: 50,
                              onPressed: () {
                                setState(() {
                                  pagina += 1;
                                });
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                    passaPagina(TurnDirection.rightToLeft));
                              },
                              icon: const Icon(Icons.arrow_forward)),
                        ),
                      ],
                    )),
              );
            },
          );
        });
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (context, snapshot) {
          return Scaffold(
              key: _keyS,
              drawer: Drawer(
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
                    Tooltip(
                      message: 'Clique para acessar o Sumário',
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed('/sumario');
                        },
                        leading: const Icon(Icons.manage_search),
                        title: const Text('Sumário'),
                      ),
                    ),
                    if (AppController.instance.isAdmin)
                      Tooltip(
                        message: 'Clique para cadastrar o Sumário',
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/cadastrarsumario');
                          },
                          leading: const Icon(Icons.edit_document),
                          title: const Text('Cadastrar Sumário'),
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
                      ),
                    ),
                    Tooltip(
                      message: 'Clique para Cadastrar as Páginas',
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed('/cadastrarpaginas');
                        },
                        leading: const Icon(Icons.note_add),
                        title: const Text('Cadastrar Página'),
                      ),
                    ),
                    Tooltip(
                      message: 'Clique para Atualizar as Páginas',
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed('/atualizarpaginas');
                        },
                        leading: const Icon(Icons.edit_note),
                        title: const Text('Atualizar Página'),
                      ),
                    ),
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
                  ),
                ),
              ])),
              body: body());
        });
  }
}
