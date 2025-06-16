// lib/tela_sobre.dart
import 'package:flutter/material.dart';

class TelaSobre extends StatelessWidget {
  const TelaSobre({super.key});

  @override
  Widget build(BuildContext context) {
    // Definindo a cor roxa que você está usando
    const Color azulPrincipal = Color.fromRGBO(56, 28, 185, 1);

    // Definindo o tamanho do ícone para facilitar a leitura e ajuste
    const double iconSize = 54;
    const double iconPadding = 15; // Padding dentro do círculo branco do ícone
    // O tamanho total do círculo branco (largura/altura) é iconSize + (2 * iconPadding)
    const double totalIconContainerSize = iconSize + (2 * iconPadding);

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
      body: Stack( // <<< O corpo principal agora é um Stack
        children: [
          // 1. Camada de Fundo (Parte Roxa e Branca Sólida)
          Column(
            children: [
              // Parte superior roxa
              Expanded(
                flex: 1, // Pode ajustar este flex para controlar o espaço roxo
                child: Container(color: azulPrincipal),
              ),
              // Parte inferior branca (servirá de fundo para o conteúdo)
              Expanded(
                flex: 4, // Pode ajustar este flex para controlar o espaço branco
                child: Container(color: Colors.white),
              ),
            ],
          ),

          // 2. Container Branco com o Conteúdo do "Sobre"
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            bottom: 0, // O container branco ocupa o resto da tela abaixo do 'top'
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
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  // Para centralizar o conteúdo do Column, use MainAxisAlignment.center se necessário
                  // ou confie no textAlign dos Text widgets.
                  // Removi crossAxisAlignment.center do Column para não interferir com textAlign.
                  children: [
                    // Espaço para o ícone sobreposto.
                    // Este SizedBox empurra o conteúdo para baixo, para que o ícone não o cubra.
                    // A altura deve ser a metade da altura total do container do ícone + uma margem.
                    SizedBox(height: (totalIconContainerSize / 2) + 20), // 20px de margem
                    const Text(
                      'SOBRE O GASTOSGOV',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: azulPrincipal,
                      ),
                      textAlign: TextAlign.center, // <<< Alinha o título ao centro
                    ),
                    const SizedBox(height: 20),
                    // Primeiro parágrafo
                    const Text.rich(
                      TextSpan(
                        text: 'O ',
                        style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.5),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'GastosGov',
                            style: TextStyle(fontWeight: FontWeight.bold, color: azulPrincipal),
                          ),
                          TextSpan(
                            text:
                                ' é um app que facilita o acesso dos cidadãos às informações públicas de ',
                          ),
                          TextSpan(
                            text: 'gastos governamentais.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start, // <<< Alinha o parágrafo ao início
                    ),
                    const SizedBox(height: 20),
                    // Segundo parágrafo
                    const Text.rich(
                      TextSpan(
                        text: 'Os dados são oficiais e provenientes da ',
                        style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.5),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'plataforma ComprasGov.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: azulPrincipal, // Cor roxa para o link
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start, // <<< Alinha o parágrafo ao início
                    ),
                    const SizedBox(height: 20),
                    // Terceiro parágrafo
                    const Text(
                      'A proposta é fortalecer o controle social e a transparência pública, tornando a informação acessível para todos.',
                      style: TextStyle(fontSize: 18, color: Colors.black87, height: 1.5),
                      textAlign: TextAlign.start, // <<< Alinha o parágrafo ao início
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),

          // 3. O Ícone Circular (Sobreposto)
          Positioned(
            // O 'top' é o ponto de partida do container branco menos metade da altura total do círculo do ícone.
            // Isso faz com que a metade inferior do ícone fique dentro do container branco.
            top: MediaQuery.of(context).size.height * 0.15 - (totalIconContainerSize / 2),
            // Centraliza horizontalmente o ícone
            left: MediaQuery.of(context).size.width / 2 - (totalIconContainerSize / 2),
            child: Container(
              padding: const EdgeInsets.all(iconPadding), // Usa a constante de padding
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/icon.png', // Seu ícone
                width: iconSize, // Usa a constante de tamanho
                height: iconSize, // Usa a constante de tamanho
              ),
            ),
          ),
        ],
      ),
    );
  }
}