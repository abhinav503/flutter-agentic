part of 'address_bloc.dart';

@freezed
sealed class AddressState with _$AddressState {
  const factory AddressState.loading() = AddressLoading;
  const factory AddressState.loaded({
    required List<AddressEntity> addresses,
    required String selectedAddressId,
  }) = AddressLoaded;
  const factory AddressState.error({required String message}) = AddressError;
}
