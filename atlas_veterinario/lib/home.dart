import 'package:turn_page_transition/src/turn_direction.dart';
import 'package:flutter/material.dart';
import 'package:turn_page_transition/turn_page_transition.dart';
import 'app_controller.dart';

class Home extends StatefulWidget {
  final int pagina;

  const Home({super.key, required this.pagina});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _keyS = GlobalKey();
  double tamanhoFonte = 12;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      pagina = widget.pagina.toDouble();
    });
  }

  double pagina = 1;
  double totalPaginas = 145;

  Color corFonte = AppController.instance.theme1;

  Widget body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onHorizontalDragDown: (details) {
              print(details.globalPosition.dy);
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
                      turningPoint: 0.2,
                      transitionDuration: const Duration(milliseconds: 1200),
                      builder: (context) => Home(pagina: (pagina + 1).toInt()),
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
                      turningPoint: 0.2,
                      transitionDuration: const Duration(milliseconds: 1200),
                      builder: (context) => Home(pagina: (pagina - 1).toInt()),
                    ),
                  );
                }
              }
              print(MediaQuery.of(context).size.width);
              print(MediaQuery.of(context).size.height);
              print(details.globalPosition.dx);
              print(details.globalPosition.dy);
            },
            child: ListView(
              shrinkWrap: true,
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
                      PopupMenuButton(
                          iconSize: 48,
                          tooltip: "Abre opções de Texto",
                          icon: const Icon(Icons.menu, color: Colors.grey),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
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
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: (() {
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
                                                this.setState(() {
                                                  corFonte = AppController
                                                      .instance.theme1;
                                                });
                                              }),
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  border: Border.all(width: 2),
                                                  color: AppController
                                                      .instance.theme1,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text('Modo Noturno'),
                                            Switch(
                                                value: AppController
                                                    .instance.isDarkTheme,
                                                onChanged: ((value) {
                                                  setState(() {
                                                    AppController.instance
                                                        .changeTheme();
                                                  });
                                                  this.setState(() {
                                                    corFonte = AppController
                                                        .instance.theme1;
                                                  });
                                                }))
                                          ],
                                        ),
                                      ),
                                    ]);
                                  }),
                                )),
                              ]),
                    ]),
                const SizedBox(
                  height: 15,
                ),
                Center(
                    child: Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                  style: TextStyle(fontSize: tamanhoFonte, color: corFonte),
                  textAlign: TextAlign.justify,
                )),
                const SizedBox(
                  height: 15,
                ),
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
                    print(pagina);
                  },
                  min: 1,
                  max: totalPaginas,
                  divisions: totalPaginas.toInt(),
                )
              ],
            ),
          )),
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
                    accountName: Text('Teste Nome'),
                    accountEmail: Text('Teste Email')),
                Tooltip(
                  message: 'Clique para acessar o Sumário',
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.manage_search),
                    title: const Text('Sumário'),
                  ),
                )
              ])),
              body: body());
        });
  }
}
