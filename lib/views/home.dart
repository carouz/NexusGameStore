// VIEW: tela inicial / catalogo (RF03 listar e RF04 pesquisar).
// Estrutura: cabecalho + banner + filtros + secoes (ListView) + barra inferior.
import 'package:flutter/material.dart';
import '../controllers/compra_controller.dart';
import '../controllers/jogo_controller.dart';
import '../controllers/sessao.dart';
import '../models/jogo.dart';
import '../widgets/cores.dart';
import '../widgets/home/banner_destaque.dart';
import '../widgets/home/barra_inferior.dart';
import '../widgets/home/card_jogo.dart';
import '../widgets/home/filtro_categorias.dart';
import '../widgets/home/item_jogo_lista.dart';
import '../widgets/mensagem.dart';
import '../widgets/textview.dart';
import 'biblioteca.dart';
import 'carrinho.dart';
import 'detalhes.dart';
import 'perfil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Jogo> _jogos = []; // jogos que o banco devolveu (ja filtrados)
  String _categoria = 'Todos'; // filtro de categoria selecionado
  final TextEditingController _busca = TextEditingController(); // texto da pesquisa

  @override
  void initState() {
    super.initState();
    _carregar(); // busca os jogos assim que a tela abre
  }

  @override
  void dispose() {
    _busca.dispose();
    super.dispose();
  }

  // Busca no SQLite aplicando a pesquisa e a categoria atuais.
  Future<void> _carregar() async {
    final lista = await JogoController.listar(busca: _busca.text, categoria: _categoria);
    if (!mounted) return;
    setState(() {
      _jogos = lista; // setState redesenha a tela com a nova lista
    });
  }

  // Abre outra tela (Navigator.push - slide 06) e, ao voltar, atualiza o contador do carrinho.
  Future<void> _abreOutraTela(Widget pagina) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => pagina));
    if (!mounted) return;
    setState(() {});
  }

  // Adiciona ao carrinho e mostra o resultado (RF07).
  Future<void> _adicionarAoCarrinho(Jogo jogo) async {
    final mensagem = await CompraController.adicionarAoCarrinho(jogo);
    if (!mounted) return;
    setState(() {}); // atualiza o numero ao lado do icone do carrinho
    mostrarMensagem(context, mensagem);
  }

  // Titulo de cada secao.
  Widget _titulo(String texto) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 8),
      child: Textview(texto, tamanho: 18, negrito: true),
    );
  }

  // Linha do topo: saudacao (esquerda) + notificacoes e carrinho (direita).
  Widget _cabecalho() {
    return Row(
      children: <Widget>[
        // Expanded: a saudacao ocupa o espaco que sobra
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Textview('Bem-vindo de volta', cor: Cores.textoSecundario, tamanho: 12),
              Textview(Sessao.usuarioLogado!.nome, tamanho: 20, negrito: true, maxLinhas: 1),
            ],
          ),
        ),
        IconButton(
          onPressed: () => mostrarMensagem(context, 'Sem notificações no momento'),
          icon: const Icon(Icons.notifications_none, color: Colors.white),
        ),
        IconButton(
          onPressed: () => _abreOutraTela(const Carrinho()),
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        ),
        // Quantidade de itens no carrinho
        Textview('${CompraController.carrinho.length}', cor: Cores.destaque, negrito: true),
      ],
    );
  }

  // Secoes padrao da Home (quando NAO ha pesquisa nem filtro).
  List<Widget> _secoes(List<Jogo> lancamentos, List<Jogo> maisVendidos) {
    return <Widget>[
      _titulo('Lançamentos'),
      // Lista HORIZONTAL: precisa de uma altura fixa dentro de um Container.
      Container(
        height: 200,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: lancamentos
              .map((jogo) => CardJogo(jogo, onClick: () => _abreOutraTela(DetalhesJogo(jogo))))
              .toList(),
        ),
      ),
      _titulo('Mais Vendidos'),
      // Coluna normal: a lista vertical de fora (ListView do build) faz a rolagem.
      Column(
        children: maisVendidos
            .map((jogo) => ItemJogoLista(
                  jogo,
                  onClick: () => _abreOutraTela(DetalhesJogo(jogo)),
                  onAdicionar: () => _adicionarAoCarrinho(jogo),
                ))
            .toList(),
      ),
    ];
  }

  // Resultado quando ha pesquisa ou categoria selecionada.
  List<Widget> _resultados() {
    if (_jogos.isEmpty) {
      return <Widget>[
        Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Textview('Nenhum jogo encontrado.', cor: Cores.textoSecundario),
          ),
        ),
      ];
    }
    return <Widget>[
      _titulo('Resultados'),
      Column(
        children: _jogos
            .map((jogo) => ItemJogoLista(
                  jogo,
                  onClick: () => _abreOutraTela(DetalhesJogo(jogo)),
                  onAdicionar: () => _adicionarAoCarrinho(jogo),
                ))
            .toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Separa a lista do banco nas secoes da tela.
    final destaques = _jogos.where((jogo) => jogo.destaque).toList();
    final lancamentos = _jogos.where((jogo) => jogo.lancamento).toList();
    final maisVendidos = _jogos.where((jogo) => jogo.maisVendido).toList();
    final bool filtrando = _busca.text.trim().isNotEmpty || _categoria != 'Todos';

    return Scaffold(
      backgroundColor: Cores.fundo,
      body: SafeArea(
        child: Container(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              _cabecalho(),
              // Banner so aparece sem filtro/pesquisa.
              if (!filtrando && destaques.isNotEmpty)
                BannerDestaque(
                  destaques.first,
                  onClick: () => _abreOutraTela(DetalhesJogo(destaques.first)),
                ),
              FiltroCategorias(
                _categoria,
                onSelecionar: (categoria) {
                  // setState destaca o botao na hora; depois _carregar busca no banco
                  setState(() {
                    _categoria = categoria;
                  });
                  _carregar();
                },
              ),
              // Com filtro mostra "Resultados"; sem filtro mostra as secoes.
              if (filtrando) ..._resultados() else ..._secoes(lancamentos, maisVendidos),
            ],
          ),
        ),
      ),
      // Barra inferior: biblioteca | pesquisa | perfil (como no prototipo)
      bottomNavigationBar: BarraInferior(
        controller: _busca,
        onBuscar: (texto) => _carregar(),
        onBiblioteca: () => _abreOutraTela(const Biblioteca()),
        onPerfil: () => _abreOutraTela(const Perfil()),
      ),
    );
  }
}
