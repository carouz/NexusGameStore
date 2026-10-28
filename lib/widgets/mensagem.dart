// Funcao auxiliar: mostra uma mensagem curta no rodape (RNF05 - retorno claro ao usuario).
import 'package:flutter/material.dart';

void mostrarMensagem(BuildContext context, String texto) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(texto), duration: const Duration(seconds: 2)),
  );
}
