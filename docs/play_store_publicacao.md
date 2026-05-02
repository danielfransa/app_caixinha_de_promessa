# Publicacao Play Store - Caixinha de Promessas

Este guia resume os proximos passos para gerar a build Android de publicacao e subir o app no Google Play.

## 1. Gerar a keystore de upload

No Windows PowerShell, rode na raiz do projeto:

```powershell
keytool -genkeypair `
  -v `
  -keystore upload-keystore.jks `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -alias upload
```

Observacoes:

- Guarde a senha da keystore e da chave em local seguro.
- Nao envie o arquivo `upload-keystore.jks` para o Git.
- Nao envie o arquivo `android/key.properties` para o Git.

## 2. Criar o arquivo android/key.properties

Copie o arquivo `android/key.properties.example` para `android/key.properties` e preencha com seus dados reais:

```properties
storePassword=SUA_SENHA_DA_KEYSTORE
keyPassword=SUA_SENHA_DA_CHAVE
keyAlias=upload
storeFile=../upload-keystore.jks
```

## 3. Gerar o Android App Bundle

Na raiz do projeto:

```powershell
flutter clean
flutter pub get
flutter build appbundle --release
```

Ao final, o arquivo esperado normalmente fica em:

```txt
build/app/outputs/bundle/release/app-release.aab
```

## 4. Testar antes de subir

Antes da Play Store:

- Teste o app em aparelho Android real
- Teste orientacao, abertura, fechamento e sorteio
- Teste promessas grandes com rolagem
- Confirme nome, icone e comportamento da versao release

## 5. Criar o app no Play Console

No Play Console:

1. Criar um novo app
2. Nome: `Caixinha de Promessas`
3. Tipo: App
4. Definir se sera gratuito
5. Aceitar declaracoes exigidas

## 6. Preencher a ficha da loja

Itens minimos:

- Nome do app
- Descricao curta
- Descricao completa
- Icone do app
- Screenshots do celular
- Email de contato
- Politica de privacidade

## 7. Data safety

Como o app atual e offline e nao tem login nem anuncios, a tendencia e declarar que:

- nao coleta dados pessoais
- nao compartilha dados com terceiros

Mesmo assim, revise com cuidado o formulario no Play Console antes de enviar.

## 8. Politica de privacidade

Use o rascunho em `docs/privacy_policy.md`.

Importante:

- A Play exige uma URL publica
- O ideal e publicar esse texto em um site simples, GitHub Pages ou pagina propria
- Nao use PDF fechado como politica principal

## 9. Primeiro envio recomendado

Suba primeiro para:

- `Internal testing`

So depois de validar:

- instale pelo link da Play
- confira se o app abre corretamente
- revise a ficha da loja

## 10. Checklist final

- [ ] Keystore criada
- [ ] `android/key.properties` preenchido
- [ ] `app-release.aab` gerado
- [ ] App testado em release
- [ ] Politica de privacidade publicada
- [ ] Data safety preenchido
- [ ] Screenshots prontos
- [ ] Descricao curta e completa prontas
- [ ] App enviado para teste interno
