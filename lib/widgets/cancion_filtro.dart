import 'package:flutter/material.dart';

class FiltroGenero extends StatelessWidget {
  final List<String> genres;
  final String? selectedGenre;
  final Function(String?) onGenreSelected;

  const FiltroGenero({
    Key? key,
    required this.genres,
    required this.selectedGenre,
    required this.onGenreSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Filtrar por género',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Todos'),
                  selected: selectedGenre == null,
                  onSelected: (_) => onGenreSelected(null),
                  selectedColor: Colors.blue.withOpacity(0.2),
                ),
                const SizedBox(width: 8),
                ...genres.map(
                  (genre) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(genre),
                      selected: genre == selectedGenre,
                      onSelected: (_) => onGenreSelected(genre),
                      selectedColor: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}