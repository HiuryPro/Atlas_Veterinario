import 'package:atlas_veterinario/Fala/textoprafala.dart';
import 'package:flutter/material.dart';

class FolhaRosto extends StatefulWidget {
  const FolhaRosto({super.key});

  @override
  State<FolhaRosto> createState() => _FolhaRostoState();
}

class _FolhaRostoState extends State<FolhaRosto> {
  bool isFalando = true;

  String textoCompleto = 'Fundação Educacional de Patos de Minas (FEPAM).'
      'É permitida a reprodução total ou parcial deste documento, desde que citada a fonte.'
      'Reitor. Henrique Carivaldo de Mitranda Neto.'
      'Pró-reitora de Ensino, Pesquisa e Extensão. Maria Marta do Couto Pereira Rodrigues.'
      'Diretor de Graduação. Mônica Soares de Araújo Guimarães.'
      'Diretor. Executivo Ghassan Tawil.'
      'Revisão Geral. Núcleo de Editoria e Publicações (NE).'
      'Diagramação.'
      'Bibliotecárias. Carolina Regina de Castro (CRB6 3134). Dione Cândido Aquino (CRB6 1720).'
      'Capa. Agência CRIVO.'
      'Imagens. Thaynara Anicesio dos Santos.'
      'Autores da Disciplina.';

  Widget body() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 10),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(width: 6, color: Colors.black)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      onPressed: () {
                        falar(textoCompleto);
                      },
                      icon: const Icon(Icons.record_voice_over)),
                ),
                const Text('Fundação Educacional de Patos de Minas (FEPAM)'),
                const Text(
                    'É permitida a reprodução total ou parcial deste documento, deste que citada fonte.'),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Reitor',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Text('Henrique Carivaldo de Mitranda Neto'),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Pró-reitora de Ensino, Pesquisa e Extensâo',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Text('Maria Marta do Couto Pereira Rodrigues'),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Diretor de Graduação',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Text('Mônica Soares de Araújo Guimarães'),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Diretor Executivo',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Text('Ghassan Tawil'),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Revisão Geral',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Text('Núcleo de Editoria e Publicações (NE)'),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Diagramação',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Text('*'),
                const Text('*'),
                const Text('*'),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Bibliotecarias',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Text('Carolina Regina de Castro (CRB6 3134)'),
                const Text('Dione Cândido Aquino (CRB6 1720)'),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Capa',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Text('Agéncia CRIVO'),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Imagens',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Text('Thaynara Anicesio dos Santos'),
                const Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text('Autores da Diciplina',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Text('*'),
                const Text('*'),
                const Text('*'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void falar(String fala) async {
    setState(() {
      isFalando = !isFalando;
    });

    if (isFalando) {
      await Fala.instance.flutterTts.stop();
      await Fala.instance.flutterTts.speak(fala);
    } else {
      await Fala.instance.flutterTts.stop();
    }

    setState(() {
      isFalando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
