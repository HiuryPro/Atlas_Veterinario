import 'package:atlas_veterinario/Fala/textoprafala.dart';
import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:flutter/material.dart';

class FolhaRosto extends StatefulWidget {
  const FolhaRosto({super.key});

  @override
  State<FolhaRosto> createState() => _FolhaRostoState();
}

class _FolhaRostoState extends State<FolhaRosto> {
  Utils util = Utils();
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
        padding: const EdgeInsets.only(left: 30.0, top: 10),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(width: 6, color: Colors.black)),
          ),
          child: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () {
                          falar(textoCompleto);
                        },
                        icon: const Icon(Icons.record_voice_over)),
                  ),
                  Builder(
                    builder: (context) {
                      return telaCelular();
                    },
                  ),
                ],
              )),
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

  Expanded telaCelular() {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: const [
          Text('Fundação Educacional de Patos de Minas (FEPAM)'),
          Text(
              'É permitida a reprodução total ou parcial deste documento, deste que citada fonte.'),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child:
                Text('Reitor', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('Henrique Carivaldo de Mitranda Neto'),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text('Pró-reitora de Ensino, Pesquisa e Extensâo',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('Maria Marta do Couto Pereira Rodrigues'),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text('Diretor de Graduação',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('Mônica Soares de Araújo Guimarães'),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text('Diretor Executivo',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('Ghassan Tawil'),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text('Revisão Geral',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('Núcleo de Editoria e Publicações (NE)'),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text('Diagramação',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('*'),
          Text('*'),
          Text('*'),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text('Bibliotecarias',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('Carolina Regina de Castro (CRB6 3134)'),
          Text('Dione Cândido Aquino (CRB6 1720)'),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text('Capa', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('Agéncia CRIVO'),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child:
                Text('Imagens', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('Thaynara Anicesio dos Santos'),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text('Autores da Diciplina',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text('*'),
          Text('*'),
          Text('*'),
        ],
      ),
    );
  }

  Expanded telaMaior() {
    return Expanded(child: Row());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [body(), util.numeroPagina('2')],
      ),
    );
  }
}
