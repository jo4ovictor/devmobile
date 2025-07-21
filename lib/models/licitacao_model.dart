import 'dart:convert';

LicitacaoResponse licitacaoResponseFromJson(String str) => LicitacaoResponse.fromJson(json.decode(str));

class LicitacaoResponse {
    final List<Licitacao> resultado;
    final int totalRegistros;
    final int totalPaginas;

    LicitacaoResponse({
        required this.resultado,
        required this.totalRegistros,
        required this.totalPaginas,
    });

    factory LicitacaoResponse.fromJson(Map<String, dynamic> json) => LicitacaoResponse(
        resultado: List<Licitacao>.from(json["resultado"].map((x) => Licitacao.fromJson(x))),
        totalRegistros: json["totalRegistros"] ?? 0,
        totalPaginas: json["totalPaginas"] ?? 0,
    );
}

class Licitacao {
    final String identificador;
    final String numeroProcesso;
    final int uasg;
    final String nomeModalidade;
    final int numeroAviso;
    final String situacaoAviso;
    final String objeto;
    final String nomeResponsavel;
    final double? valorHomologadoTotal;
    final DateTime? dataPublicacao;

    Licitacao({
        required this.identificador,
        required this.numeroProcesso,
        required this.uasg,
        required this.nomeModalidade,
        required this.numeroAviso,
        required this.situacaoAviso,
        required this.objeto,
        required this.nomeResponsavel,
        this.valorHomologadoTotal,
        this.dataPublicacao,
    });

    factory Licitacao.fromJson(Map<String, dynamic> json) => Licitacao(
        identificador: json["identificador"] ?? "N/A",
        numeroProcesso: json["numero_processo"]?.trim() ?? "N/A",
        uasg: json["uasg"] ?? 0,
        nomeModalidade: json["nome_modalidade"] ?? "N/A",
        numeroAviso: json["numero_aviso"] ?? 0,
        situacaoAviso: json["situacao_aviso"] ?? "N/A",
        objeto: json["objeto"]?.trim() ?? "Sem objeto",
        nomeResponsavel: json["nome_responsavel"]?.trim() ?? "N/A",
        valorHomologadoTotal: (json["valor_homologado_total"] as num?)?.toDouble(),
        dataPublicacao: json["data_publicacao"] == null ? null : DateTime.parse(json["data_publicacao"]),
    );
}