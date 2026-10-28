// WIDGET: item da aba "Biblioteca" (jogo comprado). O botao JOGAR e ilustrativo (RN05).
import 'package:flutter/material.dart';
import '../models/jogo.dart';
import 'buttons.dart';
import 'cores.dart';
import 'imagens.dart';
import 'textview.dart';

class CardBiblioteca extends StatelessWidget {
  Jogo jogo;
  final void Function() onJogar;

  CardBiblioteca(this.jogo, {super.key, required this.onJogar});

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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SuaImagem(caminhoArquivo: jogo.imagem, altura: 70, largura: 70),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Textview(jogo.titulo, negrito: true, maxLinhas: 1),
                Textview('Adquirido (compra simulada)',
                    cor: Cores.textoSecundario, tamanho: 12),
              ],
            ),
          ),
          Buttons('JOGAR', onClick: onJogar),
        ],
      ),
    );
  }
}
