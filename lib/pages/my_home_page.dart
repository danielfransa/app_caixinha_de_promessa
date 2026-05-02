import 'package:flutter/material.dart';

import '../data/promises_repository.dart';
import '../models/promise.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const String currentLanguage = 'pt-BR';

  final PromisesRepository repository = PromisesRepository();

  bool isLoading = true;
  String? errorMessage;
  List<Promise> promises = <Promise>[];
  Promise? selectedPromise;

  @override
  void initState() {
    super.initState();
    _loadPromises();
  }

  Future<void> _loadPromises() async {
    try {
      final loadedPromises = await repository.loadPromises();
      final filteredPromises = repository.filterByLanguage(
        promises: loadedPromises,
        language: currentLanguage,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        promises = filteredPromises;
        selectedPromise =
            filteredPromises.isEmpty
                ? null
                : repository.getRandomPromise(filteredPromises);
        errorMessage =
            filteredPromises.isEmpty
                ? 'Nenhuma promessa encontrada para este idioma.'
                : null;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        errorMessage = 'Nao foi possivel carregar as promessas.';
        isLoading = false;
      });
    }
  }

  void _drawPromise() {
    if (promises.isEmpty) {
      return;
    }

    setState(() {
      selectedPromise = repository.getRandomPromise(promises);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        title: const Text('Caixinha de Promessas'),
        centerTitle: true,
        backgroundColor: Colors.brown.shade200,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 120,
                          color: Colors.brown.shade400,
                        ),
                        const SizedBox(height: 24),
                        if (errorMessage != null)
                          Text(
                            errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        else if (selectedPromise != null)
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  Text(
                                    selectedPromise!.description,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      height: 1.4,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    selectedPromise!.source,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    selectedPromise!.version,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.brown.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: promises.isEmpty ? null : _drawPromise,
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('Sortear promessa'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
