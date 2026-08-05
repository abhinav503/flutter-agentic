// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreModel {

 String get id; String get name;// Matches admin's serializeStore() — `image` not `logoUrl`, same
// snake_case-avoidant convention as gravia's CategoryModel/ProductModel
// (these particular keys have no snake_case form to begin with).
 String get image; String get description;// Defaulted, not required — the admin backend sends template_id now,
// but the still-deployed older API build may not, so this must parse
// cleanly either way. Empty, not 'gravia': the wire→enum fallback lives
// in one place (`StorefrontTemplateParse.toStorefrontTemplate`, which
// maps ''/unknown → gravia), so this DTO doesn't hold a second copy of
// that policy.
@JsonKey(name: 'template_id') String get templateId;// Same defaulted-not-required reasoning as template_id: the wire→enum
// fallback (''/unknown → en) lives in StoreLanguageParse alone.
 String get language;// Ditto — ''/unknown → INR, resolved by StoreCurrencyParse. Stores
// created before the field existed read back as rupees, which is what
// they were already charging.
 String get currency;
/// Create a copy of StoreModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreModelCopyWith<StoreModel> get copyWith => _$StoreModelCopyWithImpl<StoreModel>(this as StoreModel, _$identity);

  /// Serializes this StoreModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.description, description) || other.description == description)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.language, language) || other.language == language)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image,description,templateId,language,currency);

@override
String toString() {
  return 'StoreModel(id: $id, name: $name, image: $image, description: $description, templateId: $templateId, language: $language, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $StoreModelCopyWith<$Res>  {
  factory $StoreModelCopyWith(StoreModel value, $Res Function(StoreModel) _then) = _$StoreModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String image, String description,@JsonKey(name: 'template_id') String templateId, String language, String currency
});




}
/// @nodoc
class _$StoreModelCopyWithImpl<$Res>
    implements $StoreModelCopyWith<$Res> {
  _$StoreModelCopyWithImpl(this._self, this._then);

  final StoreModel _self;
  final $Res Function(StoreModel) _then;

/// Create a copy of StoreModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? image = null,Object? description = null,Object? templateId = null,Object? language = null,Object? currency = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreModel].
extension StoreModelPatterns on StoreModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreModel value)  $default,){
final _that = this;
switch (_that) {
case _StoreModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreModel value)?  $default,){
final _that = this;
switch (_that) {
case _StoreModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String image,  String description, @JsonKey(name: 'template_id')  String templateId,  String language,  String currency)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreModel() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.description,_that.templateId,_that.language,_that.currency);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String image,  String description, @JsonKey(name: 'template_id')  String templateId,  String language,  String currency)  $default,) {final _that = this;
switch (_that) {
case _StoreModel():
return $default(_that.id,_that.name,_that.image,_that.description,_that.templateId,_that.language,_that.currency);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String image,  String description, @JsonKey(name: 'template_id')  String templateId,  String language,  String currency)?  $default,) {final _that = this;
switch (_that) {
case _StoreModel() when $default != null:
return $default(_that.id,_that.name,_that.image,_that.description,_that.templateId,_that.language,_that.currency);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreModel extends StoreModel {
  const _StoreModel({required this.id, required this.name, required this.image, required this.description, @JsonKey(name: 'template_id') this.templateId = '', this.language = '', this.currency = ''}): super._();
  factory _StoreModel.fromJson(Map<String, dynamic> json) => _$StoreModelFromJson(json);

@override final  String id;
@override final  String name;
// Matches admin's serializeStore() — `image` not `logoUrl`, same
// snake_case-avoidant convention as gravia's CategoryModel/ProductModel
// (these particular keys have no snake_case form to begin with).
@override final  String image;
@override final  String description;
// Defaulted, not required — the admin backend sends template_id now,
// but the still-deployed older API build may not, so this must parse
// cleanly either way. Empty, not 'gravia': the wire→enum fallback lives
// in one place (`StorefrontTemplateParse.toStorefrontTemplate`, which
// maps ''/unknown → gravia), so this DTO doesn't hold a second copy of
// that policy.
@override@JsonKey(name: 'template_id') final  String templateId;
// Same defaulted-not-required reasoning as template_id: the wire→enum
// fallback (''/unknown → en) lives in StoreLanguageParse alone.
@override@JsonKey() final  String language;
// Ditto — ''/unknown → INR, resolved by StoreCurrencyParse. Stores
// created before the field existed read back as rupees, which is what
// they were already charging.
@override@JsonKey() final  String currency;

/// Create a copy of StoreModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreModelCopyWith<_StoreModel> get copyWith => __$StoreModelCopyWithImpl<_StoreModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.description, description) || other.description == description)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.language, language) || other.language == language)&&(identical(other.currency, currency) || other.currency == currency));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,image,description,templateId,language,currency);

@override
String toString() {
  return 'StoreModel(id: $id, name: $name, image: $image, description: $description, templateId: $templateId, language: $language, currency: $currency)';
}


}

/// @nodoc
abstract mixin class _$StoreModelCopyWith<$Res> implements $StoreModelCopyWith<$Res> {
  factory _$StoreModelCopyWith(_StoreModel value, $Res Function(_StoreModel) _then) = __$StoreModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String image, String description,@JsonKey(name: 'template_id') String templateId, String language, String currency
});




}
/// @nodoc
class __$StoreModelCopyWithImpl<$Res>
    implements _$StoreModelCopyWith<$Res> {
  __$StoreModelCopyWithImpl(this._self, this._then);

  final _StoreModel _self;
  final $Res Function(_StoreModel) _then;

/// Create a copy of StoreModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? image = null,Object? description = null,Object? templateId = null,Object? language = null,Object? currency = null,}) {
  return _then(_StoreModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
