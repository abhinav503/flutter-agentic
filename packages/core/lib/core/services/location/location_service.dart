import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Why [LocationService.currentPosition] produced no position.
enum LocationFailureReason { serviceDisabled, permissionDenied, unavailable }

sealed class LocationResult {
  const LocationResult();
}

class LocationSuccess extends LocationResult {
  final double latitude;
  final double longitude;

  /// The device geocoder's own vocabulary, filled by
  /// [LocationService.currentPlace] and empty from
  /// [LocationService.currentPosition] — the coordinates always resolve, the
  /// names behind them may not. Kept as the platform's flat fields rather
  /// than any app's address shape, so this stays a device service.
  final String street;
  final String subLocality;
  final String locality;
  final String administrativeArea;
  final String postalCode;
  final String country;

  const LocationSuccess({
    required this.latitude,
    required this.longitude,
    this.street = '',
    this.subLocality = '',
    this.locality = '',
    this.administrativeArea = '',
    this.postalCode = '',
    this.country = '',
  });

  /// True when the device's geocoder gave back something worth printing.
  /// A fix with no name is still a fix, so callers that only need
  /// coordinates ignore this.
  bool get hasPlace =>
      postalCode.isNotEmpty || locality.isNotEmpty || street.isNotEmpty;

  /// The one-line address the flat fields add up to, in the order every
  /// locale this app ships reads them: narrowest first.
  String get formattedAddress => [
    street,
    subLocality,
    locality,
    administrativeArea,
    postalCode,
    country,
  ].where((part) => part.isNotEmpty).join(', ');
}

class LocationUnavailable extends LocationResult {
  final LocationFailureReason reason;
  const LocationUnavailable(this.reason);
}

/// One-shot device position with the permission dance handled — returns a
/// result instead of throwing, so callers switch on it rather than catch.
/// geolocator ships a web implementation (the browser prompt), so there is
/// no `kIsWeb` guard here.
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  // Re-entrancy: a second tap while the permission prompt/fix is pending
  // joins the same request instead of stacking another prompt (the same
  // guard ImagePickerService keeps with _isOpen).
  Future<LocationResult>? _inFlight;

  Future<LocationResult> currentPosition() =>
      _inFlight ??= _resolve().whenComplete(() => _inFlight = null);

  /// A fix *and* the postcode/locality behind it, resolved on the device's
  /// own geocoder — no API key, no quota, and nothing to authenticate, which
  /// is what lets a signed-out user ask "where am I?".
  ///
  /// The geocode is best-effort: a device with no network, no Play services
  /// (Android's Geocoder is backed by them) or an Apple throttle returns the
  /// coordinates with empty names rather than failing the whole call. A fix
  /// is the part the caller cannot get any other way.
  Future<LocationResult> currentPlace() async {
    final position = await currentPosition();
    if (position is! LocationSuccess) return position;
    // No web implementation — the platform channel would throw. A browser
    // caller keeps the coordinates it already has.
    if (kIsWeb) return position;

    try {
      final places = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (places.isEmpty) return position;
      final place = places.first;
      return LocationSuccess(
        latitude: position.latitude,
        longitude: position.longitude,
        street: place.street ?? '',
        subLocality: place.subLocality ?? '',
        locality: (place.locality?.isNotEmpty ?? false)
            ? place.locality!
            : place.subAdministrativeArea ?? '',
        administrativeArea: place.administrativeArea ?? '',
        postalCode: place.postalCode ?? '',
        country: place.country ?? '',
      );
    } on Exception {
      return position;
    }
  }

  Future<LocationResult> _resolve() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationUnavailable(LocationFailureReason.serviceDisabled);
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return const LocationUnavailable(
          LocationFailureReason.permissionDenied,
        );
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          // Without a limit a device that can't get a fix (indoors, no GPS)
          // hangs the caller's loading state forever.
          timeLimit: Duration(seconds: 15),
        ),
      );
      return LocationSuccess(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on Exception {
      // Timeout, platform quirk, or a web browser denying mid-flight — all
      // the same "couldn't get a fix" to the caller.
      return const LocationUnavailable(LocationFailureReason.unavailable);
    }
  }
}
