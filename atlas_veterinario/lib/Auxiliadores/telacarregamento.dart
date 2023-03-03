import 'package:flutter/material.dart';

class TelaCarregamento {
  List<Widget> telaCarrega(BuildContext context) {
    return [
      Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white.withOpacity(0.7),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                  child: CircularProgressIndicator(color: Color(0xFF0080d9))),
              SizedBox(height: 10),
              Center(
                  child: Text(
                      textAlign: TextAlign.center,
                      "Processando",
                      style: TextStyle(fontSize: 25, color: Colors.black))),
            ]),
      ),
    ];
  }
}
