import 'package:flutter/material.dart';
import 'app_controller.dart';
import 'dart:math' as math;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double tamanhoFonte = 12;

  Color corFonte = AppController.instance.theme1;

  Widget body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Flexible(
                    flex: 1, child: Image.asset('assets/images/unipam.png')),
                const Flexible(
                    flex: 4,
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.search)),
                    )),
                Flexible(
                  flex: 1,
                  child: PopupMenuButton(
                      icon: const Icon(Icons.menu),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                            PopupMenuItem(child: StatefulBuilder(
                              builder: ((context, setState) {
                                return Column(children: [
                                  const Text('Digite o tamanho da fonte'),
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              this.setState(() {
                                                tamanhoFonte -= 1;
                                              });
                                            },
                                            child: const Icon(
                                                Icons.text_decrease)),
                                        TextButton(
                                            onPressed: () {
                                              this.setState(() {
                                                tamanhoFonte += 1;
                                              });
                                            },
                                            child: const Icon(
                                                Icons.text_increase)),
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
                                              corFonte =
                                                  AppController.instance.theme1;
                                            });
                                          }),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 2),
                                              color:
                                                  AppController.instance.theme1,
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
                )
              ]),
              const SizedBox(
                height: 15,
              ),
              Center(
                  child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                style: TextStyle(fontSize: tamanhoFonte, color: corFonte),
                textAlign: TextAlign.justify,
              )),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color cores = Colors.black;
    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (context, snapshot) {
          return Scaffold(body: body());
        });
  }
}
