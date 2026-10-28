// WIDGET DA HOME: linha horizontal usada na secao "Mais Vendidos".
import 'package:flutter/material.dart';
import '../../models/jogo.dart';
import '../cores.dart';
import '../imagens.dart';
import '../textview.dart';

class ItemJogoLista extends StatelessWidget {
  Jogo jogo;
  final void Function() onClick; // abre os detalhes
  final void Function() onAdicionar; // adiciona ao carrinho

  ItemJogoLista(this.jogo, {super.key, required this.onClick, required this.onAdicionar});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Cores.fundoCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SuaImagem(caminhoArquivo: jogo.imagem, altura: 70, largura: 70),
            ),
            const SizedBox(width: 12),
            // Expanded: a coluna de textos ocupa todo o espaco livre da linha
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Textview(jogo.titulo, negrito: true, maxLinhas: 1),
                  Row(
                    children: <Widget>[
                      Textview('★ ${jogo.nota}', cor: Colors.amber, tamanho: 12),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Textview('• ${jogo.genero}',
                            cor: Cores.textoSecundario, tamanho: 12, maxLinhas: 1),
                      ),
                    ],
                  ),
                  Textview(jogo.precoFormatado, cor: Cores.destaque, negrito: true),
                ],
              ),
            ),
            IconButton(
              onPressed: onAdicionar,
              icon: const Icon(Icons.add_shopping_cart, color: Cores.primariaClara),
            ),
          ],
        ),
      ),
    );
  }
}
