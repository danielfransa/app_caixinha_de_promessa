# Caixinha de Promessas — Documentação Inicial do Projeto Flutter

Aplicativo Flutter simples para Android e futuramente iOS, inspirado na página web:

https://danielfransa.github.io/caixaDePromessas/

A proposta é criar uma versão mobile da “caixinha de promessas”, onde o usuário toca em um botão, uma pequena caixinha animada se abre e uma promessa bíblica é sorteada aleatoriamente a partir de um arquivo JSON local.

---

## 1. Objetivo do aplicativo

Criar um aplicativo:

- simples;
- leve;
- offline;
- sem login;
- sem anúncios;
- sem monetização inicial;
- com visual acolhedor;
- preparado para Android primeiro;
- preparado para iOS futuramente;
- com suporte futuro a múltiplos idiomas.

O aplicativo deve reproduzir a ideia da página GitHub Pages existente, mas com uma experiência mobile mais agradável, incluindo uma animação de caixinha se abrindo, remetendo às antigas caixinhas de promessas.

---

## 2. Funcionalidades do MVP

A primeira versão do app deve conter:

1. Carregamento de promessas a partir de um arquivo JSON local.
2. Sorteio aleatório de uma promessa.
3. Exibição do texto da promessa.
4. Exibição da referência bíblica.
5. Exibição da versão bíblica.
6. Suporte inicial ao idioma `pt-BR`.
7. Estrutura preparada para outros idiomas no futuro.
8. Animação simples de uma caixinha se abrindo.
9. Botão para sortear nova promessa.
10. Funcionamento totalmente offline.

---

## 3. Estrutura atual/sugerida do projeto

Estrutura recomendada:

```txt
lib/
  main.dart
  my_app.dart

  pages/
    my_home_page.dart

  models/
    promise.dart

  data/
    promises_repository.dart

assets/
  data/
    promises.json

  images/
    box_closed.png
    box_open.png
```

Caso as imagens ainda não existam, o app pode começar com ícones ou placeholders temporários. Depois, as imagens podem ser substituídas por artes definitivas.

---

## 4. Configuração dos assets no pubspec.yaml

No arquivo `pubspec.yaml`, adicionar:

```yaml
flutter:
  assets:
    - assets/data/
    - assets/images/
```

Observações importantes:

- A indentação do YAML precisa ser respeitada.
- As pastas `assets/data/` e `assets/images/` devem existir na raiz do projeto.
- O arquivo `promises.json` deve ficar em `assets/data/promises.json`.
- As imagens da caixinha devem ficar em `assets/images/`.

---

## 5. Formato atual do JSON

O JSON atual segue o formato abaixo:

```json
[
  {
    "id": "804",
    "description": "Não me assustam os milhares que me cercam.",
    "source": "Salmos 3:6",
    "version": "NVI",
    "language": "pt-BR"
  }
]
```

Cada promessa possui:

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `String` | Identificador da promessa |
| `description` | `String` | Texto da promessa |
| `source` | `String` | Referência bíblica |
| `version` | `String` | Versão bíblica, exemplo: NVI |
| `language` | `String` | Idioma da promessa, exemplo: pt-BR |

---

## 6. Estratégia para múltiplos idiomas

O app já deve considerar o campo:

```json
"language": "pt-BR"
```

No futuro, o mesmo arquivo JSON poderá conter promessas em outros idiomas:

```json
[
  {
    "id": "804",
    "description": "Não me assustam os milhares que me cercam.",
    "source": "Salmos 3:6",
    "version": "NVI",
    "language": "pt-BR"
  },
  {
    "id": "804",
    "description": "I will not fear though tens of thousands assail me on every side.",
    "source": "Psalm 3:6",
    "version": "NIV",
    "language": "en-US"
  }
]
```

Estratégia recomendada para o MVP:

- Manter um único arquivo `promises.json`.
- Filtrar as promessas pelo campo `language`.
- Começar com `pt-BR` fixo.
- Futuramente criar uma tela ou botão de seleção de idioma.

---

## 7. Model Promise

Criar o arquivo:

```txt
lib/models/promise.dart
```

Conteúdo sugerido:

```dart
class Promise {
  final String id;
  final String description;
  final String source;
  final String version;
  final String language;

  const Promise({
    required this.id,
    required this.description,
    required this.source,
    required this.version,
    required this.language,
  });

  factory Promise.fromJson(Map<String, dynamic> json) {
    return Promise(
      id: json['id'].toString(),
      description: json['description'] as String,
      source: json['source'] as String,
      version: json['version'] as String,
      language: json['language'] as String,
    );
  }
}
```

Observação:

O campo `id` está vindo como string no JSON. Por isso, no model, ele também pode ser tratado como `String`.

---

## 8. Repository para carregar e sortear promessas

Criar o arquivo:

```txt
lib/data/promises_repository.dart
```

Conteúdo sugerido:

