import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Utils/IconButtonVoice.dart';
import 'package:atlas_veterinario/Utils/app_controller.dart';
import 'package:atlas_veterinario/Utils/utils.dart';
import 'package:flutter/material.dart';

class Tutorial1 extends StatefulWidget {
  const Tutorial1({super.key});

  @override
  State<Tutorial1> createState() => _Tutorial1State();
}

class _Tutorial1State extends State<Tutorial1> {
  Utils util = Utils();
  bool isFalando = false;

  String textoGrande =
      'Para navegar pelas páginas, você pode executar a ação de deslizar o dedo '
      'pela tela. Deslizar o dedo para a esquerda permitirá avançar para a próxima '
      'página, enquanto deslizar o dedo para a direita o levará de volta à página '
      'anterior. Alternativamente, você também pode utilizar as setas que estão '
      'na parte esquerda e direita da tela para efetuar a troca de página. '
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
      'o menu lateral do app com mais opções. Ao lado do icone do Unipam tem um icone de Interrogação '
      'que ao ser clicado ou leva a tela de ajuda (Tela atual).';

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
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () async {
                  await fechaTutorial();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black)),
                child: const Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButtonVoice(
                          cor: Colors.black,
                          fala:
                              'Ajuda. Observação: Clique no Icone de fala para ouvir o que está escrito. Clique novamente para parar. Para escutar outra fala espere ou cancele a atual.'),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Ajuda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Color(0xff1a4d34)),
                        ),
                      ),
                    ),
                    Wrap(
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
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Para escutar outra fala espere ou cancele a atual.',
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
                      child: IconButtonVoice(
                          cor: Colors.black,
                          fala:
                              'Passagem de páginas. $textoGrande $textoGrande2'),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Passagem de páginas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Color(0xff1a4d34)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          textoGrande,
                          style: const TextStyle(
                              fontSize: 20, color: Color(0xff1a4d34)),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          textoGrande2,
                          style: const TextStyle(
                              fontSize: 20, color: Color(0xff1a4d34)),
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
                      child: IconButtonVoice(
                          cor: Colors.black, fala: 'Imagens. $textoGrande3'),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Imagens',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Color(0xff1a4d34)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          textoGrande3,
                          style: const TextStyle(
                              fontSize: 20, color: Color(0xff1a4d34)),
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
                      child: IconButtonVoice(
                          cor: Colors.black, fala: 'Utilidades. $textoGrande4'),
                    ),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          'Utilidades',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Color(0xff1a4d34)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          textoGrande4,
                          style: const TextStyle(
                              fontSize: 20, color: Color(0xff1a4d34)),
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
                  onPressed: () async {
                    await fechaTutorial();
                  },
                  child: const Text('Ok')),
            )
          ],
        ),
      ),
    );
  }

  fechaTutorial() async {
    if (AppController.instance.isFirstTime) {
      await SupaDB.instance.clienteSupaBase
          .from('Usuario')
          .update({'IsFirstTime': false}).match(
              {'Email': AppController.instance.email});
      setState(() {
        AppController.instance.isFirstTime = false;
        AppController.instance.mudaTutorial1();
      });
    }
    setState(() {
      AppController.instance.mudaTutorial1();
    });
  }
}
