import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Capa extends StatefulWidget {
  const Capa({super.key});

  @override
  State<Capa> createState() => _CapaState();
}

class _CapaState extends State<Capa> {
  Widget body() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff1a4d34),
            Color(0xff386e41),
            Colors.white,
            Colors.white
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 30, top: 20, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text("Autores",
                      style: TextStyle(color: Color(0xff2a4c09), fontSize: 20)),
                )),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 5, color: Color(0xff2a4c09))),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Column(
                    children: [
                      const Expanded(child: SizedBox()),
                      const AutoSizeText.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'ATLAS DE\nANATOMIA\n',
                                style: TextStyle(
                                    color: Color(0xff2a4c09),
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: 'DOS RUMINANTES DOMÉSTICOS',
                                style: TextStyle(
                                    color: Color(0xff2a4c09),
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic)),
                          ],
                        ),
                        minFontSize: 5,
                        maxLines: 4,
                      ),
                      const Expanded(child: SizedBox()),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                            width: 70,
                            height: 70,
                            child: Image.asset('assets/images/unipam.png')),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body());
  }
}
