// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import '../models/arp_model.dart'; // Importa nosso modelo de dados
import '../models/licitacao_model.dart';

export '../models/arp_model.dart';
export '../models/licitacao_model.dart';

class ApiService {
  // URL base da API
  static const String _baseUrl = 'dadosabertos.compras.gov.br';
  // Endpoint específico para a consulta de ARP
  static const String _endpoint = '/modulo-arp/1_consultarARP';

  // Método para buscar as Atas de Registro de Preço
  Future<ArpResponse> buscarArp({
    int pagina = 1,
    int tamanhoPagina = 10,
    String? dataVigenciaInicial, // Formato YYYY-MM-DD
    String? dataVigenciaFinal,   // Formato YYYY-MM-DD
    // Adicione outros parâmetros do formulário aqui conforme necessário
    String? codigoUasg,
    String? codigoModalidade,
    String? numeroAta,
    String? dataAssinaturaInicial,
    String? dataAssinaturaFinal,
  }) async {
    // Monta o mapa de parâmetros da query, adicionando apenas os que não são nulos
    final Map<String, String> queryParameters = {
      'pagina': pagina.toString(),
      'tamanhoPagina': tamanhoPagina.toString(),
      if (dataVigenciaInicial != null) 'dataVigenciaInicial': dataVigenciaInicial,
      if (dataVigenciaFinal != null) 'dataVigenciaFinal': dataVigenciaFinal,
      if (codigoUasg != null) 'codigoUnidadeGerenciadora': codigoUasg,
      if (codigoModalidade != null) 'codigoModalidadeCompra': codigoModalidade,
      if (numeroAta != null) 'numeroAtaRegistroPreco': numeroAta,
      if (dataAssinaturaInicial != null) 'dataAssinaturaInicial': dataAssinaturaInicial,
      if (dataAssinaturaFinal != null) 'dataAssinaturaFinal': dataAssinaturaFinal,
    };

    // Cria a URI final
    final uri = Uri.https(_baseUrl, _endpoint, queryParameters);

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Se a chamada foi bem-sucedida, decodifica o JSON e retorna o objeto ArpResponse
        return arpResponseFromJson(response.body);
      } else {
        // Se o servidor retornou um erro, lança uma exceção
        throw Exception('Falha ao carregar dados da API. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Em caso de erro de rede ou outro problema
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<LicitacaoResponse> buscarLicitacoes({
    int pagina = 1,
    int tamanhoPagina = 10,
    required String dataPublicacaoInicial, // Obrigatório pela API
    required String dataPublicacaoFinal,   // Obrigatório pela API
    String? uasg,
    String? modalidade,
    String? numeroAviso,
  }) async {
    const endpoint = '/modulo-legado/1_consultarLicitacao';
    final queryParameters = {
      'pagina': pagina.toString(),
      'tamanhoPagina': tamanhoPagina.toString(),
      'data_publicacao_inicial': dataPublicacaoInicial,
      'data_publicacao_final': dataPublicacaoFinal,
      if (uasg != null && uasg.isNotEmpty) 'uasg': uasg,
      if (modalidade != null && modalidade.isNotEmpty) 'modalidade': modalidade,
      if (numeroAviso != null && numeroAviso.isNotEmpty) 'numero_aviso': numeroAviso,
    };

    final uri = Uri.https(_baseUrl, endpoint, queryParameters);

    try {
      final response = await http.get(uri, headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        return licitacaoResponseFromJson(response.body);
      } else {
        throw Exception('Falha ao carregar dados da API de Licitações. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão com API de Licitações: $e');
    }
  }
}