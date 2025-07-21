import 'dart:convert';

CompraSemLicitacaoResponse compraSemLicitacaoResponseFromJson(String str) => CompraSemLicitacaoResponse.fromJson(json.decode(str));

class CompraSemLicitacaoResponse {
    final List<CompraSemLicitacao> resultado;
    final int totalRegistros;
    final int totalPaginas;

    CompraSemLicitacaoResponse({
        required this.resultado,
        required this.totalRegistros,
        required this.totalPaginas,
    });

    factory CompraSemLicitacaoResponse.fromJson(Map<String, dynamic> json) => CompraSemLicitacaoResponse(
        resultado: List<CompraSemLicitacao>.from(json["resultado"].map((x) => CompraSemLicitacao.fromJson(x))),
        totalRegistros: json["totalRegistros"] ?? 0,
        totalPaginas: json["totalPaginas"] ?? 0,
    );
}

class CompraSemLicitacao {
    final String idCompra;
    final String noAusg;
    final String dsObjetoLicitacao;
    final String? dsFundamentoLegal;
    final String? dsJustificativa;
    final String noResponsavelDeclDisp;
    final double? vrEstimado;
    final int dtAnoAviso;

    CompraSemLicitacao({
        required this.idCompra,
        required this.noAusg,
        required this.dsObjetoLicitacao,
        this.dsFundamentoLegal,
        this.dsJustificativa,
        required this.noResponsavelDeclDisp,
        this.vrEstimado,
        required this.dtAnoAviso,
    });

    factory CompraSemLicitacao.fromJson(Map<String, dynamic> json) => CompraSemLicitacao(
        idCompra: json["idCompra"] ?? "N/A",
        noAusg: json["no_ausg"]?.trim() ?? "N/A",
        dsObjetoLicitacao: json["ds_objeto_licitacao"]?.trim() ?? "Sem objeto",
        dsFundamentoLegal: json["ds_fundamento_legal"]?.trim(),
        dsJustificativa: json["ds_justificativa"]?.trim(),
        noResponsavelDeclDisp: json["no_responsavel_decl_disp"]?.trim() ?? "N/A",
        vrEstimado: (json["vr_estimado"] as num?)?.toDouble(),
        dtAnoAviso: json["dt_ano_aviso"] ?? 0,
    );
}