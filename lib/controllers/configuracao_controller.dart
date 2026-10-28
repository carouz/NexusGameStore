// CONTROLLER: preferencias da tela de configuracoes (RF12).
import 'package:sqflite/sqflite.dart';
import '../database/banco_dados.dart';
import 'sessao.dart';

class ConfiguracaoController {
  // Valor padrao de cada preferencia (quando ainda nao foi salva).
  static const Map<String, bool> padroes = {
    'alertas_lancamentos': true,
    'ofertas': true,
    'download_wifi': true,
  };

  // Le uma preferencia do usuario logado.
  static Future<bool> ler(String chave) async {
    final db = await BancoDados.instancia;
    final linhas = await db.query(
      'configuracoes',
      where: 'usuario_id = ? AND chave = ?',
      whereArgs: [Sessao.usuarioId, chave],
    );
    if (linhas.isEmpty) return padroes[chave] ?? false;
    return linhas.first['valor'] == 1;
  }

  // Salva (ou substitui) uma preferencia.
  static Future<void> salvar(String chave, bool valor) async {
    final db = await BancoDados.instancia;
    await db.insert(
      'configuracoes',
      {'usuario_id': Sessao.usuarioId, 'chave': chave, 'valor': valor ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
