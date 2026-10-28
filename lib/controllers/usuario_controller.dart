// CONTROLLER: regras de cadastro, login e logout (RF01, RF02, RF11, RNF06).
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import '../database/banco_dados.dart';
import '../models/usuario.dart';
import 'compra_controller.dart';
import 'sessao.dart';

class UsuarioController {
  // Gera um "sal" aleatorio para que senhas iguais gerem hashes diferentes.
  static String _gerarSal() {
    final aleatorio = Random.secure();
    final bytes = List<int>.generate(16, (_) => aleatorio.nextInt(256));
    return base64Url.encode(bytes);
  }

  // SHA-256 de (sal + senha). Nunca guardamos a senha em texto simples.
  static String _calcularHash(String senha, String sal) {
    return sha256.convert(utf8.encode(sal + senha)).toString();
  }

  // RF01: cadastra e ja deixa o usuario logado.
  // Retorna null se deu certo, ou o texto do erro para a tela mostrar.
  static Future<String?> cadastrar(String nome, String email, String senha) async {
    email = email.trim().toLowerCase();
    if (nome.trim().isEmpty) return 'Informe seu nome.';
    if (!email.contains('@')) return 'Informe um e-mail válido.';
    if (senha.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';

    final db = await BancoDados.instancia;

    // Verifica se o e-mail ja existe.
    final existente = await db.query('usuarios', where: 'email = ?', whereArgs: [email]);
    if (existente.isNotEmpty) return 'Este e-mail já está cadastrado.';

    // Guardamos "sal:hash" em uma unica coluna (senha_hash).
    final sal = _gerarSal();
    final hash = '$sal:${_calcularHash(senha, sal)}';
    final usuario = Usuario(nome: nome.trim(), email: email, senhaHash: hash);

    final id = await db.insert('usuarios', usuario.toMap());
    usuario.id = id;
    Sessao.usuarioLogado = usuario;
    return null;
  }

  // RF02: autenticacao local. Retorna null se deu certo, ou o texto do erro.
  static Future<String?> entrar(String email, String senha) async {
    email = email.trim().toLowerCase();
    if (email.isEmpty || senha.isEmpty) return 'Preencha e-mail e senha.';

    final db = await BancoDados.instancia;
    final linhas = await db.query('usuarios', where: 'email = ?', whereArgs: [email]);
    if (linhas.isEmpty) return 'E-mail ou senha incorretos.';

    final usuario = Usuario.fromMap(linhas.first);
    final partes = usuario.senhaHash.split(':'); // [sal, hash]
    if (_calcularHash(senha, partes[0]) != partes[1]) {
      return 'E-mail ou senha incorretos.';
    }

    Sessao.usuarioLogado = usuario;
    return null;
  }

  // RF11: encerra a sessao e esvazia o carrinho (que fica so na memoria).
  static void sair() {
    Sessao.usuarioLogado = null;
    CompraController.carrinho.clear();
  }
}
