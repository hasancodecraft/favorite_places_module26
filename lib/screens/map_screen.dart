import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/favorite_locations.dart';
import '../models/favorite_location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  bool _isLoadingLocation = false;
  bool _hasLocationPermission = false;
  Position? _currentPosition;
  String _locationMessage = 'Tap My Location to find your current position.';

  @override
  void initState() {
    super.initState();
    _addFavoriteMarkers();
  }

  void _addFavoriteMarkers() {
    for (final location in favoriteLocations) {
      _markers.add(
        Marker(
          markerId: MarkerId('favorite_${location.id}'),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: location.name,
            snippet: 'ID: ${location.id}',
          ),
          consumeTapEvents: true,
          onTap: () => _showLocationDetails(location),
        ),
      );
    }
  }

  void _showLocationDetails(FavoriteLocation location) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Favorite Location'),
          content: SingleChildScrollView(
            child: Text(
              'ID: ${location.id}\n\n'
              'Name: ${location.name}\n\n'
              'Latitude: ${location.latitude}\n\n'
              'Longitude: ${location.longitude}',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFavoriteLocations() async {
    final selectedLocation = await showModalBottomSheet<FavoriteLocation>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Favorite Locations',
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                ),
                for (final location in favoriteLocations)
                  ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: Text(location.name),
                    subtitle: Text('ID: ${location.id}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pop(sheetContext, location),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selectedLocation == null) return;

    await _moveCamera(
      LatLng(selectedLocation.latitude, selectedLocation.longitude),
    );
  }

  Future<void> _moveCamera(LatLng position) async {
    final controller = _mapController;
    if (controller == null) return;

    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 16),
        ),
      );
    } catch (_) {
      if (mounted) {
        _showMessage('Could not move the map. Please try again.');
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_isLoadingLocation || _mapController == null) return;

    setState(() {
      _isLoadingLocation = true;
      _currentPosition = null;
      _hasLocationPermission = false;
      _markers.removeWhere(
        (marker) => marker.markerId.value == 'current_location',
      );
      _locationMessage = 'Getting your current location...';
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!mounted) return;

      if (!serviceEnabled) {
        _showMessage(
          'Turn on location services, then tap My Location again.',
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () {
              Geolocator.openLocationSettings();
            },
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (!mounted) return;

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (!mounted) return;
      }

      if (permission == LocationPermission.deniedForever) {
        _showMessage(
          'Allow location access in app settings, then try again.',
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () {
              Geolocator.openAppSettings();
            },
          ),
        );
        return;
      }

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _showMessage('Location permission is needed to show your position.');
        return;
      }

      setState(() {
        _hasLocationPermission = true;
      });

      // The user's coordinates come only from the device's location service.
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
      if (!mounted) return;

      final currentLatLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = position;
        _locationMessage = 'Current location';
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: currentLatLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
            infoWindow: const InfoWindow(title: 'My Location'),
          ),
        );
      });

      await _moveCamera(currentLatLng);
    } on TimeoutException {
      _showMessage('Location took too long. Check GPS and try again.');
    } catch (_) {
      _showMessage('Could not get your location. Check permission and GPS.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _showMessage(String message, {SnackBarAction? action}) {
    if (!mounted) return;

    setState(() {
      _locationMessage = message;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: action,
          duration: const Duration(seconds: 6),
        ),
      );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapReady = _mapController != null;
    final position = _currentPosition;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Places'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GoogleMap(
                // This is the starting map view, not the user's location.
                initialCameraPosition: const CameraPosition(
                  target: LatLng(23.7336, 90.3955),
                  zoom: 14,
                ),
                onMapCreated: (controller) {
                  if (!mounted) {
                    controller.dispose();
                    return;
                  }
                  setState(() {
                    _mapController = controller;
                  });
                },
                markers: Set<Marker>.of(_markers),
                myLocationEnabled: _hasLocationPermission,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                mapToolbarEnabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _locationMessage,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (position != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Latitude: ${position.latitude.toStringAsFixed(6)}\n'
                      'Longitude: ${position.longitude.toStringAsFixed(6)}',
                    ),
                  ],
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: mapReady && !_isLoadingLocation
                        ? _getCurrentLocation
                        : null,
                    icon: _isLoadingLocation
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location),
                    label: Text(
                      _isLoadingLocation ? 'Getting Location...' : 'My Location',
                    ),
                  ),
                  const SizedBox(height: 6),
                  OutlinedButton.icon(
                    onPressed: mapReady && !_isLoadingLocation
                        ? _showFavoriteLocations
                        : null,
                    icon: const Icon(Icons.star_outline),
                    label: const Text('Favorite Locations'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
