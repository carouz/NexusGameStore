// WIDGET: item da aba "Favoritos" (imagem + dados + remover + comprar).
import 'package:flutter/material.dart';
import '../models/jogo.dart';
import 'cores.dart';
import 'imagens.dart';
import 'textview.dart';

class CardFavorito extends StatelessWidget {
  Jogo jogo;
  final void Function() onAbrir; // abre a tela de detalhes
  final void Function() onRemover; // tira dos favoritos
  final void Function() onComprar; // coloca no carrinho

  CardFavorito(this.jogo,
      {super.key, required this.onAbrir, required this.onRemover, required this.onComprar});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Cores.fundoCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: onAbrir,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SuaImagem(caminhoArquivo: jogo.imagem, altura: 80, largura: 80),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Textview(jogo.titulo, negrito: true, maxLinhas: 1),
                Textview(jogo.genero, cor: Cores.textoSecundario, tamanho: 12),
                Textview(jogo.precoFormatado, cor: Cores.destaque, negrito: true),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              IconButton(
                onPressed: onRemover,
                icon: const Icon(Icons.favorite, color: Cores.perigo),
              ),
              IconButton(
                onPressed: onComprar,
                icon: const Icon(Icons.add_shopping_cart, color: Cores.primariaClara),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
