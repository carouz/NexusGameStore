// MODEL: representa uma linha da tabela "jogos" (catalogo demonstrativo).
class Jogo {
  int id;
  String titulo;
  String categoria; // usada nos filtros da Home (Ação & RPG, Corrida...)
  String genero; // texto exibido embaixo do titulo (ex.: "RPG Ação")
  String estudio;
  String plataformas;
  String descricao;
  double preco;
  String imagem; // URL (http...) ou caminho de asset (imagens/xxx.png)
  double nota;
  bool destaque; // aparece no banner "Destaque da Semana"
  bool lancamento; // aparece na secao "Lançamentos"
  bool maisVendido; // aparece na secao "Mais Vendidos"

  Jogo({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.genero,
    required this.estudio,
    required this.plataformas,
    required this.descricao,
    required this.preco,
    required this.imagem,
    required this.nota,
    required this.destaque,
    required this.lancamento,
    required this.maisVendido,
  });

  // SQLite nao tem tipo booleano: gravamos 1 (true) ou 0 (false)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'categoria': categoria,
      'genero': genero,
      'estudio': estudio,
      'plataformas': plataformas,
      'descricao': descricao,
      'preco': preco,
      'imagem': imagem,
      'nota': nota,
      'destaque': destaque ? 1 : 0,
      'lancamento': lancamento ? 1 : 0,
      'mais_vendido': maisVendido ? 1 : 0,
    };
  }

  factory Jogo.fromMap(Map<String, dynamic> mapa) {
    return Jogo(
      id: mapa['id'] as int,
      titulo: mapa['titulo'] as String,
      categoria: mapa['categoria'] as String,
      genero: mapa['genero'] as String,
      estudio: mapa['estudio'] as String,
      plataformas: mapa['plataformas'] as String,
      descricao: mapa['descricao'] as String,
      preco: (mapa['preco'] as num).toDouble(),
      imagem: mapa['imagem'] as String,
      nota: (mapa['nota'] as num).toDouble(),
      destaque: (mapa['destaque'] as int) == 1,
      lancamento: (mapa['lancamento'] as int) == 1,
      maisVendido: (mapa['mais_vendido'] as int) == 1,
    );
  }

  // Formata o preco no padrao brasileiro: 249.9 -> "R$ 249,90"
  String get precoFormatado => 'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}';
}
