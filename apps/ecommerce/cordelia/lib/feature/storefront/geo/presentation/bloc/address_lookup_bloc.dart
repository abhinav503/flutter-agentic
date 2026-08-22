import 'package:core/core/error/failure.dart';
import 'package:core/core/services/location/location_service.dart'
    show LocationFailureReason;
import 'package:core/core/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/geo_address_entity.dart';
import '../../domain/entities/pincode_info_entity.dart';
import '../../domain/usecase/get_current_location_address_usecase.dart';
import '../../domain/usecase/lookup_pincode_usecase.dart';

part 'address_lookup_bloc.freezed.dart';
part 'address_lookup_event.dart';
part 'address_lookup_state.dart';

/// The address form's two location helpers — "use my location" and pincode
/// autofill. One bloc, screen-scoped (provided in the form page's
/// `buildBody`), because both feed the same form.
///
/// Address type-ahead used to live here too, against an Ola Maps proxy.
/// It is gone rather than reimplemented: every place-autocomplete service
/// worth using needs a billed API key, and the device geocoder that replaced
/// the reverse lookup does not do search.
class AddressLookupBloc extends Bloc<AddressLookupEvent, AddressLookupState> {
  final GetCurrentLocationAddressUseCase _getCurrentLocationAddress;
  final LookupPincodeUseCase _lookupPincode;

  AddressLookupBloc({
    required GetCurrentLocationAddressUseCase getCurrentLocationAddressUseCase,
    required LookupPincodeUseCase lookupPincodeUseCase,
  }) : _getCurrentLocationAddress = getCurrentLocationAddressUseCase,
       _lookupPincode = lookupPincodeUseCase,
       super(const AddressLookupState.idle()) {
    on<AddressLookupLocationRequested>(_onLocationRequested);
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
          reason: switch (failure) {
            LocationFailure(:final reason) => reason,
            _ => null,
          },
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
