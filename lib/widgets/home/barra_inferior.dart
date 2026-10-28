// WIDGET DA HOME: barra inferior pedida no prototipo -> biblioteca (esquerda),
// campo de pesquisa (centro) e perfil (direita).
import 'package:flutter/material.dart';
import '../cores.dart';
import '../input.dart';

class BarraInferior extends StatelessWidget {
  TextEditingController controller; // le o texto da pesquisa
  final void Function(String) onBuscar;
  final void Function() onBiblioteca;
  final void Function() onPerfil;

  BarraInferior(
      {super.key,
      required this.controller,
      required this.onBuscar,
      required this.onBiblioteca,
      required this.onPerfil});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Cores.fundoEscuro,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: SafeArea(
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: onBiblioteca,
              icon: const Icon(Icons.video_library, color: Cores.primariaClara),
            ),
            // Expanded: a pesquisa ocupa todo o espaco entre os dois botoes
            Expanded(
              child: Input('', 'Buscar jogos...', controller: controller, onChanged: onBuscar),
            ),
            IconButton(
              onPressed: onPerfil,
              icon: const Icon(Icons.person, color: Cores.primariaClara),
            ),
          ],
        ),
      ),
    );
  }
}
