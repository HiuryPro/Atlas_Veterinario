import 'package:atlas_veterinario/Utils/app_controller.dart';
import 'package:flutter/material.dart';

class Tutorial1 extends StatefulWidget {
  const Tutorial1({super.key});

  @override
  State<Tutorial1> createState() => _Tutorial1State();
}

class _Tutorial1State extends State<Tutorial1> {
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
            const Center(
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Ajuda',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
              ),
            ),
            const Center(
              child: Card(
                color: Colors.white,
                child: Column(
                  children: [
                    Center(
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
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'Para navegar pelas páginas, você pode executar a ação de deslizar o dedo '
                          'pela tela. Deslizar o dedo para a esquerda permitirá avançar para a próxima '
                          'página, enquanto deslizar o dedo para a direita o levará de volta à página '
                          'anterior. Alternativamente, você também pode utilizar o gesto de duplo clique '
                          'na parte esquerda ou direita da tela para efetuar a troca de página. '
                          'Outra opção para navegação é clicar no pequeno triângulo localizado na parte inferior da página. '
                          'Ao fazer isso, você abrirá um menu que apresentará diversas opções para avançar ou retroceder '
                          'nas páginas, oferecendo uma experiência de leitura mais flexível e intuitiva.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'Para navegar entre as páginas de conteúdo, você pode deslizar o dedo pela tela. '
                          'No entanto, é importante notar que essa ação não é aplicável em telas com imagens, '
                          'uma vez que o gesto de deslizar é utilizado para interagir com as imagens.',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Center(
              child: Card(
                color: Colors.white,
                child: Column(
                  children: [
                    Center(
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
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'Para as telas que contêm imagens, você tem a opção de realizar '
                          'zoom e arrastar as imagens para uma visualização mais detalhada. Junto ao nome '
                          'da imagem, há um ícone que, quando clicado, permite a rotação da imagem para diferentes '
                          'orientações. Adicionalmente, logo abaixo da imagem, você encontrará um menu suspenso '
                          '(dropdown) que, ao ser clicado, exibe os nomes das estruturas presentes na peça em questão. '
                          'Ao selecionar um nome específico no menu suspenso, o número associado àquela estrutura será '
                          'destacado, facilitando a identificação e referência das partes da imagem',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Center(
              child: Card(
                color: Colors.white,
                child: Column(
                  children: [
                    Center(
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
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'No canto superior direito há um menu que ao ser clicado apresenta '
                          'opções de alteração de texto e tema do app',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Center(
                        child: Text(
                          'No canto superior esquerdo há uma imagem da logo do UNIPAM que ao ser clicado apresenta '
                          'o menu lateral do app com mais opções',
                          style: TextStyle(fontSize: 18),
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
