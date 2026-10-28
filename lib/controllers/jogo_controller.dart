// CONTROLLER: consultas ao catalogo (RF03 listar e RF04 pesquisar).
import '../database/banco_dados.dart';
import '../models/jogo.dart';

class JogoController {
  // Lista os jogos aplicando, se houver, busca por titulo e filtro de categoria.
  static Future<List<Jogo>> listar({String busca = '', String categoria = 'Todos'}) async {
    final db = await BancoDados.instancia;

    // Monta o WHERE conforme os filtros recebidos.
    final condicoes = <String>[];
    final argumentos = <Object?>[];
    if (busca.trim().isNotEmpty) {
      condicoes.add('titulo LIKE ?');
      argumentos.add('%${busca.trim()}%');
    }
    if (categoria != 'Todos') {
      condicoes.add('categoria = ?');
      argumentos.add(categoria);
    }

    final linhas = await db.query(
      'jogos',
      where: condicoes.isEmpty ? null : condicoes.join(' AND '),
      whereArgs: argumentos.isEmpty ? null : argumentos,
      orderBy: 'nota DESC',
    );
    // Converte cada linha (Map) em um objeto Jogo.
    return linhas.map((linha) => Jogo.fromMap(linha)).toList();
  }
}
