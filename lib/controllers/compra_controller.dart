// CONTROLLER: carrinho, compra simulada e biblioteca (RF07, RF08, RF09).
import '../database/banco_dados.dart';
import '../models/jogo.dart';
import 'sessao.dart';

class CompraController {
  // O carrinho fica so na memoria (a documentacao permite essa decisao - secao 5.2).
  static final List<Jogo> carrinho = [];

  // Soma o preco de todos os jogos do carrinho.
  static double get total => carrinho.fold(0.0, (soma, jogo) => soma + jogo.preco);

  // Formata o total no padrao brasileiro.
  static String get totalFormatado => 'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}';

  // Verifica se o usuario ja comprou o jogo (ele esta na biblioteca).
  static Future<bool> possuiJogo(int jogoId) async {
    final db = await BancoDados.instancia;
    final linhas = await db.rawQuery('''
      SELECT i.id FROM itens_compra i
      INNER JOIN compras c ON c.id = i.compra_id
      WHERE c.usuario_id = ? AND i.jogo_id = ?
    ''', [Sessao.usuarioId, jogoId]);
    return linhas.isNotEmpty;
  }

  // RF07: adiciona ao carrinho. Retorna a mensagem para a tela exibir.
  static Future<String> adicionarAoCarrinho(Jogo jogo) async {
    if (await possuiJogo(jogo.id)) return 'Você já possui este jogo na biblioteca.';
    if (carrinho.any((item) => item.id == jogo.id)) return 'Este jogo já está no carrinho.';
    carrinho.add(jogo);
    return '${jogo.titulo} adicionado ao carrinho.';
  }

  // RF07: remove do carrinho.
  static void removerDoCarrinho(Jogo jogo) {
    carrinho.removeWhere((item) => item.id == jogo.id);
  }

  // RF08 / RN04: grava a compra e os itens e depois limpa o carrinho.
  // Retorna null se deu certo, ou o texto do erro.
  static Future<String?> finalizarCompra() async {
    if (carrinho.isEmpty) return 'Seu carrinho está vazio.';

    final db = await BancoDados.instancia;
    // transaction: ou grava tudo, ou nao grava nada.
    await db.transaction((txn) async {
      final compraId = await txn.insert('compras', {
        'usuario_id': Sessao.usuarioId,
        'data': DateTime.now().toIso8601String(),
        'total': total,
      });
      for (final jogo in carrinho) {
        await txn.insert('itens_compra', {
          'compra_id': compraId,
          'jogo_id': jogo.id,
          'preco_unitario': jogo.preco,
        });
      }
    });

    carrinho.clear(); // RN04
    return null;
  }

  // RF09: jogos comprados pelo usuario (nao representa instalacao real - RN05).
  static Future<List<Jogo>> listarBiblioteca() async {
    final db = await BancoDados.instancia;
    final linhas = await db.rawQuery('''
      SELECT j.* FROM jogos j
      INNER JOIN itens_compra i ON i.jogo_id = j.id
      INNER JOIN compras c ON c.id = i.compra_id
      WHERE c.usuario_id = ?
      GROUP BY j.id
      ORDER BY MAX(c.data) DESC
    ''', [Sessao.usuarioId]);
    return linhas.map((linha) => Jogo.fromMap(linha)).toList();
  }

  // Quantidade de compras do usuario (usado na tela de perfil).
  static Future<int> contarCompras() async {
    final db = await BancoDados.instancia;
    final linhas = await db.rawQuery(
      'SELECT COUNT(*) AS total FROM compras WHERE usuario_id = ?',
      [Sessao.usuarioId],
    );
    return (linhas.first['total'] as int?) ?? 0;
  }
}
