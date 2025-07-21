// lib/models/arp_model.dart

import 'dart:convert';

// Função para decodificar o JSON e criar um objeto ArpResponse
ArpResponse arpResponseFromJson(String str) => ArpResponse.fromJson(json.decode(str));

// Classe que representa a resposta completa da API
class ArpResponse {
    final List<AtaRegistroPreco> resultado;
    final int totalRegistros;
    final int totalPaginas;

    ArpResponse({
        required this.resultado,
        required this.totalRegistros,
        required this.totalPaginas,
    });

    factory ArpResponse.fromJson(Map<String, dynamic> json) => ArpResponse(
        resultado: List<AtaRegistroPreco>.from(json["resultado"].map((x) => AtaRegistroPreco.fromJson(x))),
        totalRegistros: json["totalRegistros"],
        totalPaginas: json["totalPaginas"],
    );
}

// Classe que representa cada item da "Ata de Registro de Preço"
class AtaRegistroPreco {
    final String numeroAtaRegistroPreco;
    final String nomeUnidadeGerenciadora;
    final String nomeOrgao;
    final String? linkAtaPNCP;
    final String nomeModalidadeCompra;
    final DateTime dataAssinatura;
    final DateTime dataVigenciaInicial;
    final DateTime dataVigenciaFinal;
    final double valorTotal;
    final String statusAta;
    final String objeto;
    final int quantidadeItens;
    final bool ataExcluido;

    AtaRegistroPreco({
        required this.numeroAtaRegistroPreco,
        required this.nomeUnidadeGerenciadora,
        required this.nomeOrgao,
        this.linkAtaPNCP,
        required this.nomeModalidadeCompra,
        required this.dataAssinatura,
        required this.dataVigenciaInicial,
        required this.dataVigenciaFinal,
        required this.valorTotal,
        required this.statusAta,
        required this.objeto,
        required this.quantidadeItens,
        required this.ataExcluido,
    });

    factory AtaRegistroPreco.fromJson(Map<String, dynamic> json) => AtaRegistroPreco(
        numeroAtaRegistroPreco: json["numeroAtaRegistroPreco"] ?? "N/A",
        nomeUnidadeGerenciadora: json["nomeUnidadeGerenciadora"] ?? "N/A",
        nomeOrgao: json["nomeOrgao"] ?? "N/A",
        linkAtaPNCP: json["linkAtaPNCP"],
        nomeModalidadeCompra: json["nomeModalidadeCompra"] ?? "N/A",
        dataAssinatura: DateTime.parse(json["dataAssinatura"]),
        dataVigenciaInicial: DateTime.parse(json["dataVigenciaInicial"]),
        dataVigenciaFinal: DateTime.parse(json["dataVigenciaFinal"]),
        valorTotal: (json["valorTotal"] as num?)?.toDouble() ?? 0.0,
        statusAta: json["statusAta"] ?? "N/A",
        objeto: json["objeto"] ?? "Sem objeto",
        quantidadeItens: json["quantidadeItens"] ?? 0,
        ataExcluido: json["ataExcluido"] ?? false,
    );
}