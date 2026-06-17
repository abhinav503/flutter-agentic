// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'doc_scanner_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocScannerEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocScannerEvent()';
}


}

/// @nodoc
class $DocScannerEventCopyWith<$Res>  {
$DocScannerEventCopyWith(DocScannerEvent _, $Res Function(DocScannerEvent) __);
}


/// Adds pattern-matching-related methods to [DocScannerEvent].
extension DocScannerEventPatterns on DocScannerEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DocScannerStarted value)?  started,TResult Function( DocScannerCameraRequested value)?  cameraRequested,TResult Function( DocScannerGalleryRequested value)?  galleryRequested,TResult Function( DocScannerReceiptRemoved value)?  receiptRemoved,TResult Function( DocScannerExtractionRetried value)?  extractionRetried,TResult Function( DocScannerSelectionToggled value)?  selectionToggled,TResult Function( DocScannerPdfRequested value)?  pdfRequested,TResult Function( DocScannerReceiptEdited value)?  receiptEdited,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DocScannerStarted() when started != null:
return started(_that);case DocScannerCameraRequested() when cameraRequested != null:
return cameraRequested(_that);case DocScannerGalleryRequested() when galleryRequested != null:
return galleryRequested(_that);case DocScannerReceiptRemoved() when receiptRemoved != null:
return receiptRemoved(_that);case DocScannerExtractionRetried() when extractionRetried != null:
return extractionRetried(_that);case DocScannerSelectionToggled() when selectionToggled != null:
return selectionToggled(_that);case DocScannerPdfRequested() when pdfRequested != null:
return pdfRequested(_that);case DocScannerReceiptEdited() when receiptEdited != null:
return receiptEdited(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DocScannerStarted value)  started,required TResult Function( DocScannerCameraRequested value)  cameraRequested,required TResult Function( DocScannerGalleryRequested value)  galleryRequested,required TResult Function( DocScannerReceiptRemoved value)  receiptRemoved,required TResult Function( DocScannerExtractionRetried value)  extractionRetried,required TResult Function( DocScannerSelectionToggled value)  selectionToggled,required TResult Function( DocScannerPdfRequested value)  pdfRequested,required TResult Function( DocScannerReceiptEdited value)  receiptEdited,}){
final _that = this;
switch (_that) {
case DocScannerStarted():
return started(_that);case DocScannerCameraRequested():
return cameraRequested(_that);case DocScannerGalleryRequested():
return galleryRequested(_that);case DocScannerReceiptRemoved():
return receiptRemoved(_that);case DocScannerExtractionRetried():
return extractionRetried(_that);case DocScannerSelectionToggled():
return selectionToggled(_that);case DocScannerPdfRequested():
return pdfRequested(_that);case DocScannerReceiptEdited():
return receiptEdited(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DocScannerStarted value)?  started,TResult? Function( DocScannerCameraRequested value)?  cameraRequested,TResult? Function( DocScannerGalleryRequested value)?  galleryRequested,TResult? Function( DocScannerReceiptRemoved value)?  receiptRemoved,TResult? Function( DocScannerExtractionRetried value)?  extractionRetried,TResult? Function( DocScannerSelectionToggled value)?  selectionToggled,TResult? Function( DocScannerPdfRequested value)?  pdfRequested,TResult? Function( DocScannerReceiptEdited value)?  receiptEdited,}){
final _that = this;
switch (_that) {
case DocScannerStarted() when started != null:
return started(_that);case DocScannerCameraRequested() when cameraRequested != null:
return cameraRequested(_that);case DocScannerGalleryRequested() when galleryRequested != null:
return galleryRequested(_that);case DocScannerReceiptRemoved() when receiptRemoved != null:
return receiptRemoved(_that);case DocScannerExtractionRetried() when extractionRetried != null:
return extractionRetried(_that);case DocScannerSelectionToggled() when selectionToggled != null:
return selectionToggled(_that);case DocScannerPdfRequested() when pdfRequested != null:
return pdfRequested(_that);case DocScannerReceiptEdited() when receiptEdited != null:
return receiptEdited(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  cameraRequested,TResult Function()?  galleryRequested,TResult Function( String id)?  receiptRemoved,TResult Function( String id)?  extractionRetried,TResult Function( String id)?  selectionToggled,TResult Function()?  pdfRequested,TResult Function( String id,  String? restaurantName,  double? amount,  String? date)?  receiptEdited,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DocScannerStarted() when started != null:
return started();case DocScannerCameraRequested() when cameraRequested != null:
return cameraRequested();case DocScannerGalleryRequested() when galleryRequested != null:
return galleryRequested();case DocScannerReceiptRemoved() when receiptRemoved != null:
return receiptRemoved(_that.id);case DocScannerExtractionRetried() when extractionRetried != null:
return extractionRetried(_that.id);case DocScannerSelectionToggled() when selectionToggled != null:
return selectionToggled(_that.id);case DocScannerPdfRequested() when pdfRequested != null:
return pdfRequested();case DocScannerReceiptEdited() when receiptEdited != null:
return receiptEdited(_that.id,_that.restaurantName,_that.amount,_that.date);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  cameraRequested,required TResult Function()  galleryRequested,required TResult Function( String id)  receiptRemoved,required TResult Function( String id)  extractionRetried,required TResult Function( String id)  selectionToggled,required TResult Function()  pdfRequested,required TResult Function( String id,  String? restaurantName,  double? amount,  String? date)  receiptEdited,}) {final _that = this;
switch (_that) {
case DocScannerStarted():
return started();case DocScannerCameraRequested():
return cameraRequested();case DocScannerGalleryRequested():
return galleryRequested();case DocScannerReceiptRemoved():
return receiptRemoved(_that.id);case DocScannerExtractionRetried():
return extractionRetried(_that.id);case DocScannerSelectionToggled():
return selectionToggled(_that.id);case DocScannerPdfRequested():
return pdfRequested();case DocScannerReceiptEdited():
return receiptEdited(_that.id,_that.restaurantName,_that.amount,_that.date);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  cameraRequested,TResult? Function()?  galleryRequested,TResult? Function( String id)?  receiptRemoved,TResult? Function( String id)?  extractionRetried,TResult? Function( String id)?  selectionToggled,TResult? Function()?  pdfRequested,TResult? Function( String id,  String? restaurantName,  double? amount,  String? date)?  receiptEdited,}) {final _that = this;
switch (_that) {
case DocScannerStarted() when started != null:
return started();case DocScannerCameraRequested() when cameraRequested != null:
return cameraRequested();case DocScannerGalleryRequested() when galleryRequested != null:
return galleryRequested();case DocScannerReceiptRemoved() when receiptRemoved != null:
return receiptRemoved(_that.id);case DocScannerExtractionRetried() when extractionRetried != null:
return extractionRetried(_that.id);case DocScannerSelectionToggled() when selectionToggled != null:
return selectionToggled(_that.id);case DocScannerPdfRequested() when pdfRequested != null:
return pdfRequested();case DocScannerReceiptEdited() when receiptEdited != null:
return receiptEdited(_that.id,_that.restaurantName,_that.amount,_that.date);case _:
  return null;

}
}

}

