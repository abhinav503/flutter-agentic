import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/base/bloc_cache.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/usecase/usecase.dart';

import '../../domain/entities/address_entity.dart';
import '../../domain/usecase/create_address_usecase.dart';
import '../../domain/usecase/get_addresses_usecase.dart';
import '../../domain/usecase/update_address_usecase.dart';
import '../view/address_page.dart' show kSelectedAddressIdPrefKey;

part 'address_bloc.freezed.dart';
part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddressesUseCase _getAddresses;
  final CreateAddressUseCase _createAddress;
  final UpdateAddressUseCase _updateAddress;

  // Warm-start cache: reopening Select Address seeds straight into loaded
  // instead of the skeleton; started then refreshes silently. Only the
  // fetched list is cached — the selection is re-resolved from prefs +
  // default at seed time, not cached view state.
  static final _cache = BlocCache<List<AddressEntity>>();

  @visibleForTesting
  static void resetCache() => _cache.reset();

  AddressBloc({
    required GetAddressesUseCase getAddressesUseCase,
    required CreateAddressUseCase createAddressUseCase,
    required UpdateAddressUseCase updateAddressUseCase,
  }) : _getAddresses = getAddressesUseCase,
       _createAddress = createAddressUseCase,
       _updateAddress = updateAddressUseCase,
       super(
         _cache.seed(
           warm: (addresses) => AddressState.loaded(
             addresses: addresses,
             selectedAddressId: _resolveSelectedId(addresses),
           ),
           cold: AddressState.loading,
         ),
       ) {
    on<AddressStarted>(_onStarted);
    on<AddressSelected>(_onSelected);
    on<AddressSaved>(_onSaved);
  }

  /// The last-confirmed selection (prefs) when it still exists, else the
  /// default address, else the first — '' only when the list is empty.
  static String _resolveSelectedId(List<AddressEntity> addresses) {
    if (addresses.isEmpty) return '';
    final savedId = SharedPreferenceService.instance.getString(
      kSelectedAddressIdPrefKey,
    );
    final defaultId = addresses
        .firstWhere((a) => a.isDefault, orElse: () => addresses.first)
        .id;
    return addresses.any((a) => a.id == savedId) ? savedId! : defaultId;
  }

  Future<void> _onStarted(
    AddressStarted event,
    Emitter<AddressState> emit,
  ) async {
    final result = await _getAddresses(const NoParams());
    result.fold((failure) {
      switch (state) {
        // Warm start: a failed silent refresh isn't worth replacing a
        // usable list with an error view — the cached data stands.
        case AddressLoaded():
          break;
        case AddressLoading():
        case AddressError():
          emit(AddressState.error(message: failure.message));
      }
    }, (addresses) => _emitAddresses(addresses, emit));
  }

  /// Single emit path for fetched/saved lists — keeps the warm cache in
  /// step, and keeps the current in-session selection when it survives the
  /// new list (falling back to prefs/default resolution otherwise).
  void _emitAddresses(List<AddressEntity> addresses, Emitter<AddressState> emit) {
    _cache.save(addresses);
    final currentSelectedId = switch (state) {
      AddressLoaded(:final selectedAddressId) => selectedAddressId,
      AddressLoading() || AddressError() => null,
    };
    final selectedId =
        currentSelectedId != null &&
            addresses.any((a) => a.id == currentSelectedId)
        ? currentSelectedId
        : _resolveSelectedId(addresses);
    emit(
      AddressState.loaded(addresses: addresses, selectedAddressId: selectedId),
    );
  }

  void _onSelected(AddressSelected event, Emitter<AddressState> emit) {
    switch (state) {
      case AddressLoaded(:final addresses):
        emit(
          AddressState.loaded(
            addresses: addresses,
            selectedAddressId: event.addressId,
          ),
        );
      case AddressLoading():
      case AddressError():
        break;
    }
  }

  Future<void> _onSaved(AddressSaved event, Emitter<AddressState> emit) async {
    switch (state) {
      case AddressLoaded():
        final isNew = event.address.id.isEmpty;
        final result = isNew
            ? await _createAddress(event.address)
            : await _updateAddress(event.address);
        // Re-read state after the await — a selection tap may have landed
        // while the save was in flight.
        switch (state) {
          case AddressLoaded(:final addresses, :final selectedAddressId):
            result.fold(
              (_) => emit(
                AddressState.loaded(
                  addresses: addresses,
                  selectedAddressId: selectedAddressId,
                  saveFailed: true,
                ),
              ),
              (saved) {
                // The server-returned entity, not event.address — create
                // assigns the id (and the default flag for a first address).
                final updated = isNew
                    ? [...addresses, saved]
                    : [for (final a in addresses) a.id == saved.id ? saved : a];
                _cache.save(updated);
                emit(
                  AddressState.loaded(
                    addresses: updated,
                    selectedAddressId: isNew ? saved.id : selectedAddressId,
                  ),
                );
              },
            );
          case AddressLoading():
          case AddressError():
            break;
        }
      case AddressLoading():
      case AddressError():
        break;
    }
  }
}
