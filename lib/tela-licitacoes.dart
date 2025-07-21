// lib/tela-licitacoes.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class TelaLicitacoes extends StatefulWidget {
  const TelaLicitacoes({super.key});

  @override
  State<TelaLicitacoes> createState() => _TelaLicitacoesState();
}

class _TelaLicitacoesState extends State<TelaLicitacoes> {
  // Cores e Services
  static const Color azulPrincipal = Color.fromRGBO(56, 28, 185, 1);
  static const Color cinzaClaroCard = Color(0xFFF0F0F0);
  final ApiService _apiService = ApiService();

  // Controladores do Formulário
  final TextEditingController _dataPublicacaoInicialController = TextEditingController();
  final TextEditingController _dataPublicacaoFinalController = TextEditingController();
  final TextEditingController _uasgController = TextEditingController();
  final TextEditingController _numeroAvisoController = TextEditingController();
  // Para a modalidade, usaremos um Dropdown, então não precisa de controller.

  // Variáveis de Estado
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  int _paginaAtual = 1;
  bool _isCarregandoMais = false;
  List<Licitacao> _resultadosFiltrados = [];
  bool _isLoading = false;
  String? _errorMessage;
  LicitacaoResponse? _licitacaoResponse;
  String? _modalidadeSelecionada; // Para o dropdown de modalidade

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_filtrarResultados);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _dataPublicacaoInicialController.dispose();
    _dataPublicacaoFinalController.dispose();
    _uasgController.dispose();
    _numeroAvisoController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !_isCarregandoMais &&
        _paginaAtual < (_licitacaoResponse?.totalPaginas ?? 0)) {
      _carregarMaisDados();
    }
  }

  void _filtrarResultados() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _resultadosFiltrados = _licitacaoResponse?.resultado.where((licitacao) {
            final objetoLower = licitacao.objeto.toLowerCase();
            final identificadorLower = licitacao.identificador.toLowerCase();
            return objetoLower.contains(query) || identificadorLower.contains(query);
          }).toList() ?? [];
    });
  }

  Future<void> _buscarDados() async {
    if (_dataPublicacaoInicialController.text.isEmpty ||
        _dataPublicacaoFinalController.text.isEmpty) {
      setState(() => _errorMessage = "As datas de publicação são obrigatórias.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _licitacaoResponse = null;
      _resultadosFiltrados = [];
      _paginaAtual = 1;
      _searchController.clear();
    });

    try {
      final response = await _apiService.buscarLicitacoes(
        pagina: _paginaAtual,
        dataPublicacaoInicial: _formatarDataParaApi(_dataPublicacaoInicialController.text)!,
        dataPublicacaoFinal: _formatarDataParaApi(_dataPublicacaoFinalController.text)!,
        uasg: _uasgController.text,
        numeroAviso: _numeroAvisoController.text,
        modalidade: _modalidadeSelecionada,
      );
      setState(() {
        _licitacaoResponse = response;
        _resultadosFiltrados = response.resultado;
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  Future<void> _carregarMaisDados() async {
    setState(() => _isCarregandoMais = true);
    _paginaAtual++;

    try {
      final response = await _apiService.buscarLicitacoes(
        pagina: _paginaAtual,
        dataPublicacaoInicial: _formatarDataParaApi(_dataPublicacaoInicialController.text)!,
        dataPublicacaoFinal: _formatarDataParaApi(_dataPublicacaoFinalController.text)!,
        uasg: _uasgController.text,
        numeroAviso: _numeroAvisoController.text,
        modalidade: _modalidadeSelecionada,
      );
      setState(() {
        _licitacaoResponse?.resultado.addAll(response.resultado);
        _filtrarResultados();
      });
    } catch (e) {
      _paginaAtual--;
    } finally {
      setState(() => _isCarregandoMais = false);
    }
  }

  String? _formatarDataParaApi(String? data) {
    if (data == null || data.isEmpty) return null;
    try {
      return DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(data));
    } catch (e) {
      return null;
    }
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Buscar Licitações', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('LICITAÇÕES', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: azulPrincipal), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            // CAMPOS DO FORMULÁRIO
            _buildTextField(label: 'UASG', controller: _uasgController, hint: 'Código da UASG', keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildTextField(label: 'Número do Aviso', controller: _numeroAvisoController, hint: 'Número do aviso da licitação', keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            // TODO: Mapear os valores de modalidade para os códigos da API se necessário. Ex: 'PREGÃO' -> '5'
            _buildDropdownField(label: 'Modalidade (opcional)', value: _modalidadeSelecionada, items: ['5', '6'], hint: 'Selecione a modalidade'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildDateField(label: 'Data publicação inicial *', controller: _dataPublicacaoInicialController)),
                const SizedBox(width: 16),
                Expanded(child: _buildDateField(label: 'Data publicação final *', controller: _dataPublicacaoFinalController)),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _buscarDados,
              style: ElevatedButton.styleFrom(backgroundColor: azulPrincipal, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
              child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : const Text('BUSCAR', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 30),
            if (_licitacaoResponse != null && _licitacaoResponse!.resultado.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(controller: _searchController, decoration: InputDecoration(labelText: 'Pesquisar nos resultados...', prefixIcon: const Icon(Icons.search, color: azulPrincipal), filled: true, fillColor: cinzaClaroCard, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none))),
              ),
            _buildResultados(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultados() {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: azulPrincipal));
    if (_errorMessage != null) return Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 16), textAlign: TextAlign.center));
    if (_licitacaoResponse == null) return const Center(child: Text("Preencha os filtros e clique em buscar.", style: TextStyle(fontSize: 16, color: Colors.grey)));
    if (_resultadosFiltrados.isEmpty && _searchController.text.isNotEmpty) return const Center(child: Text("Nenhum resultado encontrado para sua busca.", style: TextStyle(fontSize: 16, color: Colors.grey)));
    if (_licitacaoResponse!.resultado.isEmpty) return const Center(child: Text("Nenhum resultado encontrado para os filtros informados.", style: TextStyle(fontSize: 16, color: Colors.grey)));
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _resultadosFiltrados.length + (_isCarregandoMais ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _resultadosFiltrados.length) return const Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Center(child: CircularProgressIndicator(color: azulPrincipal)));
        
        final licitacao = _resultadosFiltrados[index];
        
        return InkWell(
          onTap: () => _mostrarDetalhesModal(licitacao),
          borderRadius: BorderRadius.circular(10),
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Modalidade: ${licitacao.nomeModalidade}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: azulPrincipal)),
                  const SizedBox(height: 4),
                  Text("Aviso N°: ${licitacao.numeroAviso}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const Divider(height: 20),
                  Text(licitacao.objeto, style: const TextStyle(color: Colors.black87), maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                   if (licitacao.dataPublicacao != null) Text("Publicado em: ${DateFormat('dd/MM/yyyy').format(licitacao.dataPublicacao!)}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _mostrarDetalhesModal(Licitacao licitacao) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false, initialChildSize: 0.6, maxChildSize: 0.9, minChildSize: 0.4,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)))),
                    const SizedBox(height: 20),
                    Text('Detalhes da Licitação', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: azulPrincipal)),
                    const Divider(height: 30),
                    _buildDetailRow('Objeto', licitacao.objeto),
                    _buildDetailRow('Identificador', licitacao.identificador),
                    _buildDetailRow('Processo N°', licitacao.numeroProcesso),
                    _buildDetailRow('UASG', licitacao.uasg.toString()),
                    _buildDetailRow('Modalidade', licitacao.nomeModalidade),
                    _buildDetailRow('Aviso N°', licitacao.numeroAviso.toString()),
                    _buildDetailRow('Situação', licitacao.situacaoAviso),
                    if (licitacao.valorHomologadoTotal != null) _buildDetailRow('Valor Homologado', 'R\$ ${licitacao.valorHomologadoTotal!.toStringAsFixed(2)}'),
                    _buildDetailRow('Responsável', licitacao.nomeResponsavel),
                    if (licitacao.dataPublicacao != null) _buildDetailRow('Data de Publicação', DateFormat('dd/MM/yyyy').format(licitacao.dataPublicacao!)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2101), builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: azulPrincipal)), child: child!));
    if (picked != null) setState(() => controller.text = DateFormat('dd/MM/yyyy').format(picked));
  }

  Widget _buildDateField({ required String label, required TextEditingController controller }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        GestureDetector(onTap: () => _selectDate(context, controller), child: AbsorbPointer(child: TextField(controller: controller, readOnly: true, decoration: InputDecoration(hintText: 'Data', filled: true, fillColor: cinzaClaroCard, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none), suffixIcon: const Icon(Icons.calendar_today, color: azulPrincipal))))),
      ],
    );
  }
  
  Widget _buildTextField({ required String label, required TextEditingController controller, String? hint, TextInputType? keyboardType }) {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(controller: controller, keyboardType: keyboardType, decoration: InputDecoration(hintText: hint, filled: true, fillColor: cinzaClaroCard, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none))),
      ],
    );
  }

  Widget _buildDropdownField({required String label, String? value, required List<String> items, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint ?? 'Selecione'),
          decoration: InputDecoration(filled: true, fillColor: cinzaClaroCard, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none)),
          items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
          onChanged: (newValue) => setState(() => _modalidadeSelecionada = newValue),
        ),
      ],
    );
  }
}