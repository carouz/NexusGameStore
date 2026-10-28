// VIEW: tela de login e cadastro (RF01 e RF02).
import 'package:flutter/material.dart';
import '../controllers/usuario_controller.dart';
import '../widgets/buttons.dart';
import '../widgets/cores.dart';
import '../widgets/input.dart';
import '../widgets/textview.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _cadastro = false; // false = aba "Entrar" | true = aba "Cadastrar"
  bool _carregando = false; // evita clicar duas vezes enquanto consulta o banco
  String _erro = ''; // mensagem de erro exibida abaixo dos campos

  // Controllers: servem para pegar o texto digitado em cada Input (slide 05/Input).
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _senha = TextEditingController();

  @override
  void dispose() {
    // Libera a memoria dos controllers quando a tela e fechada.
    _nome.dispose();
    _email.dispose();
    _senha.dispose();
    super.dispose();
  }

  // Metodo assincrono (Future + async + await - slide 09): consulta o banco.
  Future<void> _enviar() async {
    setState(() {
      _erro = '';
      _carregando = true;
    });

    // O controller devolve null (sucesso) ou o texto do erro.
    final erro = _cadastro
        ? await UsuarioController.cadastrar(_nome.text, _email.text, _senha.text)
        : await UsuarioController.entrar(_email.text, _senha.text);

    if (!mounted) return; // se a tela foi fechada durante o await, para aqui
    setState(() {
      _carregando = false;
    });

    if (erro != null) {
      setState(() {
        _erro = erro;
      });
      return;
    }

    // Login ok: abre a Home e remove o Login da pilha (o botao "voltar" nao retorna).
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.fundo,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          // ListView em vez de Column para nao estourar quando o teclado abre.
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 24),
              // ---- Logo ----
              Column(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Cores.primaria,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.sports_esports, color: Colors.white, size: 44),
                  ),
                  const SizedBox(height: 12),
                  Textview('NEXUS', tamanho: 34, negrito: true),
                  Textview('Gameplay & Store', cor: Cores.textoSecundario),
                ],
              ),
              const SizedBox(height: 28),

              // ---- Abas Entrar / Cadastrar (Row + Expanded, como nos slides) ----
              Row(
                children: <Widget>[
                  Expanded(
                    child: Buttons(
                      'Entrar',
                      cor: _cadastro ? Cores.fundoCard : Cores.primaria,
                      onClick: () => setState(() {
                        _cadastro = false;
                        _erro = '';
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Buttons(
                      'Cadastrar',
                      cor: _cadastro ? Cores.primaria : Cores.fundoCard,
                      onClick: () => setState(() {
                        _cadastro = true;
                        _erro = '';
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ---- Campos ----
              // Collection-if: o campo "Nome" so aparece no cadastro.
              if (_cadastro) ...<Widget>[
                Input('Nome completo', 'Seu nome', controller: _nome),
                const SizedBox(height: 12),
              ],
              Input('E-mail', 'seu@email.com', controller: _email),
              const SizedBox(height: 12),
              Input('Senha', '••••••••', controller: _senha, senha: true),
              const SizedBox(height: 12),

              // Mensagem de erro (so aparece se houver erro)
              if (_erro.isNotEmpty) Textview(_erro, cor: Cores.perigo),
              const SizedBox(height: 12),

              _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : Buttons(_cadastro ? 'CRIAR CONTA' : 'ENTRAR NO APP', onClick: _enviar),
            ],
          ),
        ),
      ),
    );
  }
}
