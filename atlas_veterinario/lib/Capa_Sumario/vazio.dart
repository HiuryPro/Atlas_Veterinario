import 'package:flutter/material.dart';

class Vazio extends StatefulWidget {
  const Vazio({super.key});

  @override
  State<Vazio> createState() => _VazioState();
}

class _VazioState extends State<Vazio> {
  Widget body() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(width: 6, color: Colors.black)),
          ),
          child: const Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Center(
              child: Column(
                children: [
                  Expanded(child: SizedBox()),
                  Text('Essa página não possui conteudo'),
                  Expanded(child: SizedBox())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
