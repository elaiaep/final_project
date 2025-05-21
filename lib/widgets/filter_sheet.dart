import 'package:flutter/material.dart';
import '../models/guitar.dart';

class FilterSheet extends StatefulWidget {
  final List<String> selectedTypes;
  final List<String> selectedBrands;
  final Map<String, dynamic>? selectedPriceRange;
  final SortOption currentSort;
  final Function(List<String>) onTypesChanged;
  final Function(List<String>) onBrandsChanged;
  final Function(Map<String, dynamic>?) onPriceRangeChanged;
  final Function(SortOption) onSortChanged;

  const FilterSheet({
    super.key,
    required this.selectedTypes,
    required this.selectedBrands,
    required this.selectedPriceRange,
    required this.currentSort,
    required this.onTypesChanged,
    required this.onBrandsChanged,
    required this.onPriceRangeChanged,
    required this.onSortChanged,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late List<String> _selectedTypes;
  late List<String> _selectedBrands;
  late Map<String, dynamic>? _selectedPriceRange;
  late SortOption _currentSort;

  @override
  void initState() {
    super.initState();
    _selectedTypes = List.from(widget.selectedTypes);
    _selectedBrands = List.from(widget.selectedBrands);
    _selectedPriceRange = widget.selectedPriceRange;
    _currentSort = widget.currentSort;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters & Sort',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          const Text(
            'Sort by',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: SortOption.values.map((sort) {
              return ChoiceChip(
                label: Text(_getSortLabel(sort)),
                selected: _currentSort == sort,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _currentSort = sort);
                    widget.onSortChanged(sort);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Guitar Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: guitarTypes.map((type) {
              return FilterChip(
                label: Text(type),
                selected: _selectedTypes.contains(type),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTypes.add(type);
                    } else {
                      _selectedTypes.remove(type);
                    }
                  });
                  widget.onTypesChanged(_selectedTypes);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Brand',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: guitarBrands.map((brand) {
              return FilterChip(
                label: Text(brand),
                selected: _selectedBrands.contains(brand),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedBrands.add(brand);
                    } else {
                      _selectedBrands.remove(brand);
                    }
                  });
                  widget.onBrandsChanged(_selectedBrands);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Price Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: const Text('All'),
                selected: _selectedPriceRange == null,
                onSelected: (selected) {
                  setState(() => _selectedPriceRange = null);
                  widget.onPriceRangeChanged(null);
                },
              ),
              ...priceRanges.map((range) {
                return FilterChip(
                  label: Text(range['label']),
                  selected: _selectedPriceRange == range,
                  onSelected: (selected) {
                    setState(() => _selectedPriceRange = selected ? range : null);
                    widget.onPriceRangeChanged(_selectedPriceRange);
                  },
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  String _getSortLabel(SortOption sort) {
    switch (sort) {
      case SortOption.nameAsc:
        return 'Name A-Z';
      case SortOption.nameDesc:
        return 'Name Z-A';
      case SortOption.priceHighToLow:
        return 'Price High-Low';
      case SortOption.priceLowToHigh:
        return 'Price Low-High';
      case SortOption.brand:
        return 'Brand';
    }
  }
} 