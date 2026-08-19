import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_desafio2/screens/cosumo_agua.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ConsumoAgua> registros = [];

  @override
  void initState() {
    super.initState();
    _carregarDadosCSV();
  }

  Future<File> _getArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File('${diretorio.path}/consumo_agua.csv');
  }

  Future<void> _salvarDadosCSV() async {
    final file = await _getArquivo();
    final linhas = registros.map((r) => r.toCsv()).join('\n');
    await file.writeAsString(linhas);
  }

  Future<void> _carregarDadosCSV() async {
    try {
      final file = await _getArquivo();
      if (await file.exists()) {
        final conteudo = await file.readAsString();
        final linhas = conteudo.split('\n');
        setState(() {
          registros = linhas
              .where((linha) => linha.trim().isNotEmpty)
              .map((linha) => ConsumoAgua.fromCsv(linha))
              .toList();
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar dados: $e");
    }
  }

  void _excluirRegistro(int index) {
    setState(() {
      registros.removeAt(index);
    });
    _salvarDadosCSV();
  }

  double get totalConsumidoMl {
    return registros.fold(0.0, (sum, item) => sum + item.quantidadeMl);
  }

  double get mediaMetaPorcentagem {
    if (registros.isEmpty) return 0.0;
    double somaPorcentagem = registros.fold(
      0.0,
      (sum, item) => sum + item.porcentagemMeta,
    );
    return somaPorcentagem / registros.length;
  }

  void _abrirModalFormulario({ConsumoAgua? registroExistente, int? index}) {
    final dataController = TextEditingController(
      text: registroExistente?.data ?? DateTime.now().toString().split(' ')[0],
    );
    final quantidadeController = TextEditingController(
      text: registroExistente?.quantidadeMl.toString() ?? '',
    );
    final pesoController = TextEditingController(
      text: registroExistente?.pesoKg.toString() ?? '',
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
                registroExistente == null ? "Novo Registro" : "Editar Registro",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: dataController,
                decoration: const InputDecoration(
                  labelText: "Data (AAAA-MM-DD)",
                ),
              ),
              TextField(
                controller: quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Quantidade (ml)"),
              ),
              TextField(
                controller: pesoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Peso Atual (kg)"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final data = dataController.text;
                  final qtd = double.tryParse(quantidadeController.text) ?? 0.0;
                  final peso = double.tryParse(pesoController.text) ?? 0.0;

                  if (data.isEmpty) return;

                  setState(() {
                    if (registroExistente == null) {
                      registros.add(
                        ConsumoAgua(
                          data: data,
                          quantidadeMl: qtd,
                          pesoKg: peso,
                        ),
                      );
                    } else if (index != null) {
                      registros[index] = ConsumoAgua(
                        data: data,
                        quantidadeMl: qtd,
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
        title: const Text("Consumo de agua"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _abrirModalFormulario(),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.blueAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text(
                      "Total Consumido",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${totalConsumidoMl.toStringAsFixed(0)} ml",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Meta Atingida", style: TextStyle(fontSize: 12)),
                    Text(
                      "${mediaMetaPorcentagem.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: registros.isEmpty
                ? const Center(child: Text("Nenhum registro de água."))
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.1,
                        ),
                    itemCount: registros.length,
                    itemBuilder: (ctx, i) {
                      final item = registros[i];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                                onPressed: () => _excluirRegistro(i),
                              ),
                            ),
                            InkWell(
                              onTap: () => _abrirModalFormulario(
                                registroExistente: item,
                                index: i,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.data,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${item.quantidadeMl.toStringAsFixed(0)} ml",
                                    ),
                                    Text("${item.pesoKg} kg"),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${item.porcentagemMeta.toStringAsFixed(0)}% da meta",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