/// @nodoc


class DocScannerStarted implements DocScannerEvent {
  const DocScannerStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocScannerEvent.started()';
}


}




/// @nodoc


class DocScannerCameraRequested implements DocScannerEvent {
  const DocScannerCameraRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerCameraRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocScannerEvent.cameraRequested()';
}


}




/// @nodoc


class DocScannerGalleryRequested implements DocScannerEvent {
  const DocScannerGalleryRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerGalleryRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocScannerEvent.galleryRequested()';
}


}




/// @nodoc


class DocScannerReceiptRemoved implements DocScannerEvent {
  const DocScannerReceiptRemoved({required this.id});
  

 final  String id;

/// Create a copy of DocScannerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocScannerReceiptRemovedCopyWith<DocScannerReceiptRemoved> get copyWith => _$DocScannerReceiptRemovedCopyWithImpl<DocScannerReceiptRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerReceiptRemoved&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'DocScannerEvent.receiptRemoved(id: $id)';
}


}

/// @nodoc
abstract mixin class $DocScannerReceiptRemovedCopyWith<$Res> implements $DocScannerEventCopyWith<$Res> {
  factory $DocScannerReceiptRemovedCopyWith(DocScannerReceiptRemoved value, $Res Function(DocScannerReceiptRemoved) _then) = _$DocScannerReceiptRemovedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$DocScannerReceiptRemovedCopyWithImpl<$Res>
    implements $DocScannerReceiptRemovedCopyWith<$Res> {
  _$DocScannerReceiptRemovedCopyWithImpl(this._self, this._then);

  final DocScannerReceiptRemoved _self;
  final $Res Function(DocScannerReceiptRemoved) _then;

/// Create a copy of DocScannerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(DocScannerReceiptRemoved(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DocScannerExtractionRetried implements DocScannerEvent {
  const DocScannerExtractionRetried({required this.id});
  

 final  String id;

/// Create a copy of DocScannerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocScannerExtractionRetriedCopyWith<DocScannerExtractionRetried> get copyWith => _$DocScannerExtractionRetriedCopyWithImpl<DocScannerExtractionRetried>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerExtractionRetried&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'DocScannerEvent.extractionRetried(id: $id)';
}


}

