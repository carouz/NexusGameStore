// VIEW: carrinho de compras (RF07) e finalizacao da compra simulada (RF08, RN01, RN04).
import 'package:flutter/material.dart';
import '../controllers/compra_controller.dart';
import '../widgets/buttons.dart';
import '../widgets/cores.dart';
import '../widgets/item_carrinho.dart';
import '../widgets/mensagem.dart';
import '../widgets/textview.dart';

class Carrinho extends StatefulWidget {
  const Carrinho({super.key});

  @override
  State<Carrinho> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  // RN04: pede confirmacao antes de registrar a compra.
  Future<void> _finalizar() async {
    // showDialog devolve true/false conforme o botao escolhido.
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) => AlertDialog(
        title: const Text('Confirmar compra'),
        content: Text(
          'Finalizar a compra simulada de ${CompraController.totalFormatado}? '
          'Nenhuma cobrança real será feita.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    if (confirmou != true) return; // cancelou

    // Grava a compra no SQLite e limpa o carrinho.
    final erro = await CompraController.finalizarCompra();
    if (!mounted) return;
    if (erro != null) {
      mostrarMensagem(context, erro);
      return;
    }
    mostrarMensagem(context, 'Compra simulada concluída! Jogos adicionados à biblioteca.');
    Navigator.pop(context); // volta para a tela anterior
  }

  @override
  Widget build(BuildContext context) {
    final itens = CompraController.carrinho;

    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(title: const Text('Carrinho de Compras')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            // Expanded: a lista ocupa todo o espaco entre o topo e o total
            Expanded(
              flex: 1,
              child: itens.isEmpty
                  ? Center(
                      child: Textview('Seu carrinho está vazio.', cor: Cores.textoSecundario),
                    )
                  : ListView(
                      children: itens
                          .map((jogo) => ItemCarrinho(
                                jogo,
                                onRemover: () {
                                  // setState redesenha a lista sem o item removido
                                  setState(() {
                                    CompraController.removerDoCarrinho(jogo);
                                  });
                                },
                              ))
                          .toList(),
                    ),
            ),
            // ---- Total e botao finalizar ----
            Container(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Textview('Total', tamanho: 18, negrito: true),
                      Textview(CompraController.totalFormatado,
                          tamanho: 18, negrito: true, cor: Cores.destaque),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Row + Expanded para o botao ocupar a largura toda
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Buttons('FINALIZAR COMPRA', onClick: _finalizar),
                      ),
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
