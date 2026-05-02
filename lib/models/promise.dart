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
