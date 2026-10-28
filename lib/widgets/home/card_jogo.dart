// WIDGET DA HOME: card vertical usado na lista horizontal de "Lançamentos".
import 'package:flutter/material.dart';
import '../../models/jogo.dart';
import '../cores.dart';
import '../imagens.dart';
import '../textview.dart';

class CardJogo extends StatelessWidget {
  Jogo jogo;
  final void Function() onClick;

  CardJogo(this.jogo, {super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Cores.fundoCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SuaImagem(caminhoArquivo: jogo.imagem, altura: 105, largura: 150),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Textview(jogo.titulo, negrito: true, maxLinhas: 1),
                  Textview(jogo.genero,
                      cor: Cores.textoSecundario, tamanho: 12, maxLinhas: 1),
                  const SizedBox(height: 4),
                  // Linha com preco (esquerda) e nota (direita)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Textview(jogo.precoFormatado,
                          cor: Cores.destaque, tamanho: 12, negrito: true),
                      Textview('★ ${jogo.nota}', cor: Colors.amber, tamanho: 12),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
