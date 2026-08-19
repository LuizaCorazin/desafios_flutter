class Caminhada {
  String partida;
  String chegada;
  double distanciaKm;
  double pesoKg;

  Caminhada({
    required this.partida,
    required this.chegada,
    required this.distanciaKm,
    required this.pesoKg,
  });

  double get calorias => distanciaKm * pesoKg * 0.7;

  String toCsv() => '$partida;$chegada;$distanciaKm;$pesoKg';

  factory Caminhada.fromCsv(String linha) {
    final partes = linha.split(';');
    return Caminhada(
      partida: partes[0],
      chegada: partes[1],
      distanciaKm: double.tryParse(partes[2]) ?? 0.0,
      pesoKg: double.tryParse(partes[3]) ?? 0.0,
    );
  }
}
