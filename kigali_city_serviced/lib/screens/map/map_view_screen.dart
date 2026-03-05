import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/listing_provider.dart';
import '../directory/listing_detail_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    await context.read<ListingProvider>().loadAllListings();
    final listings = context.read<ListingProvider>().allListings;

    final newMarkers = <Marker>{};
    for (final listing in listings) {
      newMarkers.add(
        Marker(
          markerId: MarkerId(listing.id),
          position: LatLng(listing.latitude, listing.longitude),
          infoWindow: InfoWindow(
            title: listing.name,
            snippet: listing.category,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ListingDetailScreen(listing: listing),
                ),
              );
            },
          ),
        ),
      );
    }

    setState(() => markers = newMarkers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: Consumer<ListingProvider>(
        builder: (context, listingProvider, _) {
          return GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(-1.9536, 30.0606), // Kigali center
              zoom: 13,
            ),
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            compassEnabled: true,
            minMaxZoomPreference: const MinMaxZoomPreference(0, 20),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadMarkers,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
