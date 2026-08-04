part of 'address_bloc.dart';

@freezed
sealed class AddressState with _$AddressState {
  const factory AddressState.loading() = AddressLoading;
  const factory AddressState.loaded({
    required List<AddressEntity> addresses,
    required String selectedAddressId,
    // One-shot "couldn't save" signal for the screen's snackbar. The list
    // keeps its pre-save contents (saves aren't optimistic — nothing to
    // roll back); the next selection/save emit resets it via the default.
    @Default(false) bool saveFailed,
    // Same one-shot pattern as [saveFailed], for a failed delete.
    @Default(false) bool deleteFailed,
    // True for one emission when a silent background refresh (a warm start
    // seeded from AddressBloc's cached data) fails — the already-visible
    // cached content stays on screen; the listener surfaces this via a
    // snackbar instead of replacing it with the error view. Cleared the same
    // way [saveFailed] is: every later emission rebuilds the state fresh, so
    // the default takes over.
    @Default(false) bool refreshFailed,
  }) = AddressLoaded;
  const factory AddressState.error({required String message}) = AddressError;
}
