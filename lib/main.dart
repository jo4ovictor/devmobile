import 'package:flutter/material.dart';
import 'package:devmobile/tela-sobre.dart';
import 'package:devmobile/tela-buscar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GastosGov App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GastosGovScreen(),
    );
  }
}

class GastosGovScreen extends StatelessWidget {
  const GastosGovScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(56, 28, 185, 1), // Cor de fundo roxa escura
      body: Column(
        children: [
          // Espaço superior (para a barra de status e um pouco mais)
          const Expanded(flex: 2, child: SizedBox.shrink()),
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'GASTOSGOV',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(54, 41, 183, 1), // Cor do texto principal
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text.rich(
                          TextSpan(
                              text: 'Acompanhe os ',
                              style: TextStyle(fontSize: 18, color: Colors.black87),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'gastos públicos do Brasil',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(text: ' de forma fácil!'),
                              ],
                            ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            // Ação do botão "ACESSAR APP"
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TelaBuscar()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(54, 41, 183, 1), // Cor do botão
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 15),
                          ),
                          child: const Text(
                            'ACESSAR APP',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            // Ação do link "Sobre o App"
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TelaSobre()),
                            );
                          },
                          child: const Text(
                            'Sobre o App',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(148, 139, 188, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Logo do Governo Federal
                    Image.asset(
                      'assets/brasil_logo.png', // Certifique-se de ter esta imagem em sua pasta 'assets'
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}