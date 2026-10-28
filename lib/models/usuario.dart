// MODEL: representa uma linha da tabela "usuarios".
// Nos slides (aula 01 - Classes) os atributos podem ser nulos usando "?".
class Usuario {
  int? id; // "?" = pode ser nulo (ainda nao foi gravado no banco)
  String nome;
  String email;
  String senhaHash; // nunca guardamos a senha pura (RNF06)

  // Construtor da classe (mesma ideia do construtor do widget Buttons)
  Usuario({this.id, required this.nome, required this.email, required this.senhaHash});

  // Converte o objeto em Map para o SQLite gravar (chave = nome da coluna)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha_hash': senhaHash,
    };
  }

  // Faz o caminho contrario: transforma a linha do banco em objeto Usuario
  factory Usuario.fromMap(Map<String, dynamic> mapa) {
    return Usuario(
      id: mapa['id'] as int?,
      nome: mapa['nome'] as String,
      email: mapa['email'] as String,
      senhaHash: mapa['senha_hash'] as String,
    );
  }
}
