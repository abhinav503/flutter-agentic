// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joke_search_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JokeSearchResultModel {

 String get id; String get joke;
/// Create a copy of JokeSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokeSearchResultModelCopyWith<JokeSearchResultModel> get copyWith => _$JokeSearchResultModelCopyWithImpl<JokeSearchResultModel>(this as JokeSearchResultModel, _$identity);

  /// Serializes this JokeSearchResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeSearchResultModel&&(identical(other.id, id) || other.id == id)&&(identical(other.joke, joke) || other.joke == joke));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,joke);

@override
String toString() {
  return 'JokeSearchResultModel(id: $id, joke: $joke)';
}


}

/// @nodoc
abstract mixin class $JokeSearchResultModelCopyWith<$Res>  {
  factory $JokeSearchResultModelCopyWith(JokeSearchResultModel value, $Res Function(JokeSearchResultModel) _then) = _$JokeSearchResultModelCopyWithImpl;
@useResult
$Res call({
 String id, String joke
});




}
/// @nodoc
class _$JokeSearchResultModelCopyWithImpl<$Res>
    implements $JokeSearchResultModelCopyWith<$Res> {
  _$JokeSearchResultModelCopyWithImpl(this._self, this._then);

  final JokeSearchResultModel _self;
  final $Res Function(JokeSearchResultModel) _then;

/// Create a copy of JokeSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? joke = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,joke: null == joke ? _self.joke : joke // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [JokeSearchResultModel].
extension JokeSearchResultModelPatterns on JokeSearchResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JokeSearchResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JokeSearchResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JokeSearchResultModel value)  $default,){
final _that = this;
switch (_that) {
case _JokeSearchResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JokeSearchResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _JokeSearchResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String joke)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JokeSearchResultModel() when $default != null:
return $default(_that.id,_that.joke);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String joke)  $default,) {final _that = this;
switch (_that) {
case _JokeSearchResultModel():
return $default(_that.id,_that.joke);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String joke)?  $default,) {final _that = this;
switch (_that) {
case _JokeSearchResultModel() when $default != null:
return $default(_that.id,_that.joke);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JokeSearchResultModel extends JokeSearchResultModel {
  const _JokeSearchResultModel({required this.id, required this.joke}): super._();
  factory _JokeSearchResultModel.fromJson(Map<String, dynamic> json) => _$JokeSearchResultModelFromJson(json);

@override final  String id;
@override final  String joke;

/// Create a copy of JokeSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JokeSearchResultModelCopyWith<_JokeSearchResultModel> get copyWith => __$JokeSearchResultModelCopyWithImpl<_JokeSearchResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JokeSearchResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JokeSearchResultModel&&(identical(other.id, id) || other.id == id)&&(identical(other.joke, joke) || other.joke == joke));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,joke);

@override
String toString() {
  return 'JokeSearchResultModel(id: $id, joke: $joke)';
}


}

/// @nodoc
abstract mixin class _$JokeSearchResultModelCopyWith<$Res> implements $JokeSearchResultModelCopyWith<$Res> {
  factory _$JokeSearchResultModelCopyWith(_JokeSearchResultModel value, $Res Function(_JokeSearchResultModel) _then) = __$JokeSearchResultModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String joke
});




}
/// @nodoc
class __$JokeSearchResultModelCopyWithImpl<$Res>
    implements _$JokeSearchResultModelCopyWith<$Res> {
  __$JokeSearchResultModelCopyWithImpl(this._self, this._then);

  final _JokeSearchResultModel _self;
  final $Res Function(_JokeSearchResultModel) _then;

/// Create a copy of JokeSearchResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? joke = null,}) {
  return _then(_JokeSearchResultModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,joke: null == joke ? _self.joke : joke // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$JokeSearchResponseModel {

@JsonKey(name: 'current_page') int get currentPage; int get limit;@JsonKey(name: 'next_page') int get nextPage;@JsonKey(name: 'previous_page') int get previousPage; List<JokeSearchResultModel> get results;@JsonKey(name: 'search_term') String get searchTerm; int get status;@JsonKey(name: 'total_jokes') int get totalJokes;@JsonKey(name: 'total_pages') int get totalPages;
/// Create a copy of JokeSearchResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokeSearchResponseModelCopyWith<JokeSearchResponseModel> get copyWith => _$JokeSearchResponseModelCopyWithImpl<JokeSearchResponseModel>(this as JokeSearchResponseModel, _$identity);

  /// Serializes this JokeSearchResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeSearchResponseModel&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage)&&(identical(other.previousPage, previousPage) || other.previousPage == previousPage)&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.searchTerm, searchTerm) || other.searchTerm == searchTerm)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalJokes, totalJokes) || other.totalJokes == totalJokes)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,limit,nextPage,previousPage,const DeepCollectionEquality().hash(results),searchTerm,status,totalJokes,totalPages);

@override
String toString() {
  return 'JokeSearchResponseModel(currentPage: $currentPage, limit: $limit, nextPage: $nextPage, previousPage: $previousPage, results: $results, searchTerm: $searchTerm, status: $status, totalJokes: $totalJokes, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $JokeSearchResponseModelCopyWith<$Res>  {
  factory $JokeSearchResponseModelCopyWith(JokeSearchResponseModel value, $Res Function(JokeSearchResponseModel) _then) = _$JokeSearchResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage, int limit,@JsonKey(name: 'next_page') int nextPage,@JsonKey(name: 'previous_page') int previousPage, List<JokeSearchResultModel> results,@JsonKey(name: 'search_term') String searchTerm, int status,@JsonKey(name: 'total_jokes') int totalJokes,@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class _$JokeSearchResponseModelCopyWithImpl<$Res>
    implements $JokeSearchResponseModelCopyWith<$Res> {
  _$JokeSearchResponseModelCopyWithImpl(this._self, this._then);

  final JokeSearchResponseModel _self;
  final $Res Function(JokeSearchResponseModel) _then;

/// Create a copy of JokeSearchResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentPage = null,Object? limit = null,Object? nextPage = null,Object? previousPage = null,Object? results = null,Object? searchTerm = null,Object? status = null,Object? totalJokes = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,nextPage: null == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int,previousPage: null == previousPage ? _self.previousPage : previousPage // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<JokeSearchResultModel>,searchTerm: null == searchTerm ? _self.searchTerm : searchTerm // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,totalJokes: null == totalJokes ? _self.totalJokes : totalJokes // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JokeSearchResponseModel].
extension JokeSearchResponseModelPatterns on JokeSearchResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JokeSearchResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JokeSearchResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JokeSearchResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _JokeSearchResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JokeSearchResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _JokeSearchResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page')  int currentPage,  int limit, @JsonKey(name: 'next_page')  int nextPage, @JsonKey(name: 'previous_page')  int previousPage,  List<JokeSearchResultModel> results, @JsonKey(name: 'search_term')  String searchTerm,  int status, @JsonKey(name: 'total_jokes')  int totalJokes, @JsonKey(name: 'total_pages')  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JokeSearchResponseModel() when $default != null:
return $default(_that.currentPage,_that.limit,_that.nextPage,_that.previousPage,_that.results,_that.searchTerm,_that.status,_that.totalJokes,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'current_page')  int currentPage,  int limit, @JsonKey(name: 'next_page')  int nextPage, @JsonKey(name: 'previous_page')  int previousPage,  List<JokeSearchResultModel> results, @JsonKey(name: 'search_term')  String searchTerm,  int status, @JsonKey(name: 'total_jokes')  int totalJokes, @JsonKey(name: 'total_pages')  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _JokeSearchResponseModel():
return $default(_that.currentPage,_that.limit,_that.nextPage,_that.previousPage,_that.results,_that.searchTerm,_that.status,_that.totalJokes,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'current_page')  int currentPage,  int limit, @JsonKey(name: 'next_page')  int nextPage, @JsonKey(name: 'previous_page')  int previousPage,  List<JokeSearchResultModel> results, @JsonKey(name: 'search_term')  String searchTerm,  int status, @JsonKey(name: 'total_jokes')  int totalJokes, @JsonKey(name: 'total_pages')  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _JokeSearchResponseModel() when $default != null:
return $default(_that.currentPage,_that.limit,_that.nextPage,_that.previousPage,_that.results,_that.searchTerm,_that.status,_that.totalJokes,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JokeSearchResponseModel extends JokeSearchResponseModel {
  const _JokeSearchResponseModel({@JsonKey(name: 'current_page') required this.currentPage, required this.limit, @JsonKey(name: 'next_page') required this.nextPage, @JsonKey(name: 'previous_page') required this.previousPage, required final  List<JokeSearchResultModel> results, @JsonKey(name: 'search_term') required this.searchTerm, required this.status, @JsonKey(name: 'total_jokes') required this.totalJokes, @JsonKey(name: 'total_pages') required this.totalPages}): _results = results,super._();
  factory _JokeSearchResponseModel.fromJson(Map<String, dynamic> json) => _$JokeSearchResponseModelFromJson(json);

@override@JsonKey(name: 'current_page') final  int currentPage;
@override final  int limit;
@override@JsonKey(name: 'next_page') final  int nextPage;
@override@JsonKey(name: 'previous_page') final  int previousPage;
 final  List<JokeSearchResultModel> _results;
@override List<JokeSearchResultModel> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey(name: 'search_term') final  String searchTerm;
@override final  int status;
@override@JsonKey(name: 'total_jokes') final  int totalJokes;
@override@JsonKey(name: 'total_pages') final  int totalPages;

/// Create a copy of JokeSearchResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JokeSearchResponseModelCopyWith<_JokeSearchResponseModel> get copyWith => __$JokeSearchResponseModelCopyWithImpl<_JokeSearchResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JokeSearchResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JokeSearchResponseModel&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage)&&(identical(other.previousPage, previousPage) || other.previousPage == previousPage)&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.searchTerm, searchTerm) || other.searchTerm == searchTerm)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalJokes, totalJokes) || other.totalJokes == totalJokes)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentPage,limit,nextPage,previousPage,const DeepCollectionEquality().hash(_results),searchTerm,status,totalJokes,totalPages);

@override
String toString() {
  return 'JokeSearchResponseModel(currentPage: $currentPage, limit: $limit, nextPage: $nextPage, previousPage: $previousPage, results: $results, searchTerm: $searchTerm, status: $status, totalJokes: $totalJokes, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$JokeSearchResponseModelCopyWith<$Res> implements $JokeSearchResponseModelCopyWith<$Res> {
  factory _$JokeSearchResponseModelCopyWith(_JokeSearchResponseModel value, $Res Function(_JokeSearchResponseModel) _then) = __$JokeSearchResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'current_page') int currentPage, int limit,@JsonKey(name: 'next_page') int nextPage,@JsonKey(name: 'previous_page') int previousPage, List<JokeSearchResultModel> results,@JsonKey(name: 'search_term') String searchTerm, int status,@JsonKey(name: 'total_jokes') int totalJokes,@JsonKey(name: 'total_pages') int totalPages
});




}
/// @nodoc
class __$JokeSearchResponseModelCopyWithImpl<$Res>
    implements _$JokeSearchResponseModelCopyWith<$Res> {
  __$JokeSearchResponseModelCopyWithImpl(this._self, this._then);

  final _JokeSearchResponseModel _self;
  final $Res Function(_JokeSearchResponseModel) _then;

/// Create a copy of JokeSearchResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentPage = null,Object? limit = null,Object? nextPage = null,Object? previousPage = null,Object? results = null,Object? searchTerm = null,Object? status = null,Object? totalJokes = null,Object? totalPages = null,}) {
  return _then(_JokeSearchResponseModel(
currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,nextPage: null == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int,previousPage: null == previousPage ? _self.previousPage : previousPage // ignore: cast_nullable_to_non_nullable
as int,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<JokeSearchResultModel>,searchTerm: null == searchTerm ? _self.searchTerm : searchTerm // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int,totalJokes: null == totalJokes ? _self.totalJokes : totalJokes // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
