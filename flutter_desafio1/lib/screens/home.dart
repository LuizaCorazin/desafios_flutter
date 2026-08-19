import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'caminhada.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Caminhada> caminhadas = [];

  @override
  void initState() {
    super.initState();
    _carregarDadosCSV();
  }

  Future<File> _getArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File('${diretorio.path}/caminhadas.csv');
  }

  Future<void> _salvarDadosCSV() async {
    final file = await _getArquivo();
    final linhas = caminhadas.map((c) => c.toCsv()).join('\n');
    await file.writeAsString(linhas);
  }

  Future<void> _carregarDadosCSV() async {
    try {
      final file = await _getArquivo();
      if (await file.exists()) {
        final conteudo = await file.readAsString();
        final linhas = conteudo.split('\n');
        setState(() {
          caminhadas = linhas
              .where((linha) => linha.trim().isNotEmpty)
              .map((linha) => Caminhada.fromCsv(linha))
              .toList();
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar dados: $e");
    }
  }

  void _excluirCaminhada(int index) {
    setState(() {
      caminhadas.removeAt(index);
    });
    _salvarDadosCSV();
  }

  // [RF004] Modal para adicionar ou alterar dados
  void _abrirModalFormularo({Caminhada? caminhadaExistente, int? index}) {
    final partidaController = TextEditingController(
      text: caminhadaExistente?.partida ?? '',
    );
    final chegadaController = TextEditingController(
      text: caminhadaExistente?.chegada ?? '',
    );
    final distanciaController = TextEditingController(
      text: caminhadaExistente?.distanciaKm.toString() ?? '',
    );
    final pesoController = TextEditingController(
      text: caminhadaExistente?.pesoKg.toString() ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                caminhadaExistente == null
                    ? "Nova Caminhada"
                    : "Editar Caminhada",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: partidaController,
                decoration: const InputDecoration(
                  labelText: "Ponto de Partida",
                ),
              ),
              TextField(
                controller: chegadaController,
                decoration: const InputDecoration(
                  labelText: "Ponto de Chegada",
                ),
              ),
              TextField(
                controller: distanciaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Distância (km)"),
              ),
              TextField(
                controller: pesoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Peso Atual (kg)"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final partida = partidaController.text;
                  final chegada = chegadaController.text;
                  final distancia =
                      double.tryParse(distanciaController.text) ?? 0.0;
                  final peso = double.tryParse(pesoController.text) ?? 0.0;

                  if (partida.isEmpty || chegada.isEmpty) return;

                  setState(() {
                    if (caminhadaExistente == null) {
                      caminhadas.add(
                        Caminhada(
                          partida: partida,
                          chegada: chegada,
                          distanciaKm: distancia,
                          pesoKg: peso,
                        ),
                      );
                    } else if (index != null) {
                      caminhadas[index] = Caminhada(
                        partida: partida,
                        chegada: chegada,
                        distanciaKm: distancia,
                        pesoKg: peso,
                      );
                    }
                  });

                  _salvarDadosCSV();
                  Navigator.of(ctx).pop();
                },
                child: const Text("Salvar"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Caminhadas"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _abrirModalFormularo(),
          ),
        ],
      ),
      body: caminhadas.isEmpty
          ? const Center(child: Text("Nenhuma caminhada registrada."))
          : ListView.builder(
              itemCount: caminhadas.length,
              itemBuilder: (ctx, i) {
                final item = caminhadas[i];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    onTap: () => _abrirModalFormularo(
                      caminhadaExistente: item,
                      index: i,
                    ),
                    title: Text("${item.partida} -> ${item.chegada}"),
                    subtitle: Text(
                      "${item.distanciaKm} km | ${item.pesoKg} kg\nCalorias: ${item.calorias.toStringAsFixed(1)} kcal",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _excluirCaminhada(i),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
