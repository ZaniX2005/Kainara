class Motif {
  final String id;
  final String name;
  final String subtitle;
  final String region;
  final String origin;
  final String summary; // teks pendek di kartu
  final String description;
  final String image;
  final String headerImage;
  final bool isPopular;
  final String usage;
  final List<String> care;

  const Motif({
    required this.id,
    required this.name,
    this.subtitle = '',
    required this.region,
    required this.origin,
    this.summary = '',
    required this.description,
    required this.image,
    required this.headerImage,
    this.isPopular = false,
    this.usage = '',
    this.care = const [],
  });
}

class Outfit {
  final String name;
  final String motifName;
  final String image;
  final String category; // Outer, Blazer, dll
  final String description;

  const Outfit({
    this.name = 'Nama Outfit',
    this.motifName = '',
    required this.image,
    this.category = '',
    this.description = '',
  });
}