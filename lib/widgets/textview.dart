// WIDGET reutilizavel: texto padrao (mesma ideia da classe Textview do Simulado).
import 'package:flutter/material.dart';

class Textview extends StatelessWidget {
  String texto;
  Color cor; // cor da letra
  double tamanho; // tamanho da fonte
  bool negrito;
  int? maxLinhas; // se informado, corta o texto com "..."

  // atributos opcionais ficam entre chaves e ja tem valor padrao
  Textview(this.texto,
      {super.key,
      this.cor = Colors.white,
      this.tamanho = 14,
      this.negrito = false,
      this.maxLinhas});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      maxLines: maxLinhas,
      overflow: maxLinhas == null ? null : TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: tamanho,
        color: cor,
        fontWeight: negrito ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