/// @nodoc
abstract mixin class $DocScannerExtractionRetriedCopyWith<$Res> implements $DocScannerEventCopyWith<$Res> {
  factory $DocScannerExtractionRetriedCopyWith(DocScannerExtractionRetried value, $Res Function(DocScannerExtractionRetried) _then) = _$DocScannerExtractionRetriedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$DocScannerExtractionRetriedCopyWithImpl<$Res>
    implements $DocScannerExtractionRetriedCopyWith<$Res> {
  _$DocScannerExtractionRetriedCopyWithImpl(this._self, this._then);

  final DocScannerExtractionRetried _self;
  final $Res Function(DocScannerExtractionRetried) _then;

/// Create a copy of DocScannerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(DocScannerExtractionRetried(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DocScannerSelectionToggled implements DocScannerEvent {
  const DocScannerSelectionToggled({required this.id});
  

 final  String id;

/// Create a copy of DocScannerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocScannerSelectionToggledCopyWith<DocScannerSelectionToggled> get copyWith => _$DocScannerSelectionToggledCopyWithImpl<DocScannerSelectionToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerSelectionToggled&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'DocScannerEvent.selectionToggled(id: $id)';
}


}

/// @nodoc
abstract mixin class $DocScannerSelectionToggledCopyWith<$Res> implements $DocScannerEventCopyWith<$Res> {
  factory $DocScannerSelectionToggledCopyWith(DocScannerSelectionToggled value, $Res Function(DocScannerSelectionToggled) _then) = _$DocScannerSelectionToggledCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$DocScannerSelectionToggledCopyWithImpl<$Res>
    implements $DocScannerSelectionToggledCopyWith<$Res> {
  _$DocScannerSelectionToggledCopyWithImpl(this._self, this._then);

  final DocScannerSelectionToggled _self;
  final $Res Function(DocScannerSelectionToggled) _then;

/// Create a copy of DocScannerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(DocScannerSelectionToggled(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class DocScannerPdfRequested implements DocScannerEvent {
  const DocScannerPdfRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerPdfRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocScannerEvent.pdfRequested()';
}


}




/// @nodoc


class DocScannerReceiptEdited implements DocScannerEvent {
  const DocScannerReceiptEdited({required this.id, required this.restaurantName, required this.amount, required this.date});
  

 final  String id;
 final  String? restaurantName;
 final  double? amount;
 final  String? date;

/// Create a copy of DocScannerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocScannerReceiptEditedCopyWith<DocScannerReceiptEdited> get copyWith => _$DocScannerReceiptEditedCopyWithImpl<DocScannerReceiptEdited>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerReceiptEdited&&(identical(other.id, id) || other.id == id)&&(identical(other.restaurantName, restaurantName) || other.restaurantName == restaurantName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,id,restaurantName,amount,date);

@override
String toString() {
  return 'DocScannerEvent.receiptEdited(id: $id, restaurantName: $restaurantName, amount: $amount, date: $date)';
}


}

