import 'dart:convert';

FornecedorResponse fornecedorResponseFromJson(String str) => FornecedorResponse.fromJson(json.decode(str));

class FornecedorResponse {
    final List<Fornecedor> resultado;
    final int totalRegistros;
    final int totalPaginas;

    FornecedorResponse({
        required this.resultado,
        required this.totalRegistros,
        required this.totalPaginas,
    });

    factory FornecedorResponse.fromJson(Map<String, dynamic> json) => FornecedorResponse(
        resultado: List<Fornecedor>.from(json["resultado"].map((x) => Fornecedor.fromJson(x))),
        totalRegistros: json["totalRegistros"] ?? 0,
        totalPaginas: json["totalPaginas"] ?? 0,
    );
}

class Fornecedor {
    final bool ativo;
    final String? cnpj;
    final String? cpf;
    final bool habilitadoLicitar;
    final String nomeCnae;
    final String nomeMunicipio;
    final String porteEmpresaNome;
    final String nomeRazaoSocialFornecedor;
    final String ufSigla;

    Fornecedor({
        required this.ativo,
        this.cnpj,
        this.cpf,
        required this.habilitadoLicitar,
        required this.nomeCnae,
        required this.nomeMunicipio,
        required this.porteEmpresaNome,
        required this.nomeRazaoSocialFornecedor,
        required this.ufSigla,
    });

    factory Fornecedor.fromJson(Map<String, dynamic> json) => Fornecedor(
        ativo: json["ativo"] ?? false,
        cnpj: json["cnpj"],
        cpf: json["cpf"],
        habilitadoLicitar: json["habilitadoLicitar"] ?? false,
        nomeCnae: json["nomeCnae"] ?? "N/A",
        nomeMunicipio: json["nomeMunicipio"] ?? "N/A",
        porteEmpresaNome: json["porteEmpresaNome"] ?? "N/A",
        nomeRazaoSocialFornecedor: json["nomeRazaoSocialFornecedor"]?.trim() ?? "N/A",
        ufSigla: json["ufSigla"] ?? "N/A",
    );
}