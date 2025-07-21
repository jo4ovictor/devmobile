import 'package:flutter/material.dart';

import 'package:devmobile/tela-comprasSemLicitacao.dart';
import 'package:devmobile/tela-ataPreco.dart';
import 'package:devmobile/tela-licitacoes.dart';
import 'package:devmobile/tela-fornecedores.dart';


class TelaBuscar extends StatelessWidget {
  const TelaBuscar({super.key});

  // Definindo a cor roxa principal que você está usando
  static const Color azulPrincipal = Color.fromRGBO(56, 28, 185, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulPrincipal, // Cor de fundo roxa escura
      appBar: AppBar(
        backgroundColor: azulPrincipal, // Cor da AppBar
        elevation: 0, // Remove a sombra
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Volta para a tela anterior
          },
        ),
        title: const Text(
          'Inicial', // Texto "Inicial" como na imagem
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Espaço roxo na parte superior
          Expanded(
            flex: 1, // Ajuste este flex para controlar a altura da parte roxa visível
            child: Container(color: azulPrincipal),
          ),
          // Container branco arredondado para os cards
          Expanded(
            flex: 6, // Ajuste este flex para controlar a altura da parte branca
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildOptionCard(
                      context,
                      title: 'Buscar Compras Sem Licitação',
                      subtitle: 'Explorar gastos em compras sem licitação',      
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaComprasSemLicitacao()));
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildOptionCard(
                      context,
                      title: 'Ata de Registro de Preços',
                      subtitle: 'Explorar atas de registro de preços',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaAtaRegistroPrecos()));
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildOptionCard(
                      context,
                      title: 'Licitações',
                      subtitle: 'Explorar licitações',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaLicitacoes()));
                        
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildOptionCard(
                      context,
                      title: 'Fornecedores',
                      subtitle: 'Explorar fornecedores',
                      
                      onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const TelaFornecedores()));
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, {required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 0, // Remove a sombra padrão do Card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white, // Uma cor cinza claro para o card
      child: InkWell( // Permite o efeito de toque (ripple effect)
        borderRadius: BorderRadius.circular(15.0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função de placeholder para as telas futuras
  void _showPlaceholderScreen(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: azulPrincipal,
          ),
          body: Center(
            child: Text(
              'Esta é a tela de "$title"\nEm construção...',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}