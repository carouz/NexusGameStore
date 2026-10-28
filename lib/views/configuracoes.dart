// VIEW: configuracoes (RF12). As preferencias sao salvas no SQLite.
// Os efeitos reais (notificacoes, downloads) sao ilustrativos - secao 4.1 da documentacao.
import 'package:flutter/material.dart';
import '../controllers/configuracao_controller.dart';
import '../controllers/sessao.dart';
import '../controllers/usuario_controller.dart';
import '../widgets/buttons.dart';
import '../widgets/cores.dart';
import '../widgets/item_opcao.dart';
import '../widgets/mensagem.dart';
import '../widgets/textview.dart';
import 'login.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  // Guarda o valor atual de cada preferencia (chave -> true/false).
  final Map<String, bool> _prefs = {};

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  // Le cada preferencia do banco.
  Future<void> _carregar() async {
    for (final chave in ConfiguracaoController.padroes.keys) {
      _prefs[chave] = await ConfiguracaoController.ler(chave);
    }
    if (!mounted) return;
    setState(() {});
  }

  // Salva no banco e atualiza o Switch.
  Future<void> _alterar(String chave, bool valor) async {
    await ConfiguracaoController.salvar(chave, valor);
    if (!mounted) return;
    setState(() {
      _prefs[chave] = valor;
    });
    mostrarMensagem(context, 'Preferência atualizada');
  }

  // Linha com titulo, subtitulo e um Switch (liga/desliga).
  Widget _linhaSwitch(String titulo, String subtitulo, String chave) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Cores.fundoCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Textview(titulo, negrito: true),
                Textview(subtitulo, cor: Cores.textoSecundario, tamanho: 12),
              ],
            ),
          ),
          Switch(
            value: _prefs[chave] ?? true,
            activeTrackColor: Cores.primaria,
            onChanged: (valor) => _alterar(chave, valor),
          ),
        ],
      ),
    );
  }

  // Titulo de grupo de configuracoes.
  Widget _grupo(String texto) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      child: Textview(texto, cor: Cores.primariaClara, negrito: true, tamanho: 13),
    );
  }

  // Janela (dialog) com os dados da conta.
  void _mostrarDadosConta() {
    final usuario = Sessao.usuarioLogado!;
    showDialog(
      context: context,
      builder: (contextoDialogo) => AlertDialog(
        title: const Text('Dados da Conta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nome: ${usuario.nome}'),
            const SizedBox(height: 6),
            Text('E-mail: ${usuario.email}'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _sair() {
    UsuarioController.sair();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (rota) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      appBar: AppBar(title: const Text('Configurações')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            _grupo('CONTA & SEGURANÇA'),
            ItemOpcao(Icons.person, 'Dados da Conta', 'Nome e e-mail cadastrados',
                onClick: _mostrarDadosConta),

            _grupo('NOTIFICAÇÕES'),
            _linhaSwitch('Alertas de Lançamentos', 'Receber avisos de jogos desejados',
                'alertas_lancamentos'),
            _linhaSwitch('Ofertas & Promoções', 'Notificar descontos nos favoritos', 'ofertas'),

            _grupo('DOWNLOADS & SISTEMA'),
            _linhaSwitch('Download automático', 'Apenas em redes Wi-Fi', 'download_wifi'),
            ItemOpcao(Icons.cleaning_services, 'Limpar Cache do App', 'Ilustrativo',
                onClick: () => mostrarMensagem(context, 'Cache limpo! (ilustrativo)')),

            const SizedBox(height: 16),
            Buttons('SAIR DA CONTA', cor: Cores.perigo, onClick: _sair),
          ],
        ),
      ),
    );
  }
}
