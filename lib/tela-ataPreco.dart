// lib/tela_ata_registro_precos.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class TelaAtaRegistroPrecos extends StatefulWidget {
  const TelaAtaRegistroPrecos({super.key});

  @override
  State<TelaAtaRegistroPrecos> createState() => _TelaAtaRegistroPrecosState();
}

class _TelaAtaRegistroPrecosState extends State<TelaAtaRegistroPrecos> {
  // Cores e Services
  static const Color azulPrincipal = Color.fromRGBO(56, 28, 185, 1);
  static const Color cinzaClaroCard = Color(0xFFF0F0F0);
  final ApiService _apiService = ApiService();

  // Controladores
  final TextEditingController _dataVigenciaInicialController = TextEditingController();
  final TextEditingController _dataVigenciaFinalController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  
  // Variáveis de Estado
  int _paginaAtual = 1;
  bool _isCarregandoMais = false;
  List<AtaRegistroPreco> _resultadosFiltrados = [];
  bool _isLoading = false;
  String? _errorMessage;
  ArpResponse? _arpResponse;

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
    _dataVigenciaInicialController.dispose();
    _dataVigenciaFinalController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !_isCarregandoMais &&
        _paginaAtual < (_arpResponse?.totalPaginas ?? 0)) {
      _carregarMaisDados();
    }
  }

  void _filtrarResultados() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _resultadosFiltrados = _arpResponse?.resultado.where((ata) {
            final objetoLower = ata.objeto.toLowerCase();
            final unidadeGestoraLower = ata.nomeUnidadeGerenciadora.toLowerCase();
            return objetoLower.contains(query) || unidadeGestoraLower.contains(query);
          }).toList() ?? [];
    });
  }

  Future<void> _buscarDados() async {
    if (_dataVigenciaInicialController.text.isEmpty ||
        _dataVigenciaFinalController.text.isEmpty) {
      setState(() {
        _errorMessage = "Por favor, preencha as datas de vigência inicial e final.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _arpResponse = null;
      _resultadosFiltrados = [];
      _paginaAtual = 1;
      _searchController.clear();
    });

    try {
      final response = await _apiService.buscarArp(
        pagina: _paginaAtual,
        dataVigenciaInicial: _formatarDataParaApi(_dataVigenciaInicialController.text),
        dataVigenciaFinal: _formatarDataParaApi(_dataVigenciaFinalController.text),
      );
      setState(() {
        _arpResponse = response;
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
      final response = await _apiService.buscarArp(
        pagina: _paginaAtual,
        dataVigenciaInicial: _formatarDataParaApi(_dataVigenciaInicialController.text),
        dataVigenciaFinal: _formatarDataParaApi(_dataVigenciaFinalController.text),
      );
      setState(() {
        _arpResponse?.resultado.addAll(response.resultado);
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
        title: const Text('Buscar', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('ATA DE REGISTRO DE PREÇOS', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: azulPrincipal), textAlign: TextAlign.center),
            const SizedBox(height: 5),
            const Text('Preencha os campos abaixo', style: TextStyle(fontSize: 16, color: Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: _buildDateField(label: 'Data vigência inicial *', controller: _dataVigenciaInicialController)),
                const SizedBox(width: 16),
                Expanded(child: _buildDateField(label: 'Data vigência final *', controller: _dataVigenciaFinalController)),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _buscarDados,
              style: ElevatedButton.styleFrom(
                backgroundColor: azulPrincipal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Text('BUSCAR', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 30),
            if (_arpResponse != null && _arpResponse!.resultado.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Pesquisar nos resultados...',
                    hintText: 'Digite o objeto, nome da unidade...',
                    prefixIcon: const Icon(Icons.search, color: azulPrincipal),
                    filled: true,
                    fillColor: cinzaClaroCard,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                  ),
                ),
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
    if (_arpResponse == null) return const Center(child: Text("Preencha os filtros e clique em buscar.", style: TextStyle(fontSize: 16, color: Colors.grey)));
    if (_resultadosFiltrados.isEmpty && _searchController.text.isNotEmpty) return const Center(child: Text("Nenhum resultado encontrado para sua busca.", style: TextStyle(fontSize: 16, color: Colors.grey)));
    if (_arpResponse!.resultado.isEmpty) return const Center(child: Text("Nenhum resultado encontrado para os filtros informados.", style: TextStyle(fontSize: 16, color: Colors.grey)));
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _resultadosFiltrados.length + (_isCarregandoMais ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _resultadosFiltrados.length) {
          return const Padding(padding: EdgeInsets.symmetric(vertical: 16.0), child: Center(child: CircularProgressIndicator(color: azulPrincipal)));
        }
        
        final ata = _resultadosFiltrados[index];
        
        return InkWell(
          onTap: () => _mostrarDetalhesModal(ata),
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
                  Text("Ata: ${ata.numeroAtaRegistroPreco}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: azulPrincipal)),
                  const SizedBox(height: 8),
                  Text(ata.nomeUnidadeGerenciadora, style: const TextStyle(fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const Divider(height: 20),
                  Text("Objeto: ${ata.objeto}", style: const TextStyle(color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _mostrarDetalhesModal(AtaRegistroPreco ata) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
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
                    Text('Detalhes da Ata: ${ata.numeroAtaRegistroPreco}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: azulPrincipal)),
                    const Divider(height: 30),
                    _buildDetailRow('Objeto', ata.objeto),
                    _buildDetailRow('Órgão', ata.nomeOrgao),
                    _buildDetailRow('Unidade Gerenciadora', ata.nomeUnidadeGerenciadora),
                    _buildDetailRow('Modalidade', ata.nomeModalidadeCompra),
                    _buildDetailRow('Valor Total', 'R\$ ${ata.valorTotal.toStringAsFixed(2)}'),
                    _buildDetailRow('Status', ata.statusAta),
                    _buildDetailRow('Data de Assinatura', formatter.format(ata.dataAssinatura)),
                    _buildDetailRow('Vigência', '${formatter.format(ata.dataVigenciaInicial)} a ${formatter.format(ata.dataVigenciaFinal)}'),
                    _buildDetailRow('Itens', ata.quantidadeItens.toString()),
                    if (ata.linkAtaPNCP != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Ver no PNCP'),
                            onPressed: () async {
                              final uri = Uri.parse(ata.linkAtaPNCP!);
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              }
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: azulPrincipal),
                          ),
                        ),
                      ),
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: azulPrincipal)),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => controller.text = DateFormat('dd/MM/yyyy').format(picked));
    }
  }

  Widget _buildDateField({ required String label, required TextEditingController controller }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context, controller),
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Data',
                filled: true,
                fillColor: cinzaClaroCard,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0), borderSide: BorderSide.none),
                suffixIcon: const Icon(Icons.calendar_today, color: azulPrincipal),
              ),
            ),
          ),
        ),
      ],
    );
  }
}