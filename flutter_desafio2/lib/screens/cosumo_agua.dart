class ConsumoAgua {
  String data;
  double quantidadeMl;
  double pesoKg;

  ConsumoAgua({
    required this.data,
    required this.quantidadeMl,
    required this.pesoKg,
  });

  double get metaDiariaMl => pesoKg * 35;

  double get porcentagemMeta =>
      metaDiariaMl > 0 ? (quantidadeMl / metaDiariaMl) * 100 : 0;

  String toCsv() => '$data;$quantidadeMl;$pesoKg';

  factory ConsumoAgua.fromCsv(String linha) {
    final partes = linha.split(';');
    return ConsumoAgua(
      data: partes[0],
      quantidadeMl: double.tryParse(partes[1]) ?? 0.0,
      pesoKg: double.tryParse(partes[2]) ?? 0.0,
    );
  }
}
