// ignore: implementation_imports
import 'package:turn_page_transition/src/turn_direction.dart';
import 'package:flutter/material.dart';
import 'package:turn_page_transition/turn_page_transition.dart';
import 'Auxiliadores/app_controller.dart';

class HomeTeste extends StatefulWidget {
  final int pagina;

  const HomeTeste({super.key, required this.pagina});

  @override
  State<HomeTeste> createState() => _HomeTesteState();
}

class _HomeTesteState extends State<HomeTeste> {
  final GlobalKey<ScaffoldState> _keyS = GlobalKey();
  double tamanhoFonte = 12;
  double pagina = 1;
  double paginaAntes = 1;
  double totalPaginas = 145;
  bool isOpen = false;

  AnimationController? bottomSheetController;

  Color corFonte = AppController.instance.theme1;

  @override
  void initState() {
    super.initState();
    setState(() {
      pagina = widget.pagina.toDouble();
      paginaAntes = pagina;
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
                customAppBar(),
                const SizedBox(height: 15),
                ConteudoPagina(
                    context: context,
                    pagina: pagina,
                    totalPaginas: totalPaginas,
                    tamanhoFonte: tamanhoFonte,
                    corFonte: corFonte),
                const SizedBox(height: 15),
                Center(child: Text("$pagina de $totalPaginas")),
                Slider(
                  activeColor: const Color(0xFFf38e00),
                  inactiveColor: const Color(0xFFf38e00),
                  value: pagina,
                  label: pagina.round().toString(),
                  onChanged: (novaPagina) {
                    setState(() {
                      pagina = novaPagina.round().toDouble();
                    });
                  },
                  onChangeEnd: (novaPagina) {
                    if (paginaAntes < pagina) {
                      Navigator.of(context).push(
                        // Use TurnPageRoute instead of MaterialPageRoute.
                        TurnPageRoute(
                          barrierColor: const Color(0xFFfafafa),
                          fullscreenDialog: true,
                          direction: TurnDirection.rightToLeft,
                          overleafColor: const Color(0xFFfafafa),
                          turningPoint: 0.1,
                          transitionDuration:
                              const Duration(milliseconds: 1300),
                          builder: (context) =>
                              HomeTeste(pagina: (pagina).toInt()),
                        ),
                      );
                    } else if (paginaAntes > pagina) {
                      Navigator.of(context).push(
                        // Use TurnPageRoute instead of MaterialPageRoute.
                        TurnPageRoute(
                          barrierColor: const Color(0xFFfafafa),
                          fullscreenDialog: true,
                          direction: TurnDirection.leftToRight,
                          overleafColor: const Color(0xFFfafafa),
                          turningPoint: 0.1,
                          transitionDuration:
                              const Duration(milliseconds: 1300),
                          builder: (context) =>
                              HomeTeste(pagina: (pagina).toInt()),
                        ),
                      );
                    }
                  },
                  min: 1,
                  max: totalPaginas,
                  divisions: totalPaginas.toInt(),
                )
              ],
            )));
  }

  Widget customAppBar() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                borderRadius: BorderRadius.all(Radius.circular(50))),
            prefixIcon: Icon(Icons.search)),
      )),
      const SizedBox(
        width: 5,
      ),
      PopupMenuButton(
          iconSize: 48,
          tooltip: "Abre opções de Texto",
          icon: const Icon(Icons.menu, color: Colors.grey),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(child: StatefulBuilder(
                  builder: ((context, setState) {
                    return Column(children: [
                      const Text('Tamanho da fonte'),
                      Center(
                          child: Slider(
                        value: tamanhoFonte,
                        min: 9,
                        max: 100,
                        onChanged: ((newTF) {
                          this.setState(() {
                            tamanhoFonte = newTF;
                          });
                          setState(() {
                            tamanhoFonte = newTF;
                          });
                        }),
                      )),
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
                                  // ignore: unnecessary_this
                                  this.setState(() {
                                    corFonte = AppController.instance.theme1;
                                  });
                                }))
                          ],
                        ),
                      )
                    ]);
                  }),
                )),
              ]),
    ]);
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
                const UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(
                        'assets/images/vetAtletica.png',
                      ),
                    )),
                    accountName: Text('Teste Nome'),
                    accountEmail: Text('Teste Email')),
                Tooltip(
                  message: 'Clique para acessar o Sumário',
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.manage_search),
                    title: const Text('Sumário'),
                  ),
                ),
                Tooltip(
                  message:
                      'Clique para acessar a página de inserir paginas e imagens',
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.manage_search),
                    title: const Text('Inserir Conteudo'),
                  ),
                )
              ])),
              body: body());
        });
  }
}

class ConteudoPagina extends StatelessWidget {
  const ConteudoPagina({
    super.key,
    required this.context,
    required this.pagina,
    required this.totalPaginas,
    required this.tamanhoFonte,
    required this.corFonte,
  });

  final BuildContext context;
  final double pagina;
  final double totalPaginas;
  final double tamanhoFonte;
  final Color corFonte;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onHorizontalDragDown: (details) {
          if (details.globalPosition.dx >
                  (MediaQuery.of(context).size.width / 2) &&
              details.globalPosition.dy > 100) {
            if (pagina < totalPaginas) {
              Navigator.of(context).push(
                // Use TurnPageRoute instead of MaterialPageRoute.
                TurnPageRoute(
                  barrierColor: const Color(0xFFfafafa),
                  fullscreenDialog: true,
                  direction: TurnDirection.rightToLeft,
                  overleafColor: const Color(0xFFfafafa),
                  turningPoint: 0.1,
                  transitionDuration: const Duration(milliseconds: 1300),
                  builder: (context) => HomeTeste(pagina: (pagina + 1).toInt()),
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
                  barrierColor: const Color(0xFFfafafa),
                  fullscreenDialog: true,
                  direction: TurnDirection.leftToRight,
                  overleafColor: const Color(0xFFfafafa),
                  turningPoint: 0.1,
                  transitionDuration: const Duration(milliseconds: 1300),
                  builder: (context) => HomeTeste(pagina: (pagina - 1).toInt()),
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
              style: TextStyle(fontSize: tamanhoFonte, color: corFonte),
              textAlign: TextAlign.justify,
            )),
          ],
        ),
      ),
    );
  }
}
