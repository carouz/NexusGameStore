// DATABASE: abre o SQLite, cria as tabelas (secao 5.2 da documentacao)
// e popula o catalogo demonstrativo de jogos.
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/jogo.dart';

class BancoDados {
  // Guarda a conexao aberta para reaproveitar (padrao "singleton").
  static Database? _banco;

  // Getter assincrono: "Future" + "async", igual ao exemplo do QrCode (slide 09).
  // Quem chamar usa: final db = await BancoDados.instancia;
  static Future<Database> get instancia async {
    _banco ??= await _abrir(); // so abre se ainda nao estiver aberto
    return _banco!; // "!" garante que nao e nulo (null safety - slide 01)
  }

  // Abre (ou cria) o arquivo nexus_game_store.db no armazenamento do app.
  static Future<Database> _abrir() async {
    final caminho = join(await getDatabasesPath(), 'nexus_game_store.db');
    return openDatabase(
      caminho,
      version: 1,
      // Liga as chaves estrangeiras (FOREIGN KEY) do SQLite.
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      // onCreate roda UMA vez, quando o arquivo do banco ainda nao existe.
      onCreate: _criarTabelas,
    );
  }

  static Future<void> _criarTabelas(Database db, int versao) async {
    // RF01/RF02: contas locais. Email e UNIQUE para nao repetir cadastro.
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha_hash TEXT NOT NULL
      )
    ''');

    // RF03/RF05: catalogo de jogos.
    await db.execute('''
      CREATE TABLE jogos (
        id INTEGER PRIMARY KEY,
        titulo TEXT NOT NULL,
        categoria TEXT NOT NULL,
        genero TEXT NOT NULL,
        estudio TEXT NOT NULL,
        plataformas TEXT NOT NULL,
        descricao TEXT NOT NULL,
        preco REAL NOT NULL,
        imagem TEXT NOT NULL,
        nota REAL NOT NULL,
        destaque INTEGER NOT NULL DEFAULT 0,
        lancamento INTEGER NOT NULL DEFAULT 0,
        mais_vendido INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // RF06 / RN02: a chave primaria composta impede favorito duplicado.
    await db.execute('''
      CREATE TABLE favoritos (
        usuario_id INTEGER NOT NULL,
        jogo_id INTEGER NOT NULL,
        PRIMARY KEY (usuario_id, jogo_id),
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
        FOREIGN KEY (jogo_id) REFERENCES jogos (id)
      )
    ''');

    // RF08: cabecalho de cada compra simulada (RN01: sem cobranca real).
    await db.execute('''
      CREATE TABLE compras (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        data TEXT NOT NULL,
        total REAL NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
      )
    ''');

    // RF09: jogos de cada compra (alimentam a biblioteca - RN05).
    await db.execute('''
      CREATE TABLE itens_compra (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        compra_id INTEGER NOT NULL,
        jogo_id INTEGER NOT NULL,
        preco_unitario REAL NOT NULL,
        FOREIGN KEY (compra_id) REFERENCES compras (id),
        FOREIGN KEY (jogo_id) REFERENCES jogos (id)
      )
    ''');

    // RF12: preferencias da tela de configuracoes (uma linha por usuario/chave).
    await db.execute('''
      CREATE TABLE configuracoes (
        usuario_id INTEGER NOT NULL,
        chave TEXT NOT NULL,
        valor INTEGER NOT NULL,
        PRIMARY KEY (usuario_id, chave)
      )
    ''');

    // Insere o catalogo inicial.
    for (final jogo in _catalogoInicial()) {
      await db.insert('jogos', jogo.toMap());
    }
  }

  // Monta uma URL de imagem no mesmo padrao do prototipo HTML.
  static String _foto(String codigo) =>
      'https://images.unsplash.com/$codigo?q=80&w=800&auto=format&fit=crop';

  // Jogos demonstrativos (dados retirados do prototipo prototipo.html).
  static List<Jogo> _catalogoInicial() {
    return [
      Jogo(
        id: 1,
        titulo: 'Chrono Odyssey',
        categoria: 'Ação & RPG',
        genero: 'RPG Ação',
        estudio: 'Chrono Studio / Kakao Games',
        plataformas: 'PS5 / PC',
        descricao:
            'Embarque em uma jornada épica através do tempo e do espaço no continente de Setera. '
            'Lute contra deuses e monstros reescrevendo a linha temporal com o artefato Chrono.',
        preco: 249.90,
        imagem: _foto('photo-1542751371-adc38448a05e'),
        nota: 4.9,
        destaque: true,
        lancamento: true,
        maisVendido: false,
      ),
      Jogo(
        id: 2,
        titulo: 'Forza Horizon Apex',
        categoria: 'Corrida',
        genero: 'Corrida',
        estudio: 'Apex Racing Labs',
        plataformas: 'Xbox / PC',
        descricao:
            'Corridas em mundo aberto com clima dinâmico, centenas de carros e eventos '
            'sazonais para correr com os amigos.',
        preco: 299.00,
        imagem: _foto('photo-1511512578047-dfb367046420'),
        nota: 4.8,
        destaque: false,
        lancamento: true,
        maisVendido: false,
      ),
      Jogo(
        id: 3,
        titulo: 'Cyber Neon 2088',
        categoria: 'Ação & RPG',
        genero: 'Ficção Científica',
        estudio: 'Neon Forge',
        plataformas: 'PS5 / PC',
        descricao:
            'Em uma metrópole iluminada por neon, escolha entre hackear, lutar ou negociar '
            'para sobreviver a corporações que controlam tudo.',
        preco: 189.90,
        imagem: _foto('photo-1538481199705-c710c4e965fc'),
        nota: 4.7,
        destaque: false,
        lancamento: true,
        maisVendido: false,
      ),
      Jogo(
        id: 4,
        titulo: 'Elden Ring: Shadows',
        categoria: 'Ação & RPG',
        genero: 'Ação / Souls',
        estudio: 'Shadow Works',
        plataformas: 'PS5 / Xbox / PC',
        descricao:
            'Explore terras sombrias, enfrente chefes desafiadores e descubra segredos '
            'escondidos em cada canto deste RPG de ação.',
        preco: 199.50,
        imagem: _foto('photo-1518709268805-4e9042af9f23'),
        nota: 4.9,
        destaque: false,
        lancamento: false,
        maisVendido: true,
      ),
      Jogo(
        id: 5,
        titulo: 'Pixel Quest: Legends',
        categoria: 'Indie',
        genero: 'Aventura Indie',
        estudio: 'Pixel Pirates',
        plataformas: 'PC / Switch',
        descricao:
            'Uma aventura retrô em pixel art com puzzles, masmorras e uma trilha sonora '
            'inesquecível.',
        preco: 59.90,
        imagem: _foto('photo-1550745165-9bc0b252726f'),
        nota: 4.6,
        destaque: false,
        lancamento: false,
        maisVendido: true,
      ),
      Jogo(
        id: 6,
        titulo: 'Mystic Isles',
        categoria: 'Aventura',
        genero: 'Aventura',
        estudio: 'Isle Games',
        plataformas: 'PC / PS5',
        descricao:
            'Navegue por ilhas misteriosas, resolva enigmas antigos e descubra o segredo '
            'do arquipélago esquecido. (Jogo fictício para demonstração.)',
        preco: 129.90,
        imagem: _foto('photo-1550745165-9bc0b252726f'),
        nota: 4.5,
        destaque: false,
        lancamento: false,
        maisVendido: false,
      ),
    ];
  }
}