/// @nodoc
abstract mixin class $DocScannerReceiptEditedCopyWith<$Res> implements $DocScannerEventCopyWith<$Res> {
  factory $DocScannerReceiptEditedCopyWith(DocScannerReceiptEdited value, $Res Function(DocScannerReceiptEdited) _then) = _$DocScannerReceiptEditedCopyWithImpl;
@useResult
$Res call({
 String id, String? restaurantName, double? amount, String? date
});




}
/// @nodoc
class _$DocScannerReceiptEditedCopyWithImpl<$Res>
    implements $DocScannerReceiptEditedCopyWith<$Res> {
  _$DocScannerReceiptEditedCopyWithImpl(this._self, this._then);

  final DocScannerReceiptEdited _self;
  final $Res Function(DocScannerReceiptEdited) _then;

/// Create a copy of DocScannerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? restaurantName = freezed,Object? amount = freezed,Object? date = freezed,}) {
  return _then(DocScannerReceiptEdited(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,restaurantName: freezed == restaurantName ? _self.restaurantName : restaurantName // ignore: cast_nullable_to_non_nullable
as String?,amount: freezed == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$DocScannerState {

 List<ScannedReceiptEntity> get receipts; Set<String> get selectedIds;
/// Create a copy of DocScannerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocScannerStateCopyWith<DocScannerState> get copyWith => _$DocScannerStateCopyWithImpl<DocScannerState>(this as DocScannerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerState&&const DeepCollectionEquality().equals(other.receipts, receipts)&&const DeepCollectionEquality().equals(other.selectedIds, selectedIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(receipts),const DeepCollectionEquality().hash(selectedIds));

@override
String toString() {
  return 'DocScannerState(receipts: $receipts, selectedIds: $selectedIds)';
}


}

/// @nodoc
abstract mixin class $DocScannerStateCopyWith<$Res>  {
  factory $DocScannerStateCopyWith(DocScannerState value, $Res Function(DocScannerState) _then) = _$DocScannerStateCopyWithImpl;
@useResult
$Res call({
 List<ScannedReceiptEntity> receipts, Set<String> selectedIds
});




}
/// @nodoc
class _$DocScannerStateCopyWithImpl<$Res>
    implements $DocScannerStateCopyWith<$Res> {
  _$DocScannerStateCopyWithImpl(this._self, this._then);

  final DocScannerState _self;
  final $Res Function(DocScannerState) _then;

/// Create a copy of DocScannerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? receipts = null,Object? selectedIds = null,}) {
  return _then(_self.copyWith(
receipts: null == receipts ? _self.receipts : receipts // ignore: cast_nullable_to_non_nullable
as List<ScannedReceiptEntity>,selectedIds: null == selectedIds ? _self.selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DocScannerState].
extension DocScannerStatePatterns on DocScannerState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DocScannerIdle value)?  idle,TResult Function( DocScannerExtracting value)?  extracting,TResult Function( DocScannerGeneratingPdf value)?  generatingPdf,TResult Function( DocScannerPdfReady value)?  pdfReady,TResult Function( DocScannerPdfFailed value)?  pdfFailed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DocScannerIdle() when idle != null:
return idle(_that);case DocScannerExtracting() when extracting != null:
return extracting(_that);case DocScannerGeneratingPdf() when generatingPdf != null:
return generatingPdf(_that);case DocScannerPdfReady() when pdfReady != null:
return pdfReady(_that);case DocScannerPdfFailed() when pdfFailed != null:
return pdfFailed(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DocScannerIdle value)  idle,required TResult Function( DocScannerExtracting value)  extracting,required TResult Function( DocScannerGeneratingPdf value)  generatingPdf,required TResult Function( DocScannerPdfReady value)  pdfReady,required TResult Function( DocScannerPdfFailed value)  pdfFailed,}){
final _that = this;
switch (_that) {
case DocScannerIdle():
return idle(_that);case DocScannerExtracting():
return extracting(_that);case DocScannerGeneratingPdf():
return generatingPdf(_that);case DocScannerPdfReady():
return pdfReady(_that);case DocScannerPdfFailed():
return pdfFailed(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DocScannerIdle value)?  idle,TResult? Function( DocScannerExtracting value)?  extracting,TResult? Function( DocScannerGeneratingPdf value)?  generatingPdf,TResult? Function( DocScannerPdfReady value)?  pdfReady,TResult? Function( DocScannerPdfFailed value)?  pdfFailed,}){
final _that = this;
switch (_that) {
case DocScannerIdle() when idle != null:
return idle(_that);case DocScannerExtracting() when extracting != null:
return extracting(_that);case DocScannerGeneratingPdf() when generatingPdf != null:
return generatingPdf(_that);case DocScannerPdfReady() when pdfReady != null:
return pdfReady(_that);case DocScannerPdfFailed() when pdfFailed != null:
return pdfFailed(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<ScannedReceiptEntity> receipts,  Set<String> selectedIds,  int skippedDuplicates)?  idle,TResult Function( List<ScannedReceiptEntity> receipts,  Set<String> selectedIds,  int skippedDuplicates)?  extracting,TResult Function( List<ScannedReceiptEntity> receipts,  Set<String> selectedIds)?  generatingPdf,TResult Function( List<ScannedReceiptEntity> receipts,  String pdfPath,  Set<String> selectedIds)?  pdfReady,TResult Function( List<ScannedReceiptEntity> receipts,  String message,  Set<String> selectedIds)?  pdfFailed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DocScannerIdle() when idle != null:
return idle(_that.receipts,_that.selectedIds,_that.skippedDuplicates);case DocScannerExtracting() when extracting != null:
return extracting(_that.receipts,_that.selectedIds,_that.skippedDuplicates);case DocScannerGeneratingPdf() when generatingPdf != null:
return generatingPdf(_that.receipts,_that.selectedIds);case DocScannerPdfReady() when pdfReady != null:
return pdfReady(_that.receipts,_that.pdfPath,_that.selectedIds);case DocScannerPdfFailed() when pdfFailed != null:
return pdfFailed(_that.receipts,_that.message,_that.selectedIds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<ScannedReceiptEntity> receipts,  Set<String> selectedIds,  int skippedDuplicates)  idle,required TResult Function( List<ScannedReceiptEntity> receipts,  Set<String> selectedIds,  int skippedDuplicates)  extracting,required TResult Function( List<ScannedReceiptEntity> receipts,  Set<String> selectedIds)  generatingPdf,required TResult Function( List<ScannedReceiptEntity> receipts,  String pdfPath,  Set<String> selectedIds)  pdfReady,required TResult Function( List<ScannedReceiptEntity> receipts,  String message,  Set<String> selectedIds)  pdfFailed,}) {final _that = this;
switch (_that) {
case DocScannerIdle():
return idle(_that.receipts,_that.selectedIds,_that.skippedDuplicates);case DocScannerExtracting():
return extracting(_that.receipts,_that.selectedIds,_that.skippedDuplicates);case DocScannerGeneratingPdf():
return generatingPdf(_that.receipts,_that.selectedIds);case DocScannerPdfReady():
return pdfReady(_that.receipts,_that.pdfPath,_that.selectedIds);case DocScannerPdfFailed():
return pdfFailed(_that.receipts,_that.message,_that.selectedIds);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<ScannedReceiptEntity> receipts,  Set<String> selectedIds,  int skippedDuplicates)?  idle,TResult? Function( List<ScannedReceiptEntity> receipts,  Set<String> selectedIds,  int skippedDuplicates)?  extracting,TResult? Function( List<ScannedReceiptEntity> receipts,  Set<String> selectedIds)?  generatingPdf,TResult? Function( List<ScannedReceiptEntity> receipts,  String pdfPath,  Set<String> selectedIds)?  pdfReady,TResult? Function( List<ScannedReceiptEntity> receipts,  String message,  Set<String> selectedIds)?  pdfFailed,}) {final _that = this;
switch (_that) {
case DocScannerIdle() when idle != null:
return idle(_that.receipts,_that.selectedIds,_that.skippedDuplicates);case DocScannerExtracting() when extracting != null:
return extracting(_that.receipts,_that.selectedIds,_that.skippedDuplicates);case DocScannerGeneratingPdf() when generatingPdf != null:
return generatingPdf(_that.receipts,_that.selectedIds);case DocScannerPdfReady() when pdfReady != null:
return pdfReady(_that.receipts,_that.pdfPath,_that.selectedIds);case DocScannerPdfFailed() when pdfFailed != null:
return pdfFailed(_that.receipts,_that.message,_that.selectedIds);case _:
  return null;

}
}

}

