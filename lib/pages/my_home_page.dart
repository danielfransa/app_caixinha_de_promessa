import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/promises_repository.dart';
import '../models/promise.dart';
import 'about_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  static const String currentLanguage = 'pt-BR';

  final PromisesRepository repository = PromisesRepository();
  final GlobalKey _promiseCardKey = GlobalKey();

  late final AnimationController _animationController;
  late final Animation<double> _boxAnimation;

  bool isLoading = true;
  bool isBoxOpen = false;
  bool isPromiseVisible = false;
  bool isHandlingImageAction = false;
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
        errorMessage = 'Não foi possível carregar as promessas.';
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

  String _buildShareText(Promise promise) {
    return '${promise.description}\n\n${promise.source} • ${promise.version}';
  }

  Future<void> _copyPromiseText() async {
    final promise = selectedPromise;
    if (promise == null) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: _buildShareText(promise)));

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Promessa copiada com sucesso.')),
    );
  }

  Future<Uint8List?> _capturePromiseCardBytes() async {
    final context = _promiseCardKey.currentContext;
    if (context == null) {
      return null;
    }

    final boundary = context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return null;
    }

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<File?> _writeCardImageToTemp() async {
    final bytes = await _capturePromiseCardBytes();
    if (bytes == null) {
      return null;
    }

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/promessa_compartilhar.png');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Future<void> _sharePromiseText() async {
    final promise = selectedPromise;
    if (promise == null) {
      return;
    }

    await SharePlus.instance.share(
      ShareParams(text: _buildShareText(promise)),
    );
  }

  Future<void> _sharePromiseImage() async {
    if (selectedPromise == null || isHandlingImageAction) {
      return;
    }

    setState(() {
      isHandlingImageAction = true;
    });

    try {
      final file = await _writeCardImageToTemp();
      if (file == null) {
        throw Exception('Não foi possível gerar a imagem do card.');
      }

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível compartilhar a imagem agora.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isHandlingImageAction = false;
        });
      }
    }
  }

  Future<void> _savePromiseImage() async {
    if (selectedPromise == null || isHandlingImageAction) {
      return;
    }

    setState(() {
      isHandlingImageAction = true;
    });

    try {
      var hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        hasAccess = await Gal.requestAccess(toAlbum: true);
      }

      if (!hasAccess) {
        throw Exception('Sem permissão para salvar na galeria.');
      }

      final file = await _writeCardImageToTemp();
      if (file == null) {
        throw Exception('Não foi possível gerar a imagem do card.');
      }

      await Gal.putImage(file.path, album: 'Caixinha de Promessas');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagem salva na galeria.')),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar a imagem na galeria.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isHandlingImageAction = false;
        });
      }
    }
  }

  Widget _buildPromiseCard(Promise promise) {
    return RepaintBoundary(
      key: _promiseCardKey,
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                promise.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                promise.source,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                promise.version,
                style: TextStyle(fontSize: 14, color: Colors.brown.shade400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromiseActions() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        OutlinedButton.icon(
          onPressed: _copyPromiseText,
          icon: const Icon(Icons.copy_all_rounded),
          label: const Text('Copiar'),
        ),
        OutlinedButton.icon(
          onPressed: _sharePromiseText,
          icon: const Icon(Icons.shortcut_rounded),
          label: const Text('Compartilhar texto'),
        ),
        OutlinedButton.icon(
          onPressed: isHandlingImageAction ? null : _sharePromiseImage,
          icon: const Icon(Icons.image_outlined),
          label: const Text('Compartilhar imagem'),
        ),
        OutlinedButton.icon(
          onPressed: isHandlingImageAction ? null : _savePromiseImage,
          icon: const Icon(Icons.download_rounded),
          label: const Text('Salvar imagem'),
        ),
      ],
    );
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
        actions: [
          IconButton(
            tooltip: 'Sobre o aplicativo',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AboutPage(),
                ),
              );
            },
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  40 + MediaQuery.of(context).padding.bottom,
                ),
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
                                  : Column(
                                    children: [
                                      _buildPromiseCard(selectedPromise!),
                                      const SizedBox(height: 16),
                                      _buildPromiseActions(),
                                    ],
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
