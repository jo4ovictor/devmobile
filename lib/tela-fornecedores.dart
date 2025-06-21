 // lib/tela_fornecedores.dart
import 'package:flutter/material.dart';

class TelaFornecedores extends StatefulWidget {
  const TelaFornecedores({super.key});

  @override
  State<TelaFornecedores> createState() => _TelaFornecedoresState();
}

class _TelaFornecedoresState extends State<TelaFornecedores> {
  // Cores
  static const Color azulPrincipal = Color.fromRGBO(56, 28, 185, 1);
  static const Color cinzaClaroCard = Color(0xFFF0F0F0); // Cor de fundo dos campos

  // Valores selecionados para os Dropdowns
  String? _paginaSelecionada;
  String? _tamanhoPaginaSelecionado;
  String? _naturezaJuridicaSelecionada;
  String? _porteEmpresaSelecionado;
  String? _codCNAESelecionado;
  String? _ativoSelecionado;

  // Controladores para os campos de texto (CNPJ, CPF)
  final TextEditingController _cnpjController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();

  // Opções para os Dropdowns
  final List<String> _opcoesPagina = ['1', '2', '3', '4', '5']; // Exemplo
  final List<String> _opcoesTamanhoPagina = ['10', '20', '50', '100']; // Exemplo
  final List<String> _opcoesNaturezaJuridica = ['Natureza Jurídica', 'Pessoa Física', 'Pessoa Jurídica', 'MEI']; // Exemplo
  final List<String> _opcoesPorteEmpresa = ['Porte Empresa', 'Pequena', 'Média', 'Grande']; // Exemplo
  final List<String> _opcoesCodCNAE = ['Cód. CNAE', '01.11-3-01', '01.12-2-01', '01.13-0-01']; // Exemplo
  final List<String> _opcoesAtivo = ['Sim/Não', 'Sim', 'Não']; // Exemplo

  @override
  void dispose() {
    _cnpjController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo roxo
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
            icon: const Icon(Icons.search, color: Colors.black87), // Ícone de lupa
            onPressed: () {
              // Ação do ícone de busca
              print('Ícone de busca clicado!');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Espaço roxo acima do container branco
          Expanded(
            flex: 0,
            child: Container(color: azulPrincipal),
          ),
          // Container branco com o formulário
          Expanded(
            flex: 7,
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'FORNECEDORES',
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
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Página',
                            value: _paginaSelecionada,
                            items: _opcoesPagina,
                            onChanged: (newValue) {
                              setState(() {
                                _paginaSelecionada = newValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Tamanho da página',
                            value: _tamanhoPaginaSelecionado,
                            items: _opcoesTamanhoPagina,
                            onChanged: (newValue) {
                              setState(() {
                                _tamanhoPaginaSelecionado = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'CNPJ',
                      hintText: 'Digite o CNPJ',
                      controller: _cnpjController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'CPF',
                      hintText: 'Digite o CPF',
                      controller: _cpfController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Natureza Jurídica',
                            value: _naturezaJuridicaSelecionada,
                            items: _opcoesNaturezaJuridica,
                            onChanged: (newValue) {
                              setState(() {
                                _naturezaJuridicaSelecionada = newValue;
                              });
                            },
                            hintText: 'Natureza Jurídica',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Porte Empresa',
                            value: _porteEmpresaSelecionado,
                            items: _opcoesPorteEmpresa,
                            onChanged: (newValue) {
                              setState(() {
                                _porteEmpresaSelecionado = newValue;
                              });
                            },
                            hintText: 'Porte Empresa',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Cód. CNAE',
                            value: _codCNAESelecionado,
                            items: _opcoesCodCNAE,
                            onChanged: (newValue) {
                              setState(() {
                                _codCNAESelecionado = newValue;
                              });
                            },
                            hintText: 'Cód. CNAE',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Ativo?',
                            value: _ativoSelecionado,
                            items: _opcoesAtivo,
                            onChanged: (newValue) {
                              setState(() {
                                _ativoSelecionado = newValue;
                              });
                            },
                            hintText: 'Sim/Não',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
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
                    const SizedBox(height: 20), // Pequeno espaço antes do botão
                  
                      ElevatedButton(
                        onPressed: () {
                          print('Botão BUSCAR clicado na tela de Fornecedores!');
                        // ... (seus prints dos valores) ...
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
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  }

  // Widget auxiliar para construir um campo Dropdown (adaptado para hints mais flexíveis)
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hintText, // Novo parâmetro para hint personalizado
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
            color: cinzaClaroCard,
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
                  value: item == hintText // Verifica se o item é o hint (primeiro da lista)
                      ? null // Se for o item placeholder, o valor é null
                      : item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: item == hintText
                          ? Colors.grey // Cor para o hint
                          : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              hint: Text(
                hintText ?? label, // Usa o hintText fornecido ou o label como fallback
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Novo Widget auxiliar para construir um campo de Texto (para CNPJ, CPF)
  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text, // Padrão é texto, pode ser alterado
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
            color: cinzaClaroCard,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none, // Remove a borda padrão do TextField
            ),
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}