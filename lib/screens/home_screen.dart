import 'package:flutter/material.dart';
import '../models/guitar.dart';
import '../widgets/guitar_card.dart';
import '../widgets/filter_sheet.dart';
import '../screens/guitar_detail_screen.dart';

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
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: FilterSheet(
              selectedTypes: selectedTypes,
              selectedBrands: selectedBrands,
              selectedPriceRange: selectedPriceRange,
              currentSort: currentSort,
              onTypesChanged: (types) {
                setState(() => selectedTypes = types);
                _applyFilters(_searchController.text);
              },
              onBrandsChanged: (brands) {
                setState(() => selectedBrands = brands);
                _applyFilters(_searchController.text);
              },
              onPriceRangeChanged: (range) {
                setState(() => selectedPriceRange = range);
                _applyFilters(_searchController.text);
              },
              onSortChanged: (sort) {
                setState(() => currentSort = sort);
                _applyFilters(_searchController.text);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue'),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: _showFilterSheet,
              ),
              if (selectedTypes.isNotEmpty ||
                  selectedBrands.isNotEmpty ||
                  selectedPriceRange != null)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${selectedTypes.length + selectedBrands.length + (selectedPriceRange != null ? 1 : 0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _applyFilters,
              decoration: InputDecoration(
                hintText: 'Search guitars...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          if (selectedTypes.isNotEmpty ||
              selectedBrands.isNotEmpty ||
              selectedPriceRange != null)
            Container(
              height: 32,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...selectedTypes.map(
                    (type) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(type),
                        onDeleted: () {
                          setState(() {
                            selectedTypes.remove(type);
                          });
                          _applyFilters(_searchController.text);
                        },
                      ),
                    ),
                  ),
                  ...selectedBrands.map(
                    (brand) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(brand),
                        onDeleted: () {
                          setState(() {
                            selectedBrands.remove(brand);
                          });
                          _applyFilters(_searchController.text);
                        },
                      ),
                    ),
                  ),
                  if (selectedPriceRange != null)
                    Chip(
                      label: Text(selectedPriceRange!['label']),
                      onDeleted: () {
                        setState(() {
                          selectedPriceRange = null;
                        });
                        _applyFilters(_searchController.text);
                      },
                    ),
                ],
              ),
            ),
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
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                GuitarDetailScreen(guitar: filteredGuitars[index]),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 400),
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
