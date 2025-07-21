
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TelaComprasSemLicitacao extends StatefulWidget {
  const TelaComprasSemLicitacao({super.key});

  @override
  State<TelaComprasSemLicitacao> createState() => _TelaComprasSemLicitacaoState();
}

class _TelaComprasSemLicitacaoState extends State<TelaComprasSemLicitacao> {
  // Cores e Services
  static const Color azulPrincipal = Color.fromRGBO(56, 28, 185, 1);
  static const Color cinzaClaroCard = Color(0xFFF0F0F0);
  final ApiService _apiService = ApiService();

  // Controladores do Formulário
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _uasgController = TextEditingController();

  // Variáveis de Estado
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  int _paginaAtual = 1;
  bool _isCarregandoMais = false;
  List<CompraSemLicitacao> _resultadosFiltrados = [];
  bool _isLoading = false;
  String? _errorMessage;
  CompraSemLicitacaoResponse? _compraResponse;

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
    _anoController.dispose();
    _uasgController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !_isCarregandoMais &&
        _paginaAtual < (_compraResponse?.totalPaginas ?? 0)) {
      _carregarMaisDados();
    }
  }

  void _filtrarResultados() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _resultadosFiltrados = _compraResponse?.resultado.where((compra) {
            final objetoLower = compra.dsObjetoLicitacao.toLowerCase();
            final uasgLower = compra.noAusg.toLowerCase();
            return objetoLower.contains(query) || uasgLower.contains(query);
          }).toList() ?? [];
    });
  }

  Future<void> _buscarDados() async {
    final ano = int.tryParse(_anoController.text);
    if (ano == null) {
      setState(() => _errorMessage = "O campo 'Ano do Aviso' é obrigatório e deve ser um número.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _compraResponse = null;
      _resultadosFiltrados = [];
      _paginaAtual = 1;
      _searchController.clear();
    });

    try {
      final response = await _apiService.buscarComprasSemLicitacao(
        pagina: _paginaAtual,
        dtAnoAviso: ano,
        coUasg: _uasgController.text,
      );
      setState(() {
        _compraResponse = response;
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
      final response = await _apiService.buscarComprasSemLicitacao(
        pagina: _paginaAtual,
        dtAnoAviso: int.parse(_anoController.text),
        coUasg: _uasgController.text,
      );
      setState(() {
        _compraResponse?.resultado.addAll(response.resultado);
        _filtrarResultados();
      });
    } catch (e) {
      _paginaAtual--;
    } finally {
      setState(() => _isCarregandoMais = false);
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
        title: const Text('Compras Sem Licitação', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('COMPRAS SEM LICITAÇÃO', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: azulPrincipal), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            
            _buildTextField(label: 'Ano do Aviso *', controller: _anoController, hint: 'Ex: 2024', keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildTextField(label: 'Cód. UASG (opcional)', controller: _uasgController, hint: 'Código da UASG', keyboardType: TextInputType.number),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _isLoading ? null : _buscarDados,
              style: ElevatedButton.styleFrom(backgroundColor: azulPrincipal, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
              child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)) : const Text('BUSCAR', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 30),

            if (_compraResponse != null && _compraResponse!.resultado.isNotEmpty)
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
    if (_compraResponse == null) return const Center(child: Text("Preencha os filtros e clique em buscar.", style: TextStyle(fontSize: 16, color: Colors.grey)));
    if (_resultadosFiltrados.isEmpty && _searchController.text.isNotEmpty) return const Center(child: Text("Nenhum resultado encontrado para sua busca.", style: TextStyle(fontSize: 16, color: Colors.grey)));
    if (_compraResponse!.resultado.isEmpty) return const Center(child: Text("Nenhum resultado encontrado para os filtros informados.", style: TextStyle(fontSize: 16, color: Colors.grey)));
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _resultadosFiltrados.length + (_isCarregandoMais ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _resultadosFiltrados.length) return const Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Center(child: CircularProgressIndicator(color: azulPrincipal)));
        
        final compra = _resultadosFiltrados[index];
        
        return InkWell(
          onTap: () => _mostrarDetalhesModal(compra),
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
                  Text(compra.noAusg, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: azulPrincipal)),
                  const SizedBox(height: 8),
                  Text("Objeto: ${compra.dsObjetoLicitacao}", style: const TextStyle(color: Colors.black87), maxLines: 3, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Text("Ano do Aviso: ${compra.dtAnoAviso}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _mostrarDetalhesModal(CompraSemLicitacao compra) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false, initialChildSize: 0.7, maxChildSize: 0.9, minChildSize: 0.4,
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
                    const Text('Detalhes da Compra', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: azulPrincipal)),
                    const Divider(height: 30),
                    _buildDetailRow('Objeto', compra.dsObjetoLicitacao),
                    _buildDetailRow('UASG', compra.noAusg),
                    _buildDetailRow('Responsável', compra.noResponsavelDeclDisp),
                    if(compra.vrEstimado != null) _buildDetailRow('Valor Estimado', 'R\$ ${compra.vrEstimado!.toStringAsFixed(2)}'),
                    if(compra.dsFundamentoLegal != null) _buildDetailRow('Fundamento Legal', compra.dsFundamentoLegal!),
                    if(compra.dsJustificativa != null) _buildDetailRow('Justificativa', compra.dsJustificativa!),
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
}