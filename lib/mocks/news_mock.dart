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
    {
      'title': 'La Liga: El Real Madrid vence en un partido crucial',
      'description': 'Victoria importante que lo mantiene en la cima de la tabla de clasificación tras un emocionante encuentro.',
      'imageUrl': 'https://picsum.photos/seed/3/400/200',
      'category': 'Deportes',
      'publishDate': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
    },
    {
      'title': 'Nueva exposición en el Museo del Prado',
      'description': 'El museo inaugura una exposición temporal con obras maestras del impresionismo nunca antes vistas en España.',
      'imageUrl': 'https://picsum.photos/seed/4/400/200',
      'category': 'Cultura',
      'publishDate': DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
    },
    {
      'title': 'Avances en Inteligencia Artificial',
      'description': 'Nuevos modelos de IA superan pruebas de razonamiento humano, marcando un hito en el desarrollo de la tecnología.',
      'imageUrl': 'https://picsum.photos/seed/5/400/200',
      'category': 'Tecnología',
      'publishDate': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
    },
    {
      'title': 'Descubren nueva especie marina',
      'description': 'Científicos encuentran una especie desconocida de pez en las profundidades del océano Pacífico.',
      'imageUrl': 'https://picsum.photos/seed/6/400/200',
      'category': 'Ciencia',
      'publishDate': DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
    },
    {
      'title': 'Festival de Jazz bate récords de asistencia',
      'description': 'El evento cultural más importante del año supera todas las expectativas de público.',
      'imageUrl': 'https://picsum.photos/seed/7/400/200',
      'category': 'Cultura',
      'publishDate': DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
    },
    {
      'title': 'Nuevas regulaciones bancarias en la UE',
      'description': 'La Unión Europea implementa cambios significativos en la regulación del sector financiero.',
      'imageUrl': 'https://picsum.photos/seed/8/400/200',
      'category': 'Finanzas',
      'publishDate': DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
    },
    {
      'title': 'Grandes cambios en la Fórmula 1',
      'description': 'Se anuncian modificaciones importantes en el reglamento para la próxima temporada.',
      'imageUrl': 'https://picsum.photos/seed/9/400/200',
      'category': 'Deportes',
      'publishDate': DateTime.now().subtract(const Duration(hours: 7)).toIso8601String(),
    },
    {
      'title': 'Nuevo tratamiento contra el cáncer',
      'description': 'Investigadores desarrollan una terapia prometedora que muestra resultados positivos en ensayos clínicos.',
      'imageUrl': 'https://picsum.photos/seed/10/400/200',
      'category': 'Ciencia',
      'publishDate': DateTime.now().subtract(const Duration(hours: 9)).toIso8601String(),
    },
  ];
}