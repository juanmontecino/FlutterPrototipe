class LibroModel{
  final String id;
  final String titulo;
  final String autor;
  final String descripcion;
  final String genero;

  LibroModel(
    {required this.id,
     required this.titulo, 
     required this.autor, 
     required this.descripcion,
     required this.genero
    }
  );

  factory LibroModel.fromJson(Map<String, dynamic> json){
    return LibroModel(
      id: json['id'],
      titulo: json['titulo'],
      autor: json['autor'],
      descripcion: json['descripcion'], 
      genero: json['genero'],
    );
  }
}
