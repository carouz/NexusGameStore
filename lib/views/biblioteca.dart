// VIEW: biblioteca do usuario (RF09) e favoritos (RF06).
// Duas abas controladas por uma variavel (_aba): 0 = Biblioteca | 1 = Favoritos.
import 'package:flutter/material.dart';
import '../controllers/compra_controller.dart';
import '../controllers/favorito_controller.dart';
import '../models/jogo.dart';
import '../widgets/buttons.dart';
import '../widgets/card_biblioteca.dart';
import '../widgets/card_favorito.dart';
import '../widgets/cores.dart';
import '../widgets/mensagem.dart';
import '../widgets/textview.dart';
import 'detalhes.dart';

class Biblioteca extends StatefulWidget {
  final int abaInicial; // 0 = Biblioteca, 1 = Favoritos
  const Biblioteca({super.key, this.abaInicial = 0});

  @override
  State<Biblioteca> createState() => _BibliotecaState();
}

class _BibliotecaState extends State<Biblioteca> {
  int _aba = 0;
  List<Jogo> _biblioteca = [];
  List<Jogo> _favoritos = [];

  @override
  void initState() {
    super.initState();
    _aba = widget.abaInicial;
    _carregar();
  }

  // Le as duas listas do banco.
  Future<void> _carregar() async {
    final biblioteca = await CompraController.listarBiblioteca();
    final favoritos = await FavoritoController.listar();
    if (!mounted) return;
    setState(() {
      _biblioteca = biblioteca;
      _favoritos = favoritos;
    });
  }

  Future<void> _removerFavorito(Jogo jogo) async {
    await FavoritoController.alternar(jogo.id);
    _carregar();
  }

  Future<void> _comprar(Jogo jogo) async {
    final mensagem = await CompraController.adicionarAoCarrinho(jogo);
    if (!mounted) return;
    mostrarMensagem(context, mensagem);
  }

  Future<void> _abrirDetalhes(Jogo jogo) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => DetalhesJogo(jogo)));
    _carregar(); // ao voltar, atualiza (o jogo pode ter sido desfavoritado/comprado)
  }

  // Mensagem exibida quando a lista esta vazia.
  Widget _vazio(IconData icone, String titulo, String texto) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: <Widget>[
          Icon(icone, size: 56, color: Cores.primariaClara),
          const SizedBox(height: 12),
          Textview(titulo, tamanho: 18, negrito: true),
          const SizedBox(height: 6),
          Textview(texto, cor: Cores.textoSecundario),
        ],
      ),
    );
  }

  // Conteudo da aba "Biblioteca".
  List<Widget> _listaBiblioteca() {
    if (_biblioteca.isEmpty) {
      return <Widget>[
        _vazio(Icons.video_library_outlined, 'Biblioteca vazia',
            'Os jogos comprados aparecem aqui.'),
      ];
    }
    return _biblioteca
        .map((jogo) => CardBiblioteca(
              jogo,
              // Botao JOGAR e apenas ilustrativo (RN05: nao ha instalacao real)
              onJogar: () => mostrarMensagem(context, 'Iniciando ${jogo.titulo}... (ilustrativo)'),
            ))
        .toList();
  }

  // Conteudo da aba "Favoritos".
  List<Widget> _listaFavoritos() {
    if (_favoritos.isEmpty) {
      return <Widget>[
        _vazio(Icons.favorite_border, 'Nenhum favorito aqui',
            'Adicione jogos à sua lista de desejos para acompanhá-los.'),
      ];
    }
    return _favoritos
        .map((jogo) => CardFavorito(
              jogo,
              onAbrir: () => _abrirDetalhes(jogo),
              onRemover: () => _removerFavorito(jogo),
              onComprar: () => _comprar(jogo),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(title: const Text('Sua Biblioteca')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            // ---- Abas (Row + Expanded) ----
            Row(
              children: <Widget>[
                Expanded(
                  child: Buttons(
                    'Biblioteca (${_biblioteca.length})',
                    cor: _aba == 0 ? Cores.primaria : Cores.fundoCard,
                    onClick: () => setState(() => _aba = 0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Buttons(
                    'Favoritos (${_favoritos.length})',
                    cor: _aba == 1 ? Cores.primaria : Cores.fundoCard,
                    onClick: () => setState(() => _aba = 1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Expanded + ListView: a lista rola ocupando o resto da tela
            Expanded(
              child: ListView(
                children: _aba == 0 ? _listaBiblioteca() : _listaFavoritos(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
