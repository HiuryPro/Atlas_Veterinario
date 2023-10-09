import 'package:flutter/material.dart';

import 'Proxy/proxyindices2.dart';

class TesteFuture extends StatefulWidget {
  const TesteFuture({super.key});

  @override
  State<TesteFuture> createState() => _TesteFutureState();
}

class _TesteFutureState extends State<TesteFuture> {
  Future<Widget>? widgetFuturo;
  String? valueParte;
  Future<Map>? partes;

  @override
  void initState() {
    super.initState();
    widgetFuturo = criaWidget();
    partes = ProxyIndices2().getInterface().findFull(false);
    Future.wait([ProxyIndices2().getInterface().findFull(false)]).then(
      (value) {
        print(value);
      },
    );
  }

  Future<Widget> criaWidget() async {
    await Future.delayed(const Duration(seconds: 3));

    return const Text('Teste Foda');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: partes,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }
          return Column(
            children: [
              const Center(
                child: Text('teste'),
              ),
              DropdownButton(
                  value: valueParte,
                  items: snapshot.data!.values
                      .toList()
                      .map((e) =>
                          buildMenuItem('PARTE ${'I' * e['Parte']}', null))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      valueParte = value;
                    });
                  }),
            ],
          );
        },
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item, var map) =>
      DropdownMenuItem(
          value: item,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text((map == null) ? item : '$item $map',
                style: const TextStyle(
                  fontSize: 20,
                )),
          ));
}
