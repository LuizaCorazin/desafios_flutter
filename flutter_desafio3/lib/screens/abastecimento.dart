class Abastecimento {
  String data;
  String combustivel;
  double litros;
  double valorPago;
  double quilometragem;

  Abastecimento({
    required this.data,
    required this.combustivel,
    required this.litros,
    required this.valorPago,
    required this.quilometragem,
  });

  double get precoPorLitro => litros > 0 ? valorPago / litros : 0.0;

  String toCsv() => '$data;$combustivel;$litros;$valorPago;$quilometragem';

  factory Abastecimento.fromCsv(String linha) {
    final partes = linha.split(';');
    return Abastecimento(
      data: partes[0],
      combustivel: partes[1],
      litros: double.tryParse(partes[2]) ?? 0.0,
      valorPago: double.tryParse(partes[3]) ?? 0.0,
      quilometragem: double.tryParse(partes[4]) ?? 0.0,
    );
  }
}
