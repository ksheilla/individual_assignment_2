import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/listing_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/listing_provider.dart';
import 'edit_listing_screen.dart';

class ListingDetailScreen extends StatefulWidget {
  final ListingModel listing;

  const ListingDetailScreen({
    required this.listing,
  });

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  late GoogleMapController mapController;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  Future<void> _checkIfBookmarked() async {
    final authProvider = context.read<AuthProvider>();
    final listingProvider = context.read<ListingProvider>();
    
    if (authProvider.currentUser != null) {
      final isBookmarked = listingProvider.isListingBookmarked(
        widget.listing.id,
        authProvider.currentUser!.uid,
      );
      setState(() => _isBookmarked = isBookmarked);
    }
  }

  Future<void> _launchDirections() async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${widget.listing.latitude},${widget.listing.longitude}',
    );

    if (!await canLaunchUrl(uri)) {
      debugPrint('Could not launch directions URL: $uri');
      return;
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      debugPrint('Failed to launch directions URL: $uri');
    }
  }

  Future<void> _launchCall() async {
    final url = 'tel:${widget.listing.contactNumber}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _toggleBookmark(AuthProvider authProvider, ListingProvider listingProvider) async {
    if (!_isBookmarked) {
      await listingProvider.addBookmark(
        widget.listing.id,
        authProvider.currentUser!.uid,
      );
    } else {
      await listingProvider.removeBookmark(
        widget.listing.id,
        authProvider.currentUser!.uid,
      );
    }
    setState(() => _isBookmarked = !_isBookmarked);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked ? 'Added to bookmarks' : 'Removed from bookmarks',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Details'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              final isOwner = authProvider.currentUser?.uid == widget.listing.createdBy;
              
              return PopupMenuButton(
                itemBuilder: (context) => [
                  if (isOwner)
                    PopupMenuItem(
                      child: const Text('Edit'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditListingScreen(listing: widget.listing),
                          ),
                        );
                      },
                    ),
                  if (isOwner)
                    PopupMenuItem(
                      child: const Text('Delete'),
                      onTap: () => _showDeleteConfirmation(),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map
            Container(
              height: 250,
              color: Colors.grey[300],
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.listing.latitude,
                    widget.listing.longitude,
                  ),
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  mapController = controller;
                },
                markers: {
                  Marker(
                    markerId: MarkerId(widget.listing.id),
                    position: LatLng(
                      widget.listing.latitude,
                      widget.listing.longitude,
                    ),
                  ),
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.listing.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                widget.listing.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          if (authProvider.currentUser == null) {
                            return const SizedBox();
                          }

                          return Consumer<ListingProvider>(
                            builder: (context, listingProvider, _) {
                              return IconButton(
                                icon: Icon(
                                  _isBookmarked
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: _isBookmarked
                                      ? Colors.blue[900]
                                      : Colors.grey,
                                  size: 28,
                                ),
                                onPressed: () => _toggleBookmark(
                                  authProvider,
                                  listingProvider,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Address
                  _InfoSection(
                    icon: Icons.location_on,
                    title: 'Address',
                    content: widget.listing.address,
                  ),
                  const SizedBox(height: 16),

                  // Contact
                  _InfoSection(
                    icon: Icons.phone,
                    title: 'Contact Number',
                    content: widget.listing.contactNumber,
                    onTap: _launchCall,
                  ),
                  const SizedBox(height: 16),

                  // Description
                  _InfoSection(
                    icon: Icons.description,
                    title: 'Description',
                    content: widget.listing.description,
                  ),
                  const SizedBox(height: 20),

                  // Navigation button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _launchDirections,
                      icon: const Icon(Icons.navigation),
                      label: const Text('Get Directions'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Listing'),
        content: const Text('Are you sure you want to delete this listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<ListingProvider>().deleteListing(
                widget.listing.id,
              );
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Listing deleted')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final VoidCallback? onTap;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.content,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue[900]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
