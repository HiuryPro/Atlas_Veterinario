// ignore: implementation_imports
// ignore: implementation_imports
import 'package:flutter/services.dart';
import 'package:turn_page_transition/src/turn_direction.dart';
import 'package:flutter/material.dart';
import 'package:turn_page_transition/turn_page_transition.dart';

import 'Auxiliadores/app_controller.dart';

class Home extends StatefulWidget {
  final int pagina;

  const Home({super.key, required this.pagina});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _keyS = GlobalKey();
  double paginaAntes = 1;
  double pagina = 1;
  double totalPaginas = 145;
  bool isOpen = false;
  TextEditingController fontController = TextEditingController();

  AnimationController? bottomSheetController;

  Color corFonte = AppController.instance.theme1;

  @override
  void initState() {
    super.initState();
    setState(() {
      pagina = widget.pagina.toDouble();
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
                        if (pagina < totalPaginas) {
                          Navigator.of(context).push(
                            // Use TurnPageRoute instead of MaterialPageRoute.
                            TurnPageRoute(
                              barrierColor: AppController.instance.isTema
                                  ? AppController.instance.themeCustom
                                  : AppController.instance.isDarkTheme
                                      ? const Color(0xff303030)
                                      : const Color(0xFFfafafa),
                              fullscreenDialog: true,
                              direction: TurnDirection.rightToLeft,
                              overleafColor: AppController.instance.isTema
                                  ? AppController.instance.themeCustom
                                  : AppController.instance.isDarkTheme
                                      ? const Color(0xff303030)
                                      : const Color(0xFFfafafa),
                              turningPoint: 0.2,
                              transitionDuration:
                                  const Duration(milliseconds: 1300),
                              builder: (context) =>
                                  Home(pagina: (pagina + 1).toInt()),
                            ),
                          );
                        }
                      } else if (details.globalPosition.dx <=
                              (MediaQuery.of(context).size.width / 2) &&
                          details.globalPosition.dy > 100) {
                        if (pagina > 1) {
                          Navigator.of(context).push(
                            // Use TurnPageRoute instead of MaterialPageRoute.
                            TurnPageRoute(
                              fullscreenDialog: true,
                              opaque: false,
                              direction: TurnDirection.leftToRight,
                              barrierColor: AppController.instance.isTema
                                  ? AppController.instance.themeCustom
                                  : AppController.instance.isDarkTheme
                                      ? const Color(0xff303030)
                                      : const Color(0xFFfafafa),
                              overleafColor: AppController.instance.isTema
                                  ? AppController.instance.themeCustom
                                  : AppController.instance.isDarkTheme
                                      ? const Color(0xff303030)
                                      : const Color(0xFFfafafa),
                              turningPoint: 0.2,
                              barrierDismissible: false,
                              transitionDuration:
                                  const Duration(milliseconds: 1300),
                              builder: (context) =>
                                  Home(pagina: (pagina - 1).toInt()),
                            ),
                          );
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
                              fontSize: AppController.instance.tamanhoFonte,
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
                    message: 'Abre slider de páginas',
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
                              if (fonte >= 12 && fonte <= 100) {
                                this.setState(() {
                                  AppController.instance.tamanhoFonte =
                                      fonte.toDouble();
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
                    child: Column(
                      children: [
                        IconButton(
                            iconSize: 36,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_drop_down)),
                        Center(
                            child: Text(
                                "${pagina.toInt()} de ${totalPaginas.toInt()}")),
                        Slider(
                          value: pagina,
                          label: pagina.round().toString(),
                          onChanged: (novaPagina) {
                            setState(() {
                              pagina = novaPagina.round().toDouble();
                            });
                            this.setState(() {});
                          },
                          onChangeEnd: (novaPagina) {
                            if (paginaAntes < pagina) {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                // Use TurnPageRoute instead of MaterialPageRoute.
                                TurnPageRoute(
                                  barrierColor: AppController.instance.isTema
                                      ? AppController.instance.themeCustom
                                      : AppController.instance.isDarkTheme
                                          ? const Color(0xff303030)
                                          : const Color(0xFFfafafa),
                                  fullscreenDialog: true,
                                  direction: TurnDirection.rightToLeft,
                                  overleafColor: AppController.instance.isTema
                                      ? AppController.instance.themeCustom
                                      : AppController.instance.isDarkTheme
                                          ? const Color(0xff303030)
                                          : const Color(0xFFfafafa),
                                  turningPoint: 0.1,
                                  transitionDuration:
                                      const Duration(milliseconds: 1300),
                                  builder: (context) =>
                                      Home(pagina: (pagina).toInt()),
                                ),
                              );
                            } else if (paginaAntes > pagina) {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                // Use TurnPageRoute instead of MaterialPageRoute.
                                TurnPageRoute(
                                  barrierColor: AppController.instance.isTema
                                      ? AppController.instance.themeCustom
                                      : AppController.instance.isDarkTheme
                                          ? const Color(0xff303030)
                                          : const Color(0xFFfafafa),
                                  fullscreenDialog: true,
                                  direction: TurnDirection.leftToRight,
                                  overleafColor: AppController.instance.isTema
                                      ? AppController.instance.themeCustom
                                      : AppController.instance.isDarkTheme
                                          ? const Color(0xff303030)
                                          : const Color(0xFFfafafa),
                                  turningPoint: 0.1,
                                  transitionDuration:
                                      const Duration(milliseconds: 1300),
                                  builder: (context) =>
                                      Home(pagina: (pagina).toInt()),
                                ),
                              );
                            } else {}
                          },
                          min: 1,
                          max: totalPaginas,
                          divisions: totalPaginas.toInt(),
                        )
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
                  child: ListView(shrinkWrap: true, children: [
                UserAccountsDrawerHeader(
                    decoration: AppController.instance.isTema
                        ? BoxDecoration(
                            color: AppController.instance.themeCustom2)
                        : null,
                    accountName: Text(AppController.instance.email),
                    accountEmail: Text(AppController.instance.nome)),
                Tooltip(
                  message: 'Clique para acessar o Sumário',
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.manage_search),
                    title: const Text('Sumário'),
                  ),
                ),
              ])),
              body: body());
        });
  }
}
