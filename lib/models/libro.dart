class Libro {
  final String id;
  final String titulo;
  final List<String>? autores;
  final String? descripcion;
  final String? imagenPortada;

  Libro({
    required this.id,
    required this.titulo,
    this.autores,
    this.descripcion,
    this.imagenPortada,
  });

  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      id: json['id'],
      titulo: json['titulo'],
      autores: json['autores'] != null ? List<String>.from(json['autores']) : null,
      descripcion: json['descripcion'],
      imagenPortada: json['imagenPortada'],
    );
  }

  static Libro example() {
    return Libro(
      id: '1',
      titulo: 'Ejemplo de Libro',
      autores: ['Autor Ejemplo'],
      descripcion: 'Esta es una descripción de ejemplo del libro.',
      imagenPortada: '',
    );
  }
}