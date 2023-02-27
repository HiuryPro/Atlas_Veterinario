import 'dart:math';

void main() {
  var random = Random();
  String codigo = '';
  for (int i = 0; i < 6; i++) {
    var randomNumber =
        random.nextInt(10); // gera um número aleatório entre 0 e 9
    codigo += randomNumber.toString();
  }
  print(codigo);
}
