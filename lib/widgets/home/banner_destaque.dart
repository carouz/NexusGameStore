// WIDGET DA HOME: banner "Destaque da Semana" (imagem em cima, dados embaixo).
import 'package:flutter/material.dart';
import '../../models/jogo.dart';
import '../buttons.dart';
import '../cores.dart';
import '../imagens.dart';
import '../textview.dart';

class BannerDestaque extends StatelessWidget {
  Jogo jogo;
  final void Function() onClick;

  BannerDestaque(this.jogo, {super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias, // corta a imagem nas bordas arredondadas
        decoration: BoxDecoration(
          color: Cores.fundoCard,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SuaImagem(caminhoArquivo: jogo.imagem, altura: 170, largura: double.infinity),
            Container(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Textview('DESTAQUE DA SEMANA',
                      cor: Cores.destaque, tamanho: 11, negrito: true),
                  Textview(jogo.titulo, tamanho: 22, negrito: true),
                  Textview(jogo.descricao,
                      cor: Cores.textoSecundario, tamanho: 12, maxLinhas: 2),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Textview(jogo.precoFormatado,
                          cor: Cores.destaque, tamanho: 18, negrito: true),
                      Buttons('Ver mais', onClick: onClick),
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