/// @nodoc


class DocScannerIdle implements DocScannerState {
  const DocScannerIdle({final  List<ScannedReceiptEntity> receipts = const [], final  Set<String> selectedIds = const <String>{}, this.skippedDuplicates = 0}): _receipts = receipts,_selectedIds = selectedIds;
  

 final  List<ScannedReceiptEntity> _receipts;
@override@JsonKey() List<ScannedReceiptEntity> get receipts {
  if (_receipts is EqualUnmodifiableListView) return _receipts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_receipts);
}

 final  Set<String> _selectedIds;
@override@JsonKey() Set<String> get selectedIds {
  if (_selectedIds is EqualUnmodifiableSetView) return _selectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedIds);
}

@JsonKey() final  int skippedDuplicates;

/// Create a copy of DocScannerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocScannerIdleCopyWith<DocScannerIdle> get copyWith => _$DocScannerIdleCopyWithImpl<DocScannerIdle>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerIdle&&const DeepCollectionEquality().equals(other._receipts, _receipts)&&const DeepCollectionEquality().equals(other._selectedIds, _selectedIds)&&(identical(other.skippedDuplicates, skippedDuplicates) || other.skippedDuplicates == skippedDuplicates));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_receipts),const DeepCollectionEquality().hash(_selectedIds),skippedDuplicates);

