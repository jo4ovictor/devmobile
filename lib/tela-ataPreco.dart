// lib/tela_ata_registro_precos.dart
import 'package:flutter/material.dart';

class TelaAtaRegistroPrecos extends StatefulWidget {
  const TelaAtaRegistroPrecos({super.key});

  @override
  State<TelaAtaRegistroPrecos> createState() => _TelaAtaRegistroPrecosState();
}

class _TelaAtaRegistroPrecosState extends State<TelaAtaRegistroPrecos> {
  // Cores (mantendo a cor roxa principal que você usa)
  static const Color azulPrincipal = Color.fromRGBO(56, 28, 185, 1);
  static const Color cinzaClaroCard = Color(0xFFF0F0F0); // Cor de fundo dos campos

  // Valores selecionados para os Dropdowns
  String? _paginaSelecionada;
  String? _tamanhoPaginaSelecionado;
  String? _uasgSelecionada;
  String? _mcSelecionado; // Novo campo
  String? _arpSelecionado; // Novo campo
  String? _numeroAvisoSelecionado;
  String? _modalidadeSelecionada;

  // Controladores para os campos de data
  final TextEditingController _dataPublicacaoInicialController = TextEditingController();
  final TextEditingController _dataPublicacaoFinalController = TextEditingController();
  final TextEditingController _dataVigenciaInicialController = TextEditingController(); // Nova data
  final TextEditingController _dataVigenciaFinalController = TextEditingController(); // Nova data

  // Opções para os Dropdowns
  final List<String> _opcoesPagina = ['1', '2', '3', '4', '5'];
  final List<String> _opcoesTamanhoPagina = ['10', '20', '50', '100'];
  final List<String> _opcoesUASG = ['UASG', 'UASG 1', 'UASG 2', 'UASG 3']; // Ajustado o hint
  final List<String> _opcoesMC = ['MC', 'MC 1', 'MC 2', 'MC 3']; // Exemplo de opções para MC
  final List<String> _opcoesARP = ['ARP', 'ARP 1', 'ARP 2', 'ARP 3']; // Exemplo de opções para ARP
  final List<String> _opcoesNumeroAviso = ['Nº aviso', 'Aviso 1', 'Aviso 2'];
  final List<String> _opcoesModalidade = ['Modalidade', 'Pregão', 'Concorrência', 'Tomada de Preços'];

  // Função para exibir o DatePicker (a mesma da tela de Licitações)
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
    _dataVigenciaInicialController.dispose();
    _dataVigenciaFinalController.dispose();
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
          // Espaço roxo acima do container branco (se houver, com flex 0 ele é mínimo)
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
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Estica os campos
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ATA DE REGISTRO DE PREÇOS', // Título da tela
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
                            hintText: '1', // Hint conforme a imagem
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
                            hintText: '10', // Hint conforme a imagem
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Campos UASG, MC e ARP (três em uma linha)
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownField(
                            label: 'UASG',
                            value: _uasgSelecionada,
                            items: _opcoesUASG,
                            onChanged: (newValue) {
                              setState(() {
                                _uasgSelecionada = newValue;
                              });
                            },
                            hintText: 'UASG', // Hint conforme a imagem
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'MC', // Novo campo
                            value: _mcSelecionado,
                            items: _opcoesMC,
                            onChanged: (newValue) {
                              setState(() {
                                _mcSelecionado = newValue;
                              });
                            },
                            hintText: 'MC', // Hint conforme a imagem
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdownField(
                            label: 'ARP', // Novo campo
                            value: _arpSelecionado,
                            items: _opcoesARP,
                            onChanged: (newValue) {
                              setState(() {
                                _arpSelecionado = newValue;
                              });
                            },
                            hintText: 'ARP', // Hint conforme a imagem
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Campos Número aviso e Modalidade (dois em uma linha)
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
                            hintText: 'Nº aviso', // Hint conforme a imagem
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
                            hintText: 'Modalidade', // Hint conforme a imagem
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Campos de Data de Publicação
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
                    const SizedBox(height: 20), // Espaço adicional para as novas datas

                    // Campos de Data de Vigência (novos)
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            label: 'Data vigência inicial',
                            controller: _dataVigenciaInicialController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDateField(
                            label: 'Data vigência final',
                            controller: _dataVigenciaFinalController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30), // Espaço antes do texto de confirmação

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
                            print('Botão BUSCAR clicado na tela de Ata de Registro de Preços!');
                            print('Página: $_paginaSelecionada');
                            print('Tamanho da Página: $_tamanhoPaginaSelecionado');
                            print('UASG: $_uasgSelecionada');
                            print('MC: $_mcSelecionado');
                            print('ARP: $_arpSelecionado');
                            print('Número Aviso: $_numeroAvisoSelecionado');
                            print('Modalidade: $_modalidadeSelecionada');
                            print('Data Publicação Inicial: ${_dataPublicacaoInicialController.text}');
                            print('Data Publicação Final: ${_dataPublicacaoFinalController.text}');
                            print('Data Vigência Inicial: ${_dataVigenciaInicialController.text}');
                            print('Data Vigência Final: ${_dataVigenciaFinalController.text}');
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

  // Widget auxiliar para construir um campo Dropdown (mesma da TelaFornecedores)
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? hintText, // Usado para hints mais específicos
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
                  // O valor do DropdownMenuItem é null se o item for o hintText
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
                hintText ?? label, // Se hintText não for fornecido, usa o label
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget auxiliar para construir um campo de Data (mesma da TelaLicitacoes)
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
          child: AbsorbPointer(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: cinzaClaroCard,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: controller,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Data',
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.calendar_today, color: azulPrincipal),
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