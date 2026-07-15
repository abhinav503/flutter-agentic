import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:core/core/usecase/usecase.dart';

import '../../domain/entities/address_entity.dart';
import '../../domain/usecase/get_addresses_usecase.dart';
import '../view/address_page.dart' show kSelectedAddressIdPrefKey;

part 'address_bloc.freezed.dart';
part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddressesUseCase _getAddresses;

  AddressBloc({required GetAddressesUseCase getAddressesUseCase})
      : _getAddresses = getAddressesUseCase,
        super(const AddressState.loading()) {
    on<AddressStarted>(_onStarted);
    on<AddressSelected>(_onSelected);
  }

  Future<void> _onStarted(AddressStarted event, Emitter<AddressState> emit) async {
    final result = await _getAddresses(const NoParams());
    result.fold(
      (failure) => emit(AddressState.error(message: failure.message)),
      (addresses) {
        if (addresses.isEmpty) {
          emit(const AddressState.loaded(addresses: [], selectedAddressId: ''));
          return;
        }
        final savedId =
            SharedPreferenceService.instance.getString(kSelectedAddressIdPrefKey);
        final defaultId = addresses
            .firstWhere((a) => a.isDefault, orElse: () => addresses.first)
            .id;
        final selectedId =
            addresses.any((a) => a.id == savedId) ? savedId! : defaultId;
        emit(AddressState.loaded(addresses: addresses, selectedAddressId: selectedId));
      },
    );
  }

  void _onSelected(AddressSelected event, Emitter<AddressState> emit) {
    switch (state) {
      case AddressLoaded(:final addresses):
        emit(AddressState.loaded(
          addresses: addresses,
          selectedAddressId: event.addressId,
        ));
      case AddressLoading():
      case AddressError():
        break;
    }
  }
}
