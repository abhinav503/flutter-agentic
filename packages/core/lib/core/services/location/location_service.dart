import 'package:geolocator/geolocator.dart';

/// Why [LocationService.currentPosition] produced no position.
enum LocationFailureReason { serviceDisabled, permissionDenied, unavailable }

sealed class LocationResult {
  const LocationResult();
}

class LocationSuccess extends LocationResult {
  final double latitude;
  final double longitude;
  const LocationSuccess({required this.latitude, required this.longitude});
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

  Future<LocationResult> _resolve() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationUnavailable(
          LocationFailureReason.serviceDisabled,
        );
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
