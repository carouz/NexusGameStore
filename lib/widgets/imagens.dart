// WIDGET reutilizavel: imagem (mesma ideia da classe SuaImagem do Simulado).
// Aceita caminho de ASSET (imagens/foto.png) ou URL (https://...) do catalogo.
import 'package:flutter/material.dart';
import 'cores.dart';

class SuaImagem extends StatefulWidget {
  final String caminhoArquivo;
  final double? altura;
  final double? largura;
  const SuaImagem({Key? key, required this.caminhoArquivo, this.altura, this.largura})
      : super(key: key);

  @override
  State<SuaImagem> createState() => _SuaImagemState();
}

class _SuaImagemState extends State<SuaImagem> {
  // Exibido quando a imagem nao carrega (ex.: sem internet).
  Widget _semImagem() {
    return Container(
      height: widget.altura,
      width: widget.largura,
      color: Cores.fundoCard,
      child: const Center(
        child: Icon(Icons.videogame_asset, color: Cores.textoSecundario),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Se comeca com "http" vem da internet; senao e um arquivo da pasta assets.
    if (widget.caminhoArquivo.startsWith('http')) {
      return Image.network(
        widget.caminhoArquivo,
        fit: BoxFit.cover,
        height: widget.altura,
        width: widget.largura,
        errorBuilder: (context, erro, pilha) => _semImagem(),
      );
    }
    return Image.asset(
      widget.caminhoArquivo,
      fit: BoxFit.cover,
      height: widget.altura,
      width: widget.largura,
      errorBuilder: (context, erro, pilha) => _semImagem(),
    );
  }
}
