class NewsArticleMock {
  static List<Map<String, dynamic>> mockData = [
    {
      'title': 'Flutter 3.0 lanza nuevas características',
      'description': 'Google ha anunciado importantes mejoras en Flutter, incluyendo mejor rendimiento y nuevas características de Material Design 3.',
      'imageUrl': 'https://picsum.photos/seed/1/400/200',
      'category': 'Tecnología',
      'publishDate': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    },
    {
      'title': 'Nuevo récord en el mercado de criptomonedas',
      'description': 'El mercado de criptomonedas alcanza nuevos máximos históricos mientras los inversores muestran renovado interés.',
      'imageUrl': 'https://picsum.photos/seed/2/400/200',
      'category': 'Finanzas',
      'publishDate': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
    },
    // Agrega más datos mock según necesites
  ];
}