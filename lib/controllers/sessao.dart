// CONTROLLER: guarda quem esta logado enquanto o app esta aberto (RN03).
import '../models/usuario.dart';

class Sessao {
  // "static" = existe uma unica vez e pode ser lido de qualquer tela.
  static Usuario? usuarioLogado;

  // Atalho para o id do usuario (as telas so abrem depois do login).
  static int get usuarioId => usuarioLogado!.id!;

  static bool get logado => usuarioLogado != null;
}
