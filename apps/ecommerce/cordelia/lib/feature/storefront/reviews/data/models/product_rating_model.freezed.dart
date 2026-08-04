// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_rating_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductRatingModel {

 double get average; int get count;// Fixed 1★→5★ order, as sent. Defaulted because a store whose products
// predate reviews answers without the key.
 List<int> get buckets;
/// Create a copy of ProductRatingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductRatingModelCopyWith<ProductRatingModel> get copyWith => _$ProductRatingModelCopyWithImpl<ProductRatingModel>(this as ProductRatingModel, _$identity);

  /// Serializes this ProductRatingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductRatingModel&&(identical(other.average, average) || other.average == average)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.buckets, buckets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,average,count,const DeepCollectionEquality().hash(buckets));

@override
String toString() {
  return 'ProductRatingModel(average: $average, count: $count, buckets: $buckets)';
}


}

/// @nodoc
abstract mixin class $ProductRatingModelCopyWith<$Res>  {
  factory $ProductRatingModelCopyWith(ProductRatingModel value, $Res Function(ProductRatingModel) _then) = _$ProductRatingModelCopyWithImpl;
@useResult
$Res call({
 double average, int count, List<int> buckets
});




}
/// @nodoc
class _$ProductRatingModelCopyWithImpl<$Res>
    implements $ProductRatingModelCopyWith<$Res> {
  _$ProductRatingModelCopyWithImpl(this._self, this._then);

  final ProductRatingModel _self;
  final $Res Function(ProductRatingModel) _then;

/// Create a copy of ProductRatingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? average = null,Object? count = null,Object? buckets = null,}) {
  return _then(_self.copyWith(
average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,buckets: null == buckets ? _self.buckets : buckets // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductRatingModel].
extension ProductRatingModelPatterns on ProductRatingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductRatingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductRatingModel() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductRatingModel value)  $default,){
final _that = this;
switch (_that) {
case _ProductRatingModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductRatingModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProductRatingModel() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double average,  int count,  List<int> buckets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductRatingModel() when $default != null:
return $default(_that.average,_that.count,_that.buckets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double average,  int count,  List<int> buckets)  $default,) {final _that = this;
switch (_that) {
case _ProductRatingModel():
return $default(_that.average,_that.count,_that.buckets);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double average,  int count,  List<int> buckets)?  $default,) {final _that = this;
switch (_that) {
case _ProductRatingModel() when $default != null:
return $default(_that.average,_that.count,_that.buckets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductRatingModel extends ProductRatingModel {
  const _ProductRatingModel({this.average = 0.0, this.count = 0, final  List<int> buckets = const <int>[0, 0, 0, 0, 0]}): _buckets = buckets,super._();
  factory _ProductRatingModel.fromJson(Map<String, dynamic> json) => _$ProductRatingModelFromJson(json);

@override@JsonKey() final  double average;
@override@JsonKey() final  int count;
// Fixed 1★→5★ order, as sent. Defaulted because a store whose products
// predate reviews answers without the key.
 final  List<int> _buckets;
// Fixed 1★→5★ order, as sent. Defaulted because a store whose products
// predate reviews answers without the key.
@override@JsonKey() List<int> get buckets {
  if (_buckets is EqualUnmodifiableListView) return _buckets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_buckets);
}


/// Create a copy of ProductRatingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductRatingModelCopyWith<_ProductRatingModel> get copyWith => __$ProductRatingModelCopyWithImpl<_ProductRatingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductRatingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductRatingModel&&(identical(other.average, average) || other.average == average)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other._buckets, _buckets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,average,count,const DeepCollectionEquality().hash(_buckets));

@override
String toString() {
  return 'ProductRatingModel(average: $average, count: $count, buckets: $buckets)';
}


}

/// @nodoc
abstract mixin class _$ProductRatingModelCopyWith<$Res> implements $ProductRatingModelCopyWith<$Res> {
  factory _$ProductRatingModelCopyWith(_ProductRatingModel value, $Res Function(_ProductRatingModel) _then) = __$ProductRatingModelCopyWithImpl;
@override @useResult
$Res call({
 double average, int count, List<int> buckets
});




}
/// @nodoc
class __$ProductRatingModelCopyWithImpl<$Res>
    implements _$ProductRatingModelCopyWith<$Res> {
  __$ProductRatingModelCopyWithImpl(this._self, this._then);

  final _ProductRatingModel _self;
  final $Res Function(_ProductRatingModel) _then;

/// Create a copy of ProductRatingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? average = null,Object? count = null,Object? buckets = null,}) {
  return _then(_ProductRatingModel(
average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,buckets: null == buckets ? _self._buckets : buckets // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on