@override
String toString() {
  return 'DocScannerState.idle(receipts: $receipts, selectedIds: $selectedIds, skippedDuplicates: $skippedDuplicates)';
}


}

/// @nodoc
abstract mixin class $DocScannerIdleCopyWith<$Res> implements $DocScannerStateCopyWith<$Res> {
  factory $DocScannerIdleCopyWith(DocScannerIdle value, $Res Function(DocScannerIdle) _then) = _$DocScannerIdleCopyWithImpl;
@override @useResult
$Res call({
 List<ScannedReceiptEntity> receipts, Set<String> selectedIds, int skippedDuplicates
});




}
/// @nodoc
class _$DocScannerIdleCopyWithImpl<$Res>
    implements $DocScannerIdleCopyWith<$Res> {
  _$DocScannerIdleCopyWithImpl(this._self, this._then);

  final DocScannerIdle _self;
  final $Res Function(DocScannerIdle) _then;

/// Create a copy of DocScannerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? receipts = null,Object? selectedIds = null,Object? skippedDuplicates = null,}) {
  return _then(DocScannerIdle(
receipts: null == receipts ? _self._receipts : receipts // ignore: cast_nullable_to_non_nullable
as List<ScannedReceiptEntity>,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<String>,skippedDuplicates: null == skippedDuplicates ? _self.skippedDuplicates : skippedDuplicates // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class DocScannerExtracting implements DocScannerState {
  const DocScannerExtracting({required final  List<ScannedReceiptEntity> receipts, final  Set<String> selectedIds = const <String>{}, this.skippedDuplicates = 0}): _receipts = receipts,_selectedIds = selectedIds;
  

 final  List<ScannedReceiptEntity> _receipts;
@override List<ScannedReceiptEntity> get receipts {
  if (_receipts is EqualUnmodifiableListView) return _receipts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_receipts);
}

 final  Set<String> _selectedIds;
@override@JsonKey() Set<String> get selectedIds {
  if (_selectedIds is EqualUnmodifiableSetView) return _selectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedIds);
}

@JsonKey() final  int skippedDuplicates;

/// Create a copy of DocScannerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocScannerExtractingCopyWith<DocScannerExtracting> get copyWith => _$DocScannerExtractingCopyWithImpl<DocScannerExtracting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerExtracting&&const DeepCollectionEquality().equals(other._receipts, _receipts)&&const DeepCollectionEquality().equals(other._selectedIds, _selectedIds)&&(identical(other.skippedDuplicates, skippedDuplicates) || other.skippedDuplicates == skippedDuplicates));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_receipts),const DeepCollectionEquality().hash(_selectedIds),skippedDuplicates);

@override
String toString() {
  return 'DocScannerState.extracting(receipts: $receipts, selectedIds: $selectedIds, skippedDuplicates: $skippedDuplicates)';
}


}

