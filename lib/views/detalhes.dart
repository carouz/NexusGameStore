// VIEW: detalhes do jogo (RF05) com favoritar (RF06) e carrinho (RF07).
// O jogo chega pelo CONSTRUTOR (passagem de valores entre telas - slide 06).
import 'package:flutter/material.dart';
import '../controllers/compra_controller.dart';
import '../controllers/favorito_controller.dart';
import '../models/jogo.dart';
import '../widgets/buttons.dart';
import '../widgets/cores.dart';
import '../widgets/imagens.dart';
import '../widgets/mensagem.dart';
import '../widgets/textview.dart';
import 'carrinho.dart';

class DetalhesJogo extends StatefulWidget {
  final Jogo jogo; // parametro recebido da tela anterior
  const DetalhesJogo(this.jogo, {super.key});

  @override
  State<DetalhesJogo> createState() => _DetalhesJogoState();
}

class _DetalhesJogoState extends State<DetalhesJogo> {
  bool _favorito = false; // o coracao do AppBar fica cheio ou vazio
  bool _possui = false; // true = o jogo ja esta na biblioteca

  // Imagens ilustrativas da secao "Capturas de Tela" (as mesmas do prototipo).
  final List<String> _capturas = [
    'https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=300&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=300&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?q=80&w=300&auto=format&fit=crop',
  ];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  // Consulta no banco se o jogo e favorito e se ja foi comprado.
  Future<void> _carregar() async {
    final favorito = await FavoritoController.ehFavorito(widget.jogo.id);
    final possui = await CompraController.possuiJogo(widget.jogo.id);
    if (!mounted) return;
    setState(() {
      _favorito = favorito;
      _possui = possui;
    });
  }

  Future<void> _alternarFavorito() async {
    final agoraEFavorito = await FavoritoController.alternar(widget.jogo.id);
    if (!mounted) return;
    setState(() {
      _favorito = agoraEFavorito;
    });
    mostrarMensagem(
      context,
      agoraEFavorito ? 'Adicionado aos favoritos.' : 'Removido dos favoritos.',
    );
  }

  Future<void> _adicionarAoCarrinho() async {
    final mensagem = await CompraController.adicionarAoCarrinho(widget.jogo);
    if (!mounted) return;
    mostrarMensagem(context, mensagem);
  }

  // "COMPRAR AGORA": coloca no carrinho e abre a tela do carrinho.
  Future<void> _comprarAgora() async {
    final mensagem = await CompraController.adicionarAoCarrinho(widget.jogo);
    if (!mounted) return;
    final noCarrinho = CompraController.carrinho.any((item) => item.id == widget.jogo.id);
    if (!noCarrinho) {
      mostrarMensagem(context, mensagem); // ex.: "voce ja possui este jogo"
      return;
    }
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const Carrinho()));
    _carregar(); // se comprou, atualiza o estado "ja possui"
  }

  // Pequena "etiqueta" (plataforma, nota...).
  Widget _etiqueta(String texto) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Cores.fundoCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Textview(texto, tamanho: 12, cor: Cores.primariaClara),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jogo = widget.jogo; // atalho: "widget" acessa o parametro do construtor

    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(
        title: Text(jogo.titulo),
        actions: <Widget>[
          // IconButton dentro do AppBar (slide 06)
          IconButton(
            onPressed: _alternarFavorito,
            icon: Icon(
              _favorito ? Icons.favorite : Icons.favorite_border,
              color: _favorito ? Cores.perigo : Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            SuaImagem(caminhoArquivo: jogo.imagem, altura: 220, largura: double.infinity),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // ---- Etiquetas ----
                  Row(
                    children: <Widget>[
                      _etiqueta(jogo.plataformas),
                      _etiqueta('★ ${jogo.nota}'),
                      _etiqueta(jogo.categoria),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Textview(jogo.titulo, tamanho: 26, negrito: true),
                  Textview(jogo.estudio, cor: Cores.textoSecundario),
                  const SizedBox(height: 16),

                  // ---- Preco ----
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Cores.fundoCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Textview('Preço do jogo (demonstrativo)',
                            cor: Cores.textoSecundario, tamanho: 12),
                        Textview(jogo.precoFormatado,
                            cor: Cores.destaque, tamanho: 26, negrito: true),
                        const SizedBox(height: 10),
                        // Se ja comprou mostra um aviso; senao mostra os botoes.
                        if (_possui)
                          Textview('✔ Este jogo já está na sua biblioteca',
                              cor: Cores.primariaClara, negrito: true)
                        else
                          Row(
                            children: <Widget>[
                              // flex: define a proporcao de largura entre os botoes (1 : 2)
                              Expanded(
                                flex: 1,
                                child: Buttons(
                                  'Carrinho',
                                  cor: Cores.fundoEscuro,
                                  onClick: _adicionarAoCarrinho,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: Buttons('COMPRAR AGORA', onClick: _comprarAgora),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ---- Descricao ----
                  Textview('Sobre o Jogo', tamanho: 18, negrito: true),
                  const SizedBox(height: 6),
                  Textview(jogo.descricao, cor: Cores.textoSecundario),
                  const SizedBox(height: 16),

                  // ---- Capturas de tela (lista horizontal) ----
                  Textview('Capturas de Tela', tamanho: 18, negrito: true),
                  const SizedBox(height: 8),
                  Container(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _capturas
                          .map((url) => Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SuaImagem(caminhoArquivo: url, altura: 110, largura: 170),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
