import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'abastecimento.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Abastecimento> abastecimentos = [];

  @override
  void initState() {
    super.initState();
    _carregarDadosCSV();
  }

  Future<File> _getArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File('${diretorio.path}/abastecimentos.csv');
  }

  Future<void> _salvarDadosCSV() async {
    final file = await _getArquivo();
    final linhas = abastecimentos.map((a) => a.toCsv()).join('\n');
    await file.writeAsString(linhas);
  }

  Future<void> _carregarDadosCSV() async {
    try {
      final file = await _getArquivo();
      if (await file.exists()) {
        final conteudo = await file.readAsString();
        final linhas = conteudo.split('\n');
        setState(() {
          abastecimentos = linhas
              .where((linha) => linha.trim().isNotEmpty)
              .map((linha) => Abastecimento.fromCsv(linha))
              .toList();
        });
      }
    } catch (e) {
      debugPrint("Erro ao carregar dados: $e");
    }
  }

  void _excluirAbastecimento(int index) {
    setState(() {
      abastecimentos.removeAt(index);
    });
    _salvarDadosCSV();
  }

  double get precoMedioPorLitro {
    if (abastecimentos.isEmpty) return 0.0;
    double totalLitros = abastecimentos.fold(
      0.0,
      (sum, item) => sum + item.litros,
    );
    double totalValor = abastecimentos.fold(
      0.0,
      (sum, item) => sum + item.valorPago,
    );
    return totalLitros > 0 ? totalValor / totalLitros : 0.0;
  }

  double get consumoMedioKmL {
    if (abastecimentos.length < 2) return 0.0;

    List<Abastecimento> ordenados = List.from(abastecimentos)
      ..sort((a, b) => a.quilometragem.compareTo(b.quilometragem));

    double kmRodados =
        ordenados.last.quilometragem - ordenados.first.quilometragem;

    double litrosConsumidos = 0.0;
    for (int i = 1; i < ordenados.length; i++) {
      litrosConsumidos += ordenados[i].litros;
    }

    return litrosConsumidos > 0 ? kmRodados / litrosConsumidos : 0.0;
  }

  // [RF005] Modal para criar/editar dados
  void _abrirModalFormulario({Abastecimento? registroExistente, int? index}) {
    final dataController = TextEditingController(
      text: registroExistente?.data ?? DateTime.now().toString().split(' ')[0],
    );
    final combustivelController = TextEditingController(
      text: registroExistente?.combustivel ?? 'Gasolina',
    );
    final litrosController = TextEditingController(
      text: registroExistente?.litros.toString() ?? '',
    );
    final valorController = TextEditingController(
      text: registroExistente?.valorPago.toString() ?? '',
    );
    final kmController = TextEditingController(
      text: registroExistente?.quilometragem.toString() ?? '',
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
                registroExistente == null
                    ? "Novo Abastecimento"
                    : "Editar Abastecimento",
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
                controller: combustivelController,
                decoration: const InputDecoration(
                  labelText: "Combustível (ex: Gasolina, Etanol)",
                ),
              ),
              TextField(
                controller: litrosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Litros"),
              ),
              TextField(
                controller: valorController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Valor Pago (R\$)",
                ),
              ),
              TextField(
                controller: kmController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quilometragem (km)",
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final data = dataController.text;
                  final combustivel = combustivelController.text;
                  final litros = double.tryParse(litrosController.text) ?? 0.0;
                  final valor = double.tryParse(valorController.text) ?? 0.0;
                  final km = double.tryParse(kmController.text) ?? 0.0;

                  if (data.isEmpty || combustivel.isEmpty) return;

                  setState(() {
                    final item = Abastecimento(
                      data: data,
                      combustivel: combustivel,
                      litros: litros,
                      valorPago: valor,
                      quilometragem: km,
                    );
                    if (registroExistente == null) {
                      abastecimentos.add(item);
                    } else if (index != null) {
                      abastecimentos[index] = item;
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
        title: const Text("Abastecimentos"),
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
                color: Colors.orangeAccent.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("Preço Médio/L", style: TextStyle(fontSize: 12)),
                    Text(
                      "R\$ ${precoMedioPorLitro.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Consumo Médio", style: TextStyle(fontSize: 12)),
                    Text(
                      "${consumoMedioKmL.toStringAsFixed(1)} km/L",
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
            child: abastecimentos.isEmpty
                ? const Center(child: Text("Nenhum abastecimento registrado."))
                : ListView.builder(
                    itemCount: abastecimentos.length,
                    itemBuilder: (ctx, i) {
                      final item = abastecimentos[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          onTap: () => _abrirModalFormulario(
                            registroExistente: item,
                            index: i,
                          ),
                          title: Text("${item.combustivel} - ${item.data}"),
                          subtitle: Text(
                            "${item.litros} L | R\$ ${item.valorPago.toStringAsFixed(2)} (R\$ ${item.precoPorLitro.toStringAsFixed(2)}/L)\nKM: ${item.quilometragem}",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _excluirAbastecimento(i),
                          ),
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
