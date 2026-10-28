// CONTROLLER: favoritos do usuario (RF06 e RN02).
import 'package:sqflite/sqflite.dart';
import '../database/banco_dados.dart';
import '../models/jogo.dart';
import 'sessao.dart';

class FavoritoController {
  // Verifica se o jogo ja esta nos favoritos do usuario logado.
  static Future<bool> ehFavorito(int jogoId) async {
    final db = await BancoDados.instancia;
    final linhas = await db.query(
      'favoritos',
      where: 'usuario_id = ? AND jogo_id = ?',
      whereArgs: [Sessao.usuarioId, jogoId],
    );
    return linhas.isNotEmpty;
  }

  // Adiciona se nao existe e remove se ja existe. Retorna o novo estado.
  static Future<bool> alternar(int jogoId) async {
    final db = await BancoDados.instancia;
    if (await ehFavorito(jogoId)) {
      await db.delete(
        'favoritos',
        where: 'usuario_id = ? AND jogo_id = ?',
        whereArgs: [Sessao.usuarioId, jogoId],
      );
      return false;
    }
    // "ignore": se por algum motivo ja existir, nao duplica (RN02).
    await db.insert(
      'favoritos',
      {'usuario_id': Sessao.usuarioId, 'jogo_id': jogoId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    return true;
  }

  // Lista os jogos favoritos (JOIN entre favoritos e jogos).
  static Future<List<Jogo>> listar() async {
    final db = await BancoDados.instancia;
    final linhas = await db.rawQuery('''
      SELECT j.* FROM jogos j
      INNER JOIN favoritos f ON f.jogo_id = j.id
      WHERE f.usuario_id = ?
      ORDER BY j.titulo
    ''', [Sessao.usuarioId]);
    return linhas.map((linha) => Jogo.fromMap(linha)).toList();
  }
}
