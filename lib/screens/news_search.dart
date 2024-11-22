import 'package:flutter/material.dart';

class NewsSearchScreen extends StatefulWidget {
  const NewsSearchScreen({Key? key}) : super(key: key);

  @override
  _NewsSearchScreenState createState() => _NewsSearchScreenState();
}

class _NewsSearchScreenState extends State<NewsSearchScreen> {
  final _searchController = TextEditingController();
  final List<String> _categories = ['Todas', 'Tecnología', 'Finanzas', 'Deportes', 'Cultura'];
  String _selectedCategory = 'Todas';
  bool _onlyLatestNews = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar with search button
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar noticias...',
                        prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.indigo, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.indigo, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.indigo, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onFieldSubmitted: (_) => _performSearch(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botón de búsqueda
                  ElevatedButton(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(Icons.search),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Category chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        selectedColor: Colors.indigo[100],
                        checkmarkColor: Colors.indigo,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Latest news toggle
              GestureDetector(
                onTap: () {
                  setState(() {
                    _onlyLatestNews = !_onlyLatestNews;
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      _onlyLatestNews ? Icons.check_circle : Icons.circle_outlined,
                      color: Colors.indigo,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Solo noticias recientes',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Results would go here
              Expanded(
                child: Center(
                  child: Text(
                    'Resultados de búsqueda irían aquí',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch() {
    // Realizar búsqueda con los parámetros actuales
    final searchQuery = _searchController.text;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Buscando: "$searchQuery" en ${_selectedCategory.toLowerCase()}' +
            (_onlyLatestNews ? ' (solo recientes)' : '')),
        duration: const Duration(seconds: 1),
      ),
    );
    
    // Aquí implementarías la lógica real de búsqueda
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}