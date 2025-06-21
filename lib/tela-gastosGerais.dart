// lib/tela_gastos_gerais.dart
import 'package:flutter/material.dart';

class TelaGastosGerais extends StatefulWidget {
  const TelaGastosGerais({super.key});

  @override
  State<TelaGastosGerais> createState() => _TelaGastosGeraisState();
}

class _TelaGastosGeraisState extends State<TelaGastosGerais> {
  // Cores
  static const Color azulPrincipal = Color.fromRGBO(56, 28, 185, 1);
  static const Color cinzaClaroCampo = Color(0xFFF0F0F0); // Cor de fundo dos campos

  // Valores selecionados para os Dropdowns
  String? _estadoSelecionado;
  String? _municipioSelecionado;
  String? _orgaoSelecionado;
  String? _periodoSelecionado;

  // Controladores para os campos de valor (Texto)
  final TextEditingController _valorMinimoController = TextEditingController();
  final TextEditingController _valorMaximoController = TextEditingController();

  // Opções para os Dropdowns
  final List<String> _opcoesEstado = ['Selecione o estado', 'AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MG', 'MS', 'MT', 'PA', 'PB', 'PE', 'PI', 'PR', 'RJ', 'RN', 'RO', 'RR', 'RS', 'SC', 'SE', 'SP', 'TO']; // Exemplo
  final List<String> _opcoesMunicipio = ['Selecione o município', 'Porto Velho', 'Rio Branco', 'Manaus']; // Exemplo
  final List<String> _opcoesOrgao = ['Selecione o órgão', 'Órgão A', 'Órgão B', 'Órgão C']; // Exemplo
  final List<String> _opcoesPeriodo = ['Selecione o período', 'Últimos 7 dias', 'Últimos 30 dias', 'Este mês', 'Este ano']; // Exemplo

  @override
  void dispose() {
    _valorMinimoController.dispose();
    _valorMaximoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Buscar', // Conforme a imagem
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: azulPrincipal), // Ícone de lupa
            onPressed: () {
              // Ação do ícone de busca
              print('Ícone de busca clicado!');
            },
          ),
        ],
      ),
      body: Column( // Esta é a Column principal do body
        children: [
          // Espaço roxo acima do container branco (flex 0 para ser mínimo)
          Expanded(
            flex: 0,
            child: Container(color: azulPrincipal),
          ),
          // Container branco com o formulário
          Expanded(
            flex: 7, // Ajuste para a altura do container branco
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
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Estica os campos
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'GASTOS GERAIS', // Título da tela
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: azulPrincipal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Preencha os campos abaixo',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Campo Estado
                    _buildDropdownField(
                      label: 'Estado',
                      value: _estadoSelecionado,
                      items: _opcoesEstado,
                      onChanged: (newValue) {
                        setState(() {
                          _estadoSelecionado = newValue;
                        });
                      },
                      hintText: 'Selecione o estado',
                    ),
                    const SizedBox(height: 20),

                    // Campo Município
                    _buildDropdownField(
                      label: 'Município',
                      value: _municipioSelecionado,
                      items: _opcoesMunicipio,
                      onChanged: (newValue) {
                        setState(() {
                          _municipioSelecionado = newValue;
                        });
                      },
                      hintText: 'Selecione o município',
                    ),
                    const SizedBox(height: 20),

                    // Campo Órgão
                    _buildDropdownField(
                      label: 'Órgão',
                      value: _orgaoSelecionado,
                      items: _opcoesOrgao,
                      onChanged: (newValue) {
                        setState(() {
                          _orgaoSelecionado = newValue;
                        });
                      },
                      hintText: 'Selecione o órgão',
                    ),
                    const SizedBox(height: 20),

                    // Campo Período
                    _buildDropdownField(
                      label: 'Período',
                      value: _periodoSelecionado,
                      items: _opcoesPeriodo,
                      onChanged: (newValue) {
                        setState(() {
                          _periodoSelecionado = newValue;
                        });
                      },
                      hintText: 'Selecione o período',
                    ),
                    const SizedBox(height: 20),

                    // Campos Valor Mínimo e Valor Máximo
                    Row(
                      children: [
                        Expanded(
                          child: _buildValueField(
                            label: 'Valor Mínimo',
                            controller: _valorMinimoController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildValueField(
                            label: 'Valor Máximo',
                            controller: _valorMaximoController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Texto de confirmação
                    const Center(
                      child: Text(
                        'Confirme se os dados antes de prosseguir',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                  
                    // Botão BUSCAR (fora do SingleChildScrollView, diretamente no Column pai)
                    ElevatedButton(
                      onPressed: () {
                        // Ação do botão BUSCAR
                        print('Botão BUSCAR clicado na tela de Gastos Gerais!');
                        print('Estado: $_estadoSelecionado');
                        print('Município: $_municipioSelecionado');
                        print('Órgão: $_orgaoSelecionado');
                        print('Período: $_periodoSelecionado');
                        print('Valor Mínimo: ${_valorMinimoController.text}');
                        print('Valor Máximo: ${_valorMaximoController.text}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulPrincipal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        'BUSCAR',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  
                    const SizedBox(height: 20), // Espaço no final
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para construir um campo Dropdown (reutilizado)
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cinzaClaroCampo,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down, color: azulPrincipal),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item == hintText ? null : item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: item == hintText ? Colors.grey : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              hint: Text(
                hintText ?? label,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Novo Widget auxiliar para construir um campo de Valor (R$)
  Widget _buildValueField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cinzaClaroCampo,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number, // Teclado numérico
            decoration: InputDecoration(
              hintText: 'R\$', // Hint R$
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none, // Remove a borda padrão do TextField
              suffixIcon: IconButton( // Ícones de seta para cima e para baixo
                icon: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.keyboard_arrow_up, size: 20, color: azulPrincipal),
                    Icon(Icons.keyboard_arrow_down, size: 20, color: azulPrincipal),
                  ],
                ),
                onPressed: () {
                  // Ação para aumentar/diminuir o valor, se desejado
                },
              ),
            ),
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}