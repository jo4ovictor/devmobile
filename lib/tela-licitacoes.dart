// lib/tela_licitacoes.dart
import 'package:flutter/material.dart';

class TelaLicitacoes extends StatefulWidget {
  const TelaLicitacoes({super.key});

  @override
  State<TelaLicitacoes> createState() => _TelaLicitacoesState();
}

class _TelaLicitacoesState extends State<TelaLicitacoes> {
  // Cores
  static const Color azulPrincipal = Color.fromRGBO(56, 28, 185, 1);
  static const Color cinzaClaroCard = Color(0xFFF0F0F0); // Cor de fundo dos cards/campos

  // Valores selecionados para os Dropdowns
  String? _paginaSelecionada;
  String? _tamanhoPaginaSelecionado;
  String? _uasgSelecionada;
  String? _numeroAvisoSelecionado;
  String? _modalidadeSelecionada;

  // Controladores para os campos de data
  final TextEditingController _dataPublicacaoInicialController = TextEditingController();
  final TextEditingController _dataPublicacaoFinalController = TextEditingController();

  // Opções para os Dropdowns
  final List<String> _opcoesPagina = ['1', '2', '3', '4', '5']; // Exemplo
  final List<String> _opcoesTamanhoPagina = ['10', '20', '50', '100']; // Exemplo
  final List<String> _opcoesUASG = ['Selecione a UASG', 'UASG 1', 'UASG 2', 'UASG 3']; // Exemplo
  final List<String> _opcoesNumeroAviso = ['Nº aviso', 'Aviso 1', 'Aviso 2']; // Exemplo
  final List<String> _opcoesModalidade = ['Modalidade', 'Pregão', 'Concorrência', 'Tomada de Preços']; // Exemplo

  // Função para exibir o DatePicker
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: azulPrincipal, // Cor principal do DatePicker
              onPrimary: Colors.white, // Cor do texto nos botões do DatePicker
              onSurface: Colors.black87, // Cor do texto no calendário
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: azulPrincipal, // Cor dos botões de texto (CANCELAR, OK)
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    _dataPublicacaoInicialController.dispose();
    _dataPublicacaoFinalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo azul
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
          style: TextStyle(color: Colors.black87),
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
            flex: 0, // Ajuste para o tamanho da AppBar + um pouco mais
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'LICITAÇÕES',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: azulPrincipal,
                      ),
                      textAlign: TextAlign.center, // Centraliza o título
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Preencha os campos abaixo',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center, // Centraliza o subtítulo
                    ),
                    const SizedBox(height: 30),

                    // Campos de Página e Tamanho da Página
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

                    // Campo UASG
                    _buildDropdownField(
                      label: 'UASG',
                      value: _uasgSelecionada,
                      items: _opcoesUASG,
                      onChanged: (newValue) {
                        setState(() {
                          _uasgSelecionada = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    // Campos Número aviso e Modalidade
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Número aviso',
                            value: _numeroAvisoSelecionado,
                            items: _opcoesNumeroAviso,
                            onChanged: (newValue) {
                              setState(() {
                                _numeroAvisoSelecionado = newValue;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'Modalidade',
                            value: _modalidadeSelecionada,
                            items: _opcoesModalidade,
                            onChanged: (newValue) {
                              setState(() {
                                _modalidadeSelecionada = newValue;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Campos de Data
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            label: 'Data publicação inicial',
                            controller: _dataPublicacaoInicialController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDateField(
                            label: 'Data publicação final',
                            controller: _dataPublicacaoFinalController,
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

                    // Botão BUSCAR
                  
                      ElevatedButton(
                        onPressed: () {
                          // Ação do botão BUSCAR
                          print('Botão BUSCAR clicado!');
                          print('Página: $_paginaSelecionada');
                          print('Tamanho da Página: $_tamanhoPaginaSelecionado');
                          print('UASG: $_uasgSelecionada');
                          print('Número Aviso: $_numeroAvisoSelecionado');
                          print('Modalidade: $_modalidadeSelecionada');
                          print('Data Inicial: ${_dataPublicacaoInicialController.text}');
                          print('Data Final: ${_dataPublicacaoFinalController.text}');
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
                    
                    const SizedBox(height: 50), // Espaço no final
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para construir um campo Dropdown
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
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
            color: cinzaClaroCard, // Cor de fundo do campo
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade300), // Borda sutil
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              icon: const Icon(Icons.keyboard_arrow_down, color: azulPrincipal),
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item == items.first && item.contains('Selecione') || item.contains('Nº aviso') || item.contains('Modalidade')
                      ? null // Se for o item placeholder, o valor é null para permitir que o hint apareça
                      : item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: item == items.first && item.contains('Selecione') || item.contains('Nº aviso') || item.contains('Modalidade')
                          ? Colors.grey // Cor para o hint
                          : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              hint: Text(
                label, // O hint será o próprio label para Dropdowns
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget auxiliar para construir um campo de Data
  Widget _buildDateField({
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
        GestureDetector(
          onTap: () => _selectDate(context, controller),
          child: AbsorbPointer( // Impede que o TextField receba foco e abra o teclado
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: cinzaClaroCard,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: controller,
                readOnly: true, // Torna o campo somente leitura
                decoration: InputDecoration(
                  hintText: 'Data',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none, // Remove a borda padrão do TextField
                  suffixIcon: Icon(Icons.calendar_today, color: azulPrincipal), // Ícone de calendário
                ),
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          ),
        ),
      ],
    );
  }
}