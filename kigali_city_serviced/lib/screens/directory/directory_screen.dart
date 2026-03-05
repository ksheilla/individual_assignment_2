import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/listing_provider.dart';
import '../../models/listing_model.dart';
import '../../utils/constants.dart';
import 'listing_detail_screen.dart';
import 'create_listing_screen.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({Key? key}) : super(key: key);

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directory'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateListingScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search listings...',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF94A3B8),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              context.read<ListingProvider>().searchListings(
                                '',
                              );
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<ListingProvider>().searchListings(value);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppConstants.categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Consumer<ListingProvider>(
                            builder: (context, provider, _) {
                              return FilterChip(
                                label: const Text('All'),
                                selected: provider.selectedCategory == null,
                                backgroundColor: const Color(0xFF1A1F3A),
                                selectedColor: AppConstants.primaryColor,
                                labelStyle: TextStyle(
                                  color: provider.selectedCategory == null
                                      ? Colors.white
                                      : Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                onSelected: (_) {
                                  provider.filterByCategory(null);
                                },
                              );
                            },
                          ),
                        );
                      }

                      final category = AppConstants.categories[index - 1];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Consumer<ListingProvider>(
                          builder: (context, provider, _) {
                            return FilterChip(
                              label: Text(category),
                              selected: provider.selectedCategory == category,
                              backgroundColor: const Color(0xFF1A1F3A),
                              selectedColor: AppConstants.primaryColor,
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              onSelected: (_) {
                                provider.filterByCategory(category);
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ListingProvider>(
              builder: (context, listingProvider, _) {
                if (listingProvider.isLoading &&
                    listingProvider.allListings.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (listingProvider.allListings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_city,
                          size: 80,
                          color: const Color(0xFF94A3B8),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No listings found',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters or search',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: const Color(0xFFCBD5E1)),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: listingProvider.allListings.length,
                  itemBuilder: (context, index) {
                    final listing = listingProvider.allListings[index];
                    return _ListingCard(
                      listing: listing,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ListingDetailScreen(listing: listing),
                          ),
                        );
                      },
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

class _ListingCard extends StatelessWidget {
  final ListingModel listing;
  final VoidCallback onTap;

  const _ListingCard({required this.listing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          listing.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              listing.category,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFCBD5E1),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    listing.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF0F766E),
        ),
        onTap: onTap,
      ),
    );
  }
}