/// @nodoc
abstract mixin class $DocScannerExtractingCopyWith<$Res> implements $DocScannerStateCopyWith<$Res> {
  factory $DocScannerExtractingCopyWith(DocScannerExtracting value, $Res Function(DocScannerExtracting) _then) = _$DocScannerExtractingCopyWithImpl;
@override @useResult
$Res call({
 List<ScannedReceiptEntity> receipts, Set<String> selectedIds, int skippedDuplicates
});




}
/// @nodoc
class _$DocScannerExtractingCopyWithImpl<$Res>
    implements $DocScannerExtractingCopyWith<$Res> {
  _$DocScannerExtractingCopyWithImpl(this._self, this._then);

  final DocScannerExtracting _self;
  final $Res Function(DocScannerExtracting) _then;

/// Create a copy of DocScannerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? receipts = null,Object? selectedIds = null,Object? skippedDuplicates = null,}) {
  return _then(DocScannerExtracting(
receipts: null == receipts ? _self._receipts : receipts // ignore: cast_nullable_to_non_nullable
as List<ScannedReceiptEntity>,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<String>,skippedDuplicates: null == skippedDuplicates ? _self.skippedDuplicates : skippedDuplicates // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class DocScannerGeneratingPdf implements DocScannerState {
  const DocScannerGeneratingPdf({required final  List<ScannedReceiptEntity> receipts, final  Set<String> selectedIds = const <String>{}}): _receipts = receipts,_selectedIds = selectedIds;
  

 final  List<ScannedReceiptEntity> _receipts;
@override List<ScannedReceiptEntity> get receipts {
  if (_receipts is EqualUnmodifiableListView) return _receipts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_receipts);
}

 final  Set<String> _selectedIds;
@override@JsonKey() Set<String> get selectedIds {
  if (_selectedIds is EqualUnmodifiableSetView) return _selectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedIds);
}


/// Create a copy of DocScannerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocScannerGeneratingPdfCopyWith<DocScannerGeneratingPdf> get copyWith => _$DocScannerGeneratingPdfCopyWithImpl<DocScannerGeneratingPdf>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerGeneratingPdf&&const DeepCollectionEquality().equals(other._receipts, _receipts)&&const DeepCollectionEquality().equals(other._selectedIds, _selectedIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_receipts),const DeepCollectionEquality().hash(_selectedIds));

@override
String toString() {
  return 'DocScannerState.generatingPdf(receipts: $receipts, selectedIds: $selectedIds)';
}


}

