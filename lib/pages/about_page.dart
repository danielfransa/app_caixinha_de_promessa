import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static final Uri _repositoryUri = Uri.parse(
    'https://github.com/danielfransa/app_caixinha_de_promessa',
  );
  static final Uri _issuesUri = Uri.parse(
    'https://github.com/danielfransa/app_caixinha_de_promessa/issues',
  );

  Future<void> _openLink(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E7),
      appBar: AppBar(
        title: const Text('Sobre o aplicativo'),
        centerTitle: true,
        backgroundColor: Colors.brown.shade200,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Caixinha de Promessas',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.brown.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Este aplicativo foi criado com a intenção de proporcionar um momento de reflexão, encorajamento e aproximação com Deus por meio de promessas bíblicas sorteadas de forma simples e acolhedora.',
                      style: TextStyle(fontSize: 16, height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'A proposta do app é servir como um apoio devocional e incentivar a pessoa a voltar o coração para Deus em meio à rotina. Ainda assim, ele não substitui a leitura diária da Bíblia, o tempo de oração, a intimidade pessoal com Deus e a comunhão com uma comunidade cristã local.',
                      style: TextStyle(fontSize: 16, height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'A Caixinha de Promessas deve ser vista como um recurso complementar, simples e acessível, que pode ajudar a lembrar verdades da Palavra de Deus ao longo do dia.',
                      style: TextStyle(fontSize: 16, height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Projeto open source',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.brown.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Este é um projeto open source. Você pode conhecer o código-fonte, acompanhar a evolução do app e contribuir pelo repositório no GitHub:',
                      style: TextStyle(fontSize: 16, height: 1.6),
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      _repositoryUri.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.brown.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      onPressed: () => _openLink(context, _repositoryUri),
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text('Abrir repositório'),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Encontrou algum bug?',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.brown.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Se você encontrar algum erro ou comportamento inesperado, pode abrir um chamado pela área de issues no GitHub:',
                      style: TextStyle(fontSize: 16, height: 1.6),
                    ),
                    const SizedBox(height: 12),
                    SelectableText(
                      _issuesUri.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.brown.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.tonalIcon(
                      onPressed: () => _openLink(context, _issuesUri),
                      icon: const Icon(Icons.bug_report_outlined),
                      label: const Text('Abrir issues'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
