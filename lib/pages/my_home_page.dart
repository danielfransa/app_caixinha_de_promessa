import 'package:flutter/material.dart';

import '../data/promises_repository.dart';
import '../models/promise.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  static const String currentLanguage = 'pt-BR';

  final PromisesRepository repository = PromisesRepository();

  late final AnimationController _animationController;
  late final Animation<double> _boxAnimation;

  bool isLoading = true;
  bool isBoxOpen = false;
  bool isPromiseVisible = false;
  String? errorMessage;
  List<Promise> promises = <Promise>[];
  Promise? selectedPromise;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _boxAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
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

  Future<void> _drawPromise() async {
    if (promises.isEmpty) {
      return;
    }

    setState(() {
      isPromiseVisible = false;
      isBoxOpen = false;
    });

    await _animationController.reverse();

    final promise = repository.getRandomPromise(promises);

    if (!mounted) {
      return;
    }

    setState(() {
      selectedPromise = promise;
      isBoxOpen = true;
    });

    await _animationController.forward();

    if (!mounted) {
      return;
    }

    setState(() {
      isPromiseVisible = true;
    });
  }

  Future<void> _toggleBox() async {
    if (promises.isEmpty) {
      return;
    }

    if (isBoxOpen) {
      setState(() {
        isPromiseVisible = false;
      });

      await Future<void>.delayed(const Duration(milliseconds: 220));

      if (!mounted) {
        return;
      }

      setState(() {
        isBoxOpen = false;
        selectedPromise = null;
      });

      await _animationController.reverse();
      return;
    }

    await _drawPromise();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 520,
                      minHeight:
                          MediaQuery.of(context).size.height -
                          kToolbarHeight -
                          48,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _boxAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1 + (_boxAnimation.value * 0.08),
                              child: GestureDetector(
                                onTap: _toggleBox,
                                child: Image.asset(
                                  isBoxOpen
                                      ? 'assets/images/box_open.png'
                                      : 'assets/images/box_closed.png',
                                  height: 300,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      isBoxOpen
                                          ? Icons.inventory_2
                                          : Icons.inventory_2_outlined,
                                      size: 180,
                                      color: Colors.brown,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          isBoxOpen
                              ? 'Toque na caixinha para fechar'
                              : 'Toque na caixinha para abrir uma promessa',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.brown.shade600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                          opacity:
                              errorMessage != null
                                  ? 1
                                  : (isPromiseVisible ? 1 : 0),
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOut,
                          child:
                              selectedPromise == null
                                  ? SizedBox(
                                    height: errorMessage == null ? 180 : 72,
                                    child:
                                        errorMessage == null
                                            ? null
                                            : Center(
                                              child: Text(
                                                errorMessage!,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                  )
                                  : Card(
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
