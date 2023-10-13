import 'package:atlas_veterinario/Fala/textoprafala.dart';
import 'package:atlas_veterinario/Utils/app_controller.dart';
import 'package:flutter/material.dart';

class Tutorial1 extends StatefulWidget {
  const Tutorial1({super.key});

  @override
  State<Tutorial1> createState() => _Tutorial1State();
}

class _Tutorial1State extends State<Tutorial1> {
  bool isFalando = false;

  String textoGrande =
      'Para navegar pelas páginas, você pode executar a ação de deslizar o dedo '
      'pela tela. Deslizar o dedo para a esquerda permitirá avançar para a próxima '
      'página, enquanto deslizar o dedo para a direita o levará de volta à página '
      'anterior. Alternativamente, você também pode utilizar o gesto de duplo clique '
      'na parte esquerda ou direita da tela para efetuar a troca de página. '
      'Outra opção para navegação é clicar no pequeno triângulo localizado na parte inferior da página. '
      'Ao fazer isso, você abrirá um menu que apresentará diversas opções para avançar ou retroceder '
      'nas páginas, oferecendo uma experiência de leitura mais flexível e intuitiva.';

  String textoGrande2 =
      'Para navegar entre as páginas de conteúdo, você pode deslizar o dedo pela tela. '
      'No entanto, é importante notar que essa ação não é aplicável em telas com imagens, '
      'uma vez que o gesto de deslizar é utilizado para interagir com as imagens.';

  String textoGrande3 =
      'Para as telas que contêm imagens, você tem a opção de realizar '
      'zoom e arrastar as imagens para uma visualização mais detalhada. Junto ao nome '
      'da imagem, há um ícone que, quando clicado, permite a rotação da imagem para diferentes '
      'orientações. Adicionalmente, logo abaixo da imagem, você encontrará um menu suspenso '
      '(dropdown) que, ao ser clicado, exibe os nomes das estruturas presentes na peça em questão. '
      'Ao selecionar um nome específico no menu suspenso, o número associado àquela estrutura será '
      'destacado, facilitando a identificação e referência das partes da imagem';

  String textoGrande4 =
      'No canto superior direito há um menu que ao ser clicado apresenta '
      'opções de alteração de texto e tema do app. No canto superior esquerdo '
      'há uma imagem da logo do UNIPAM que ao ser clicado apresenta '
      'o menu lateral do app com mais opções';

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
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            falar(
                                'Ajuda. Observação: Clique no Icone de fala para ouvir o que está escrito. Clique novamente para parar.');
                          },
                          icon: const Icon(Icons.record_voice_over)),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Ajuda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                    ),
                    const Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Observação: Clique no Icone ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff386e41),
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                        ),
                        Center(child: Icon(Icons.record_voice_over)),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'para ouvir o que está escrito. Clique novamente para parar.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff386e41),
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            falar(
                                'Passagem de páginas. $textoGrande $textoGrande2');
                          },
                          icon: const Icon(Icons.record_voice_over)),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Passagem de páginas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          textoGrande,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          textoGrande2,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            falar('Imagens. $textoGrande3');
                          },
                          icon: const Icon(Icons.record_voice_over)),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Imagens',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          textoGrande3,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black)),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          onPressed: () {
                            falar('Utilidades. $textoGrande4');
                          },
                          icon: const Icon(Icons.record_voice_over)),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Utilidades',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          textoGrande4,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      AppController.instance.mudaTutorial1();
                    });
                  },
                  child: const Text('Ok')),
            )
          ],
        ),
      ),
    );
  }
}
