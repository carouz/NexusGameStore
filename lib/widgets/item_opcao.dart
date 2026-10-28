// WIDGET: linha de opcao (icone + titulo + subtitulo + seta). Usada em Perfil e Configuracoes.
import 'package:flutter/material.dart';
import 'cores.dart';
import 'textview.dart';

class ItemOpcao extends StatelessWidget {
  IconData icone;
  String titulo;
  String subtitulo;
  final void Function() onClick;

  ItemOpcao(this.icone, this.titulo, this.subtitulo, {super.key, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick, // detecta o toque na linha inteira
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Cores.fundoCard,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: <Widget>[
            Icon(icone, color: Cores.primariaClara),
            const SizedBox(width: 14),
            // Expanded faz a coluna ocupar o espaco que sobrou na linha
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Textview(titulo, negrito: true),
                  Textview(subtitulo, cor: Cores.textoSecundario, tamanho: 12),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Cores.textoSecundario),
          ],
        ),
      ),
    );
  }
}
