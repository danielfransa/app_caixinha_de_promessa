# Caixinha de Promessas

Aplicativo Flutter criado para sortear promessas bíblicas de forma simples, leve e offline.

O projeto nasceu com dois objetivos principais:

- servir como projeto de estudo e evolução prática em Flutter;
- oferecer uma experiência acolhedora que possa ajudar pessoas em sua espiritualidade no dia a dia.

## Proposta

A ideia da **Caixinha de Promessas** é resgatar a experiência da tradicional caixinha de promessas em uma versão mobile:

- o usuário toca na caixinha;
- uma promessa bíblica é sorteada;
- a mensagem é exibida com referência e versão bíblica;
- tudo funciona offline, sem login e sem anúncios.

## Objetivos do projeto

- Manter o app simples e acessível
- Permitir estudo de Flutter com um projeto real
- Criar uma base open source que possa evoluir com a comunidade
- Ajudar usuários com uma experiência devocional discreta e agradável

## Tecnologias

- Flutter
- Dart
- Android como plataforma inicial
- Estrutura preparada para futura expansão para iOS

## Estado atual

Atualmente o projeto já possui:

- carregamento de promessas a partir de JSON local;
- sorteio aleatório de promessas;
- filtro por idioma `pt-BR`;
- animação simples da caixinha abrindo e fechando;
- funcionamento offline;
- ícone e estrutura inicial de publicação Android.

## Estrutura principal

```txt
lib/
  main.dart
  my_app.dart
  models/
    promise.dart
  data/
    promises_repository.dart
  pages/
    my_home_page.dart

assets/
  data/
    promessas.json
  images/
    box_closed.png
    box_open.png
    app_icon.png
```

## Como executar localmente

Pré-requisitos:

- Flutter instalado
- SDK Android configurado
- Emulador Android ou aparelho físico

Comandos básicos:

```bash
flutter pub get
flutter run
```

## Build para Android

Para gerar uma build de publicação:

```bash
flutter build appbundle --release
```

O projeto já possui documentação auxiliar em:

- [Guia de publicação Play Store](docs/play_store_publicacao.md)
- [Documentação inicial do projeto](docs/caixinha_de_promessas_documentacao.md)
- [Política de privacidade](docs/privacy-policy.md)

## Open source

Este projeto está sendo desenvolvido com espírito open source, com a intenção de:

- compartilhar aprendizado;
- permitir estudo e adaptação por outras pessoas;
- incentivar contribuições simples e úteis;
- manter um projeto com propósito positivo e acolhedor.

## Contribuições

Contribuições são bem-vindas, especialmente em áreas como:

- melhorias visuais;
- acessibilidade;
- organização de código;
- testes;
- internacionalização;
- novas funcionalidades compatíveis com a proposta do app.

Se for contribuir, tente preservar a ideia central do projeto: simplicidade, leveza e utilidade espiritual.

## Licença

Este projeto é distribuído sob a licença **MIT**.

Você pode usar, estudar, copiar, modificar e redistribuir o projeto de acordo com os termos descritos em [LICENSE.md](LICENSE.md).

## Visão futura

Algumas evoluções possíveis:

- favoritos;
- histórico de promessas;
- evitar repetição imediata;
- promessa do dia;
- compartilhamento;
- notificações locais;
- múltiplos idiomas;
- publicação na Google Play e futuramente na App Store.
