import 'package:flutter/material.dart';
import '../models/guitar.dart';
import '../widgets/guitar_card.dart';
import '../widgets/filter_sheet.dart';
import '../screens/guitar_detail_screen.dart';
import '../widgets/page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Guitar> filteredGuitars = [];
  final TextEditingController _searchController = TextEditingController();
  
  // Filter states
  List<String> selectedTypes = [];
  List<String> selectedBrands = [];
  Map<String, dynamic>? selectedPriceRange;
  SortOption currentSort = SortOption.nameAsc;

  @override
  void initState() {
    super.initState();
    _applyFilters('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters(String searchQuery) {
    setState(() {
      filteredGuitars = sampleGuitars.where((guitar) {
        // Apply search filter
        if (searchQuery.isNotEmpty) {
          final query = searchQuery.toLowerCase();
          if (!guitar.name.toLowerCase().contains(query) &&
              !guitar.brand.toLowerCase().contains(query) &&
              !guitar.type.toLowerCase().contains(query)) {
            return false;
          }
        }

        // Apply type filter
        if (selectedTypes.isNotEmpty && !selectedTypes.contains(guitar.type)) {
          return false;
        }

        // Apply brand filter
        if (selectedBrands.isNotEmpty && !selectedBrands.contains(guitar.brand)) {
          return false;
        }

        // Apply price range filter
        if (selectedPriceRange != null) {
          final min = selectedPriceRange!['min'] as num;
          final max = selectedPriceRange!['max'] as num;
          if (guitar.price < min || guitar.price > max) {
            return false;
          }
        }

        return true;
      }).toList();

      // Apply sorting
      switch (currentSort) {
        case SortOption.nameAsc:
          filteredGuitars.sort((a, b) => a.name.compareTo(b.name));
          break;
        case SortOption.nameDesc:
          filteredGuitars.sort((a, b) => b.name.compareTo(a.name));
          break;
        case SortOption.priceHighToLow:
          filteredGuitars.sort((a, b) => b.price.compareTo(a.price));
          break;
        case SortOption.priceLowToHigh:
          filteredGuitars.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortOption.brand:
          filteredGuitars.sort((a, b) => a.brand.compareTo(b.brand));
          break;
      }
    });
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterSheet(
        selectedTypes: selectedTypes,
        selectedBrands: selectedBrands,
        selectedPriceRange: selectedPriceRange,
        currentSort: currentSort,
        onTypesChanged: (types) {
          setState(() {
            selectedTypes = types;
            _applyFilters(_searchController.text);
          });
        },
        onBrandsChanged: (brands) {
          setState(() {
            selectedBrands = brands;
            _applyFilters(_searchController.text);
          });
        },
        onPriceRangeChanged: (range) {
          setState(() {
            selectedPriceRange = range;
            _applyFilters(_searchController.text);
          });
        },
        onSortChanged: (sort) {
          setState(() {
            currentSort = sort;
            _applyFilters(_searchController.text);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(        title: Container(          height: 40,          decoration: BoxDecoration(            color: Theme.of(context).colorScheme.surface,            borderRadius: BorderRadius.circular(20),            boxShadow: [              BoxShadow(                color: Colors.black.withOpacity(0.1),                blurRadius: 4,                offset: const Offset(0, 2),              ),            ],          ),          child: TextField(            controller: _searchController,            decoration: InputDecoration(              hintText: 'Search guitars...',              prefixIcon: const Icon(Icons.search),              suffixIcon: _searchController.text.isNotEmpty                ? IconButton(                    icon: const Icon(Icons.clear),                    onPressed: () {                      _searchController.clear();                      _applyFilters('');                    },                  )                : null,              border: InputBorder.none,              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),              hintStyle: TextStyle(color: Theme.of(context).hintColor),            ),            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),            onChanged: _applyFilters,          ),        ),        actions: [          IconButton(            icon: const Icon(Icons.filter_list),            onPressed: _showFilterSheet,          ),        ],      ),
      body: Column(
        children: [
          Expanded(
            child: filteredGuitars.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.music_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No guitars found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: filteredGuitars.length,
                    itemBuilder: (context, index) {
                      return GuitarCard(
                        guitar: filteredGuitars[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransitions.slideTransition(
                              page: GuitarDetailScreen(guitar: filteredGuitars[index]),
                              duration: const Duration(milliseconds: 500),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
