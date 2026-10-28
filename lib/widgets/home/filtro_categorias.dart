// WIDGET DA HOME: filtros de categoria (lista horizontal de botoes).
import 'package:flutter/material.dart';
import '../buttons.dart';
import '../cores.dart';

class FiltroCategorias extends StatelessWidget {
  String categoriaAtual; // categoria selecionada no momento
  final void Function(String) onSelecionar; // devolve a categoria clicada

  // Lista fixa de categorias (iguais as do prototipo e as da tabela jogos)
  final List<String> categorias = ['Todos', 'Ação & RPG', 'Corrida', 'Aventura', 'Indie'];

  FiltroCategorias(this.categoriaAtual, {super.key, required this.onSelecionar});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // ListView horizontal precisa de altura definida
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categorias.map((categoria) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: Buttons(
              categoria,
              // O botao selecionado fica na cor primaria; os demais ficam escuros
              cor: categoria == categoriaAtual ? Cores.primaria : Cores.fundoCard,
              onClick: () => onSelecionar(categoria),
            ),
          );
        }).toList(),
      ),
    );
  }
}