```dart
import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/promise.dart';

class PromisesRepository {
  Future<List<Promise>> loadPromises() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/promises.json',
    );

    final List<dynamic> jsonList = json.decode(jsonString);

    return jsonList
        .map((item) => Promise.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  List<Promise> filterByLanguage({
    required List<Promise> promises,
    required String language,
  }) {
    return promises.where((promise) {
      return promise.language == language;
    }).toList();
  }

  Promise getRandomPromise(List<Promise> promises) {
    final random = Random();
    final index = random.nextInt(promises.length);

    return promises[index];
  }
}
```

Responsabilidades desse repository:

- Ler o arquivo JSON local.
- Converter JSON em lista de objetos `Promise`.
- Filtrar promessas por idioma.
- Sortear uma promessa aleatória.

---

## 9. main.dart

Arquivo:

```txt
lib/main.dart
```

Conteúdo sugerido:

```dart
import 'package:flutter/material.dart';

import 'my_app.dart';

void main() {
  runApp(const MyApp());
}
```

---

## 10. my_app.dart

Arquivo:

```txt
lib/my_app.dart
```

Conteúdo sugerido:

```dart
import 'package:flutter/material.dart';

import 'pages/my_home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caixinha de Promessas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
```

---

## 11. Página inicial MyHomePage

Arquivo:

```txt
lib/pages/my_home_page.dart
```

Conteúdo sugerido:

```dart
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
  final PromisesRepository repository = PromisesRepository();

  late final AnimationController _animationController;
  late final Animation<double> _boxAnimation;

  List<Promise> allPromises = [];
  List<Promise> filteredPromises = [];

  Promise? selectedPromise;

  bool isLoading = true;
  bool isBoxOpen = false;

  String currentLanguage = 'pt-BR';

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

    loadData();
  }

  Future<void> loadData() async {
    final loadedPromises = await repository.loadPromises();

    final promisesByLanguage = repository.filterByLanguage(
      promises: loadedPromises,
      language: currentLanguage,
    );

    setState(() {
      allPromises = loadedPromises;
      filteredPromises = promisesByLanguage;
      isLoading = false;
    });
  }

  Future<void> drawPromise() async {
    if (filteredPromises.isEmpty) return;

    setState(() {
      selectedPromise = null;
      isBoxOpen = false;
    });

    await _animationController.reverse();

    final promise = repository.getRandomPromise(filteredPromises);

    setState(() {
      selectedPromise = promise;
      isBoxOpen = true;
    });

    await _animationController.forward();
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _boxAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1 + (_boxAnimation.value * 0.08),
                        child: Image.asset(
                          isBoxOpen
                              ? 'assets/images/box_open.png'
                              : 'assets/images/box_closed.png',
                          height: 180,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              isBoxOpen
                                  ? Icons.inventory_2
                                  : Icons.inventory_2_outlined,
                              size: 140,
                              color: Colors.brown,
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  AnimatedOpacity(
                    opacity: selectedPromise == null ? 0 : 1,
                    duration: const Duration(milliseconds: 500),
                    child: selectedPromise == null
                        ? const SizedBox(height: 170)
                        : Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
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
                                      color: Colors.brown.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    selectedPromise!.version,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.brown.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 32),

                  FilledButton.icon(
                    onPressed: drawPromise,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text('Sortear promessa'),
                  ),
                ],
              ),
            ),
    );
  }
}
```

---

## 12. Observação sobre a animação da caixinha

Neste MVP, a animação será simples:

- imagem fechada antes do sorteio;
- imagem aberta após o sorteio;
- leve aumento de escala durante a abertura;
- exibição suave do texto com `AnimatedOpacity`.

Imagens esperadas:

```txt
assets/images/box_closed.png
assets/images/box_open.png
```

Caso as imagens ainda não existam, o código usa um `Icon` como fallback temporário.

No futuro, a animação pode evoluir para:

- animação com `CustomPainter`;
- sequência de imagens;
- Lottie;
- animação da tampa separada;
- som suave ao abrir;
- vibração curta no sorteio.

---

## 13. Fluxo esperado do app

1. Usuário abre o aplicativo.
2. O app carrega `assets/data/promises.json`.
3. O app filtra as promessas por `pt-BR`.
4. A tela exibe a caixinha fechada.
5. O usuário toca em `Sortear promessa`.
6. O app sorteia uma promessa aleatória.
7. A caixinha abre com animação.
8. A promessa é exibida com texto, referência e versão bíblica.

---

## 14. Tratamentos importantes

O app deve lidar com:

### JSON vazio

Se não houver promessas disponíveis, exibir mensagem amigável:

```txt
Nenhuma promessa encontrada para este idioma.
```

### Idioma sem promessas

Se o idioma selecionado não tiver registros no JSON, exibir a mesma mensagem.

### Imagens ausentes

O código já possui `errorBuilder` no `Image.asset`, exibindo um ícone temporário caso a imagem não seja encontrada.

---

## 15. Melhorias futuras

Depois do MVP, implementar gradualmente:

### Favoritos

Salvar IDs favoritos localmente.

Possível estrutura:

```dart
List<String> favoritePromiseIds;
```

### Histórico

Guardar as últimas promessas sorteadas.

