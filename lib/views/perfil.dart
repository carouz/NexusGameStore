// VIEW: perfil do usuario (RF10) e encerramento de sessao (RF11).
import 'package:flutter/material.dart';
import '../controllers/compra_controller.dart';
import '../controllers/favorito_controller.dart';
import '../controllers/sessao.dart';
import '../controllers/usuario_controller.dart';
import '../widgets/buttons.dart';
import '../widgets/cores.dart';
import '../widgets/item_opcao.dart';
import '../widgets/mensagem.dart';
import '../widgets/textview.dart';
import 'biblioteca.dart';
import 'carrinho.dart';
import 'configuracoes.dart';
import 'login.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  int _qtdBiblioteca = 0;
  int _qtdFavoritos = 0;
  int _qtdCompras = 0;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  // As estatisticas agora sao REAIS (no prototipo eram ilustrativas).
  Future<void> _carregar() async {
    final biblioteca = await CompraController.listarBiblioteca();
    final favoritos = await FavoritoController.listar();
    final compras = await CompraController.contarCompras();
    if (!mounted) return;
    setState(() {
      _qtdBiblioteca = biblioteca.length;
      _qtdFavoritos = favoritos.length;
      _qtdCompras = compras;
    });
  }

  Future<void> _abreOutraTela(Widget pagina) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => pagina));
    _carregar();
  }

  // RF11: encerra a sessao e volta ao login, limpando as telas anteriores da pilha.
  void _sair() {
    UsuarioController.sair();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (rota) => false, // false = remove todas as rotas anteriores
    );
  }

  // Bloco de numero + legenda (usado nas estatisticas).
  Widget _estatistica(String valor, String legenda) {
    return Column(
      children: <Widget>[
        Textview(valor, tamanho: 22, negrito: true, cor: Cores.destaque),
        Textview(legenda, tamanho: 12, cor: Cores.textoSecundario),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Sessao.usuarioLogado!;
    // Primeira letra do nome para o "avatar".
    final inicial = usuario.nome.trim().isEmpty ? '?' : usuario.nome.trim()[0].toUpperCase();

    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            // ---- Avatar + dados ----
            Column(
              children: <Widget>[
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Cores.primaria,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Textview(inicial, tamanho: 38, negrito: true)),
                ),
                const SizedBox(height: 10),
                Textview(usuario.nome, tamanho: 22, negrito: true),
                Textview(usuario.email, cor: Cores.textoSecundario),
              ],
            ),
            const SizedBox(height: 16),

            // ---- Estatisticas (Row + Expanded com mesmo flex) ----
            Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Cores.fundoCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(flex: 1, child: _estatistica('$_qtdBiblioteca', 'Jogos')),
                  Expanded(flex: 1, child: _estatistica('$_qtdFavoritos', 'Favoritos')),
                  Expanded(flex: 1, child: _estatistica('$_qtdCompras', 'Compras')),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ---- Opcoes ----
            ItemOpcao(
              Icons.video_library,
              'Minha Biblioteca',
              '$_qtdBiblioteca jogos adquiridos',
              onClick: () => _abreOutraTela(const Biblioteca()),
            ),
            ItemOpcao(
              Icons.favorite,
              'Meus Favoritos',
              '$_qtdFavoritos jogos favoritados',
              onClick: () => _abreOutraTela(const Biblioteca(abaInicial: 1)),
            ),
            ItemOpcao(
              Icons.shopping_cart,
              'Carrinho',
              '${CompraController.carrinho.length} itens no carrinho',
              onClick: () => _abreOutraTela(const Carrinho()),
            ),
            ItemOpcao(
              Icons.receipt_long,
              'Histórico de Compras',
              '$_qtdCompras compras simuladas realizadas',
              onClick: () => mostrarMensagem(context, 'Tela de histórico: funcionalidade futura.'),
            ),
            ItemOpcao(
              Icons.settings,
              'Configurações',
              'Conta, Notificações, Armazenamento',
              onClick: () => _abreOutraTela(const Configuracoes()),
            ),
            const SizedBox(height: 8),
            Buttons('SAIR DA CONTA', cor: Cores.perigo, onClick: _sair),
          ],
        ),
      ),
    );
  }
}
