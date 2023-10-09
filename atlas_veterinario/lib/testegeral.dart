import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:flutter/material.dart';

class TesteGeral extends StatefulWidget {
  const TesteGeral({super.key});

  @override
  State<TesteGeral> createState() => _TesteGeralState();
}

class _TesteGeralState extends State<TesteGeral> {
  body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(children: [
        const Text(
          '1 2',
          style: TextStyle(
            fontSize: 60,
            shadows: [
              Shadow(
                  color: Colors.yellow, // Border color
                  offset: Offset(-2, -2),
                  blurRadius: 2.5 // Adjust this for border width
                  ),
              Shadow(
                  color: Colors.yellow, // Border color
                  offset: Offset(2, -2),
                  blurRadius: 2.5 // Adjust this for border width
                  ),
              Shadow(
                  color: Colors.yellow, // Border color
                  offset: Offset(-2, 2),
                  blurRadius: 2.5 // Adjust this for border width
                  ),
              Shadow(
                  color: Colors.yellow, // Border color
                  offset: Offset(2, 2),
                  blurRadius: 2.5 // Adjust this for border width
                  ),
            ],
          ),
        ),
        ElevatedButton(
            onPressed: () {
              print(Colors.yellow.value);
            },
            child: Text('Teste')),
        ElevatedButton(
            onPressed: () async {
              int maxPagina =
                  await SupaDB.instance.clienteSupaBase.rpc('max_value_pagina');
              while (maxPagina >= 12) {
                await SupaDB.instance.clienteSupaBase.from('Pagina').update(
                    {'IdPagina': maxPagina + 1}).match({'IdPagina': maxPagina});
                print(maxPagina + 1);
                maxPagina--;
              }
            },
            child: Text('Teste'))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