### Evitar repetição imediata

Guardar o último ID sorteado e evitar repetir a mesma promessa duas vezes seguidas.

### Promessa do dia

Sortear uma promessa fixa por dia.

### Compartilhamento

Permitir compartilhar a promessa por WhatsApp, Instagram, Telegram etc.

Possível pacote futuro:

```yaml
share_plus
```

### Notificação diária

Enviar uma promessa por dia em horário configurável.

Possíveis pacotes futuros:

```yaml
flutter_local_notifications
timezone
```

### Internacionalização

Adicionar seleção de idioma:

- Português Brasil: `pt-BR`
- Inglês: `en-US`
- Espanhol: `es-ES`

### Tela Sobre

Informar:

- objetivo do app;
- ausência de anúncios;
- contato do desenvolvedor;
- versão do app.

---

## 16. Preparação para publicação Android

Para a Play Store, futuramente será necessário:

- configurar nome do app;
- configurar ícone;
- configurar splash screen;
- configurar package name adequado;
- gerar keystore;
- gerar build release;
- criar conta Google Play Console;
- criar política de privacidade, mesmo que o app não colete dados;
- preencher a seção de segurança dos dados;
- criar teste interno antes da publicação pública.

Como o app não terá login, anúncios, rastreamento nem coleta de dados, a política de privacidade pode ser simples, informando que o app não coleta dados pessoais.

---

## 17. Preparação futura para iOS

Para publicar na App Store futuramente será necessário:

- conta Apple Developer;
- ambiente macOS com Xcode;
- configurar bundle identifier;
- configurar ícones;
- configurar splash screen;
- gerar build iOS;
- testar via TestFlight;
- enviar para revisão na App Store Connect.

---

## 18. Prompt para continuar com o Codex no VS Code

Use este prompt no Codex:

```txt
Estou criando um aplicativo Flutter chamado Caixinha de Promessas.

O projeto já possui a seguinte ideia:

- Aplicativo Android inicialmente, futuramente iOS.
- Deve funcionar offline.
- Não terá anúncios.
- Não terá login.
- As promessas serão carregadas de um JSON local.
- O JSON está em assets/data/promises.json.
- O app deve sortear uma promessa aleatória ao clicar em um botão.
- Deve exibir uma animação simples de uma caixinha se abrindo.
- O app deve estar preparado para múltiplos idiomas futuramente.

Meu JSON tem este formato:

[
  {
    "id": "804",
    "description": "Não me assustam os milhares que me cercam.",
    "source": "Salmos 3:6",
    "version": "NVI",
    "language": "pt-BR"
  }
]

Estrutura desejada:

lib/
  main.dart
  my_app.dart
  pages/
    my_home_page.dart
  models/
    promise.dart
  data/
    promises_repository.dart

assets/
  data/
    promises.json
  images/
    box_closed.png
    box_open.png

Implemente:

1. O model Promise.
2. O PromisesRepository para carregar o JSON local.
3. Filtro por idioma usando o campo language.
4. Sorteio aleatório de uma promessa.
5. A tela MyHomePage.
6. A animação simples da caixinha usando AnimationController.
7. Fallback com ícone caso as imagens ainda não existam.
8. Atualização do pubspec.yaml com assets.
9. Código simples, legível e adequado para um MVP.
10. Evite dependências externas neste primeiro momento.
```

---

## 19. Checklist para o MVP

- [ ] Criar `assets/data/promises.json`
- [ ] Declarar assets no `pubspec.yaml`
- [ ] Criar `Promise`
- [ ] Criar `PromisesRepository`
- [ ] Criar tela `MyHomePage`
- [ ] Carregar JSON local
- [ ] Filtrar por `pt-BR`
- [ ] Sortear promessa aleatória
- [ ] Exibir descrição
- [ ] Exibir referência
- [ ] Exibir versão bíblica
- [ ] Adicionar animação simples da caixinha
- [ ] Testar no Android Emulator
- [ ] Testar em aparelho físico Android
- [ ] Preparar ícone do app
- [ ] Preparar splash screen
- [ ] Gerar build de teste

---

## 20. Prioridade de desenvolvimento

Ordem recomendada:

1. Fazer o JSON carregar corretamente.
2. Exibir uma promessa fixa na tela.
3. Implementar sorteio aleatório.
4. Implementar filtro por idioma.
5. Implementar a animação simples.
6. Melhorar layout.
7. Adicionar imagens definitivas.
8. Testar em Android.
9. Preparar publicação na Play Store.

---

## 21. Nome interno sugerido

Nome do projeto:

```txt
caixinha_de_promessas
```

Nome exibido ao usuário:

```txt
Caixinha de Promessas
```

---

## 22. Considerações finais

Este projeto deve começar simples. O mais importante para o MVP é:

- carregar o JSON;
- sortear corretamente;
- exibir uma promessa de forma bonita;
- ter uma pequena animação agradável;
- funcionar offline.

Depois disso, o app pode evoluir com favoritos, promessa do dia, compartilhamento, notificações e múltiplos idiomas.
