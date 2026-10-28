// WIDGET reutilizavel: campo de texto (mesma ideia da classe Input do Simulado).
import 'package:flutter/material.dart';
import 'cores.dart';

class Input extends StatelessWidget {
  String hint; // aparece dentro do input
  String label; // texto flutuante do input (vazio = sem label)
  TextEditingController controller; // para pegar o texto digitado
  bool senha; // true = esconde os caracteres (campo de senha)
  void Function(String)? onChanged; // executado a cada letra digitada (usado na busca)

  Input(this.label, this.hint,
      {super.key, required this.controller, this.senha = false, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: senha,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label.isEmpty ? null : label,
        hintStyle: const TextStyle(color: Cores.textoSecundario),
        labelStyle: const TextStyle(color: Cores.primariaClara),
        filled: true,
        fillColor: Cores.fundoCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