/// @nodoc
abstract mixin class $DocScannerGeneratingPdfCopyWith<$Res> implements $DocScannerStateCopyWith<$Res> {
  factory $DocScannerGeneratingPdfCopyWith(DocScannerGeneratingPdf value, $Res Function(DocScannerGeneratingPdf) _then) = _$DocScannerGeneratingPdfCopyWithImpl;
@override @useResult
$Res call({
 List<ScannedReceiptEntity> receipts, Set<String> selectedIds
});




}
/// @nodoc
class _$DocScannerGeneratingPdfCopyWithImpl<$Res>
    implements $DocScannerGeneratingPdfCopyWith<$Res> {
  _$DocScannerGeneratingPdfCopyWithImpl(this._self, this._then);

  final DocScannerGeneratingPdf _self;
  final $Res Function(DocScannerGeneratingPdf) _then;

/// Create a copy of DocScannerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? receipts = null,Object? selectedIds = null,}) {
  return _then(DocScannerGeneratingPdf(
receipts: null == receipts ? _self._receipts : receipts // ignore: cast_nullable_to_non_nullable
as List<ScannedReceiptEntity>,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

/// @nodoc


class DocScannerPdfReady implements DocScannerState {
  const DocScannerPdfReady({required final  List<ScannedReceiptEntity> receipts, required this.pdfPath, final  Set<String> selectedIds = const <String>{}}): _receipts = receipts,_selectedIds = selectedIds;
  

 final  List<ScannedReceiptEntity> _receipts;
@override List<ScannedReceiptEntity> get receipts {
  if (_receipts is EqualUnmodifiableListView) return _receipts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_receipts);
}

 final  String pdfPath;
 final  Set<String> _selectedIds;
@override@JsonKey() Set<String> get selectedIds {
  if (_selectedIds is EqualUnmodifiableSetView) return _selectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedIds);
}


/// Create a copy of DocScannerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocScannerPdfReadyCopyWith<DocScannerPdfReady> get copyWith => _$DocScannerPdfReadyCopyWithImpl<DocScannerPdfReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerPdfReady&&const DeepCollectionEquality().equals(other._receipts, _receipts)&&(identical(other.pdfPath, pdfPath) || other.pdfPath == pdfPath)&&const DeepCollectionEquality().equals(other._selectedIds, _selectedIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_receipts),pdfPath,const DeepCollectionEquality().hash(_selectedIds));

@override
String toString() {
  return 'DocScannerState.pdfReady(receipts: $receipts, pdfPath: $pdfPath, selectedIds: $selectedIds)';
}


}

/// @nodoc
abstract mixin class $DocScannerPdfReadyCopyWith<$Res> implements $DocScannerStateCopyWith<$Res> {
  factory $DocScannerPdfReadyCopyWith(DocScannerPdfReady value, $Res Function(DocScannerPdfReady) _then) = _$DocScannerPdfReadyCopyWithImpl;
@override @useResult
$Res call({
 List<ScannedReceiptEntity> receipts, String pdfPath, Set<String> selectedIds
});




}
/// @nodoc
class _$DocScannerPdfReadyCopyWithImpl<$Res>
    implements $DocScannerPdfReadyCopyWith<$Res> {
  _$DocScannerPdfReadyCopyWithImpl(this._self, this._then);

  final DocScannerPdfReady _self;
  final $Res Function(DocScannerPdfReady) _then;

/// Create a copy of DocScannerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? receipts = null,Object? pdfPath = null,Object? selectedIds = null,}) {
  return _then(DocScannerPdfReady(
receipts: null == receipts ? _self._receipts : receipts // ignore: cast_nullable_to_non_nullable
as List<ScannedReceiptEntity>,pdfPath: null == pdfPath ? _self.pdfPath : pdfPath // ignore: cast_nullable_to_non_nullable
as String,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

/// @nodoc


class DocScannerPdfFailed implements DocScannerState {
  const DocScannerPdfFailed({required final  List<ScannedReceiptEntity> receipts, required this.message, final  Set<String> selectedIds = const <String>{}}): _receipts = receipts,_selectedIds = selectedIds;
  

 final  List<ScannedReceiptEntity> _receipts;
@override List<ScannedReceiptEntity> get receipts {
  if (_receipts is EqualUnmodifiableListView) return _receipts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_receipts);
}

 final  String message;
 final  Set<String> _selectedIds;
@override@JsonKey() Set<String> get selectedIds {
  if (_selectedIds is EqualUnmodifiableSetView) return _selectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selectedIds);
}


/// Create a copy of DocScannerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocScannerPdfFailedCopyWith<DocScannerPdfFailed> get copyWith => _$DocScannerPdfFailedCopyWithImpl<DocScannerPdfFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocScannerPdfFailed&&const DeepCollectionEquality().equals(other._receipts, _receipts)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._selectedIds, _selectedIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_receipts),message,const DeepCollectionEquality().hash(_selectedIds));

@override
String toString() {
  return 'DocScannerState.pdfFailed(receipts: $receipts, message: $message, selectedIds: $selectedIds)';
}


}

/// @nodoc
abstract mixin class $DocScannerPdfFailedCopyWith<$Res> implements $DocScannerStateCopyWith<$Res> {
  factory $DocScannerPdfFailedCopyWith(DocScannerPdfFailed value, $Res Function(DocScannerPdfFailed) _then) = _$DocScannerPdfFailedCopyWithImpl;
@override @useResult
$Res call({
 List<ScannedReceiptEntity> receipts, String message, Set<String> selectedIds
});




}
/// @nodoc
class _$DocScannerPdfFailedCopyWithImpl<$Res>
    implements $DocScannerPdfFailedCopyWith<$Res> {
  _$DocScannerPdfFailedCopyWithImpl(this._self, this._then);

  final DocScannerPdfFailed _self;
  final $Res Function(DocScannerPdfFailed) _then;

/// Create a copy of DocScannerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? receipts = null,Object? message = null,Object? selectedIds = null,}) {
  return _then(DocScannerPdfFailed(
receipts: null == receipts ? _self._receipts : receipts // ignore: cast_nullable_to_non_nullable
as List<ScannedReceiptEntity>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,selectedIds: null == selectedIds ? _self._selectedIds : selectedIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
