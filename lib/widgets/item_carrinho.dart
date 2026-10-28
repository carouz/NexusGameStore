// WIDGET: linha de um jogo dentro do carrinho (RF07).
import 'package:flutter/material.dart';
import '../models/jogo.dart';
import 'cores.dart';
import 'imagens.dart';
import 'textview.dart';

class ItemCarrinho extends StatelessWidget {
  Jogo jogo;
  final void Function() onRemover;

  ItemCarrinho(this.jogo, {super.key, required this.onRemover});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Cores.fundoCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SuaImagem(caminhoArquivo: jogo.imagem, altura: 60, largura: 60),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Textview(jogo.titulo, negrito: true, maxLinhas: 1),
                Textview(jogo.precoFormatado, cor: Cores.destaque),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemover,
            icon: const Icon(Icons.delete_outline, color: Cores.perigo),
          ),
        ],
      ),
    );
  }
}
