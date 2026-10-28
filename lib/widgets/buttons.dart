// WIDGET reutilizavel: botao padrao do app (mesma ideia da classe Buttons do Simulado).
import 'package:flutter/material.dart';
import 'cores.dart';

class Buttons extends StatelessWidget {
  String texto; // texto exibido dentro do botao
  final void Function() onClick; // funcao executada ao clicar (funcao como parametro - slide 01)
  Color? cor; // cor de fundo opcional

  // Construtor: o texto e posicional e o onClick e nomeado/obrigatorio.
  Buttons(this.texto, {super.key, required this.onClick, this.cor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: cor ?? Cores.primaria, // "??" = valor padrao se for nulo
        foregroundColor: Colors.white,
      ),
      onPressed: onClick,
      child: Text(texto),
    );
  }
}
