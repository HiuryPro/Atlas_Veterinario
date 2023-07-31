import 'package:flutter/material.dart';

class Mensagem {
  Widget alert(
      BuildContext context, String titulo, String mensagem, String? rota) {
    return AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (rota != null) {
                Navigator.of(context).pushNamed(rota);
              }
            },
            child: const Text("Ok"))
      ],
    );
  }

  Future<dynamic> mensagem(BuildContext context, String titulo, String mensagem,
      String? rota) async {
    return await showDialog(
      context: context,
      builder: (_) => alert(context, titulo, mensagem, rota),
      barrierDismissible: true,
    );
  }

  Widget alertOpcao(
      BuildContext context, String titulo, String mensagem, String? rota) {
    return AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (rota != null) {
                Navigator.of(context).pushNamed(rota);
              }
            },
            child: const Text("Ok")),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (rota != null) {
                Navigator.of(context).pop();
              }
            },
            child: const Text("Cancelar"))
      ],
    );
  }

  Future<dynamic> mensagemOpcao(BuildContext context, String titulo,
      String mensagem, String? rota) async {
    return await showDialog(
      context: context,
      builder: (_) => alertOpcao(context, titulo, mensagem, rota),
      barrierDismissible: true,
    );
  }
}
