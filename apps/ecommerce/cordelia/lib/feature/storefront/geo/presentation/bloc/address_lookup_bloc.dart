import 'package:core/core/error/failure.dart';
import 'package:core/core/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:cordelia/utils/event_transformers.dart';

import '../../domain/entities/geo_address_entity.dart';
import '../../domain/entities/pincode_info_entity.dart';
import '../../domain/entities/place_suggestion_entity.dart';
import '../../domain/usecase/get_current_location_address_usecase.dart';
import '../../domain/usecase/lookup_pincode_usecase.dart';
import '../../domain/usecase/reverse_geocode_usecase.dart';
import '../../domain/usecase/search_places_usecase.dart';

part 'address_lookup_bloc.freezed.dart';
part 'address_lookup_event.dart';
part 'address_lookup_state.dart';

/// The address form's location helpers — "use my location", address
/// type-ahead, and pincode autofill. One bloc, screen-scoped (provided in
/// the form page's `buildBody`), because all three feed the same form.
class AddressLookupBloc extends Bloc<AddressLookupEvent, AddressLookupState> {
  final GetCurrentLocationAddressUseCase _getCurrentLocationAddress;
  final ReverseGeocodeUseCase _reverseGeocode;
  final SearchPlacesUseCase _searchPlaces;
  final LookupPincodeUseCase _lookupPincode;

  AddressLookupBloc({
    required GetCurrentLocationAddressUseCase getCurrentLocationAddressUseCase,
    required ReverseGeocodeUseCase reverseGeocodeUseCase,
    required SearchPlacesUseCase searchPlacesUseCase,
    required LookupPincodeUseCase lookupPincodeUseCase,
  }) : _getCurrentLocationAddress = getCurrentLocationAddressUseCase,
       _reverseGeocode = reverseGeocodeUseCase,
       _searchPlaces = searchPlacesUseCase,
       _lookupPincode = lookupPincodeUseCase,
       super(const AddressLookupState.idle()) {
    on<AddressLookupLocationRequested>(_onLocationRequested);
    on<AddressLookupQueryChanged>(
      _onQueryChanged,
      transformer: debounceRestartable(const Duration(milliseconds: 350)),
    );
    on<AddressLookupSuggestionSelected>(_onSuggestionSelected);
    on<AddressLookupPincodeEntered>(_onPincodeEntered);
  }

  Future<void> _onLocationRequested(
    AddressLookupLocationRequested event,
    Emitter<AddressLookupState> emit,
  ) async {
    emit(const AddressLookupState.locating());
    final result = await _getCurrentLocationAddress(const NoParams());
    result.fold(
      (failure) => emit(
        AddressLookupState.error(
          message: failure.message,
          isLocation: failure is LocationFailure,
        ),
      ),
      (address) => emit(AddressLookupState.prefillReady(address: address)),
    );
  }

  Future<void> _onQueryChanged(
    AddressLookupQueryChanged event,
    Emitter<AddressLookupState> emit,
  ) async {
    final query = event.query.trim();
    // Matches the server's own minimum — below it there's nothing to
    // suggest, so clear the list without a round trip.
    if (query.length < 3) {
      emit(const AddressLookupState.idle());
      return;
    }
    final result = await _searchPlaces(SearchPlacesParams(query: query));
    result.fold(
      (failure) => emit(
        AddressLookupState.error(
          message: failure.message,
          isLocation: false,
          query: query,
        ),
      ),
      (suggestions) => emit(
        AddressLookupState.suggestions(query: query, suggestions: suggestions),
      ),
    );
  }

  Future<void> _onSuggestionSelected(
    AddressLookupSuggestionSelected event,
    Emitter<AddressLookupState> emit,
  ) async {
    final suggestion = event.suggestion;
    final latitude = suggestion.latitude;
    final longitude = suggestion.longitude;
    // No coordinates on the suggestion → nothing to reverse-geocode; the
    // description alone still prefills the address line.
    if (latitude == null || longitude == null) {
      emit(
        AddressLookupState.prefillReady(
          address: GeoAddressEntity(
            formatted: suggestion.description,
            addressLine: suggestion.description,
            city: '',
            state: '',
            postalCode: '',
            country: '',
          ),
        ),
      );
      return;
    }
    emit(const AddressLookupState.locating());
    final result = await _reverseGeocode(
      ReverseGeocodeParams(latitude: latitude, longitude: longitude),
    );
    result.fold(
      (failure) => emit(
        AddressLookupState.error(
          message: failure.message,
          isLocation: failure is LocationFailure,
        ),
      ),
      (address) => emit(AddressLookupState.prefillReady(address: address)),
    );
  }

  Future<void> _onPincodeEntered(
    AddressLookupPincodeEntered event,
    Emitter<AddressLookupState> emit,
  ) async {
    final result = await _lookupPincode(
      LookupPincodeParams(pincode: event.pincode),
    );
    // Best-effort autofill: unknown pincode (null) and lookup failures both
    // stay silent — a flaky upstream must never block hand-typing the form.
    result.fold((_) {}, (info) {
      if (info != null) emit(AddressLookupState.pincodeReady(info: info));
    });
  }
}
