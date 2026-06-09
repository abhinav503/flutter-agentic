// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'joke_search_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JokeSearchEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeSearchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokeSearchEvent()';
}


}

/// @nodoc
class $JokeSearchEventCopyWith<$Res>  {
$JokeSearchEventCopyWith(JokeSearchEvent _, $Res Function(JokeSearchEvent) __);
}


/// Adds pattern-matching-related methods to [JokeSearchEvent].
extension JokeSearchEventPatterns on JokeSearchEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( JokeSearchSubmitted value)?  submitted,TResult Function( JokeSearchChipSelected value)?  chipSelected,TResult Function( JokeSearchLoadMore value)?  loadMore,required TResult orElse(),}){
final _that = this;
switch (_that) {
case JokeSearchSubmitted() when submitted != null:
return submitted(_that);case JokeSearchChipSelected() when chipSelected != null:
return chipSelected(_that);case JokeSearchLoadMore() when loadMore != null:
return loadMore(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( JokeSearchSubmitted value)  submitted,required TResult Function( JokeSearchChipSelected value)  chipSelected,required TResult Function( JokeSearchLoadMore value)  loadMore,}){
final _that = this;
switch (_that) {
case JokeSearchSubmitted():
return submitted(_that);case JokeSearchChipSelected():
return chipSelected(_that);case JokeSearchLoadMore():
return loadMore(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( JokeSearchSubmitted value)?  submitted,TResult? Function( JokeSearchChipSelected value)?  chipSelected,TResult? Function( JokeSearchLoadMore value)?  loadMore,}){
final _that = this;
switch (_that) {
case JokeSearchSubmitted() when submitted != null:
return submitted(_that);case JokeSearchChipSelected() when chipSelected != null:
return chipSelected(_that);case JokeSearchLoadMore() when loadMore != null:
return loadMore(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String term)?  submitted,TResult Function( String term)?  chipSelected,TResult Function()?  loadMore,required TResult orElse(),}) {final _that = this;
switch (_that) {
case JokeSearchSubmitted() when submitted != null:
return submitted(_that.term);case JokeSearchChipSelected() when chipSelected != null:
return chipSelected(_that.term);case JokeSearchLoadMore() when loadMore != null:
return loadMore();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String term)  submitted,required TResult Function( String term)  chipSelected,required TResult Function()  loadMore,}) {final _that = this;
switch (_that) {
case JokeSearchSubmitted():
return submitted(_that.term);case JokeSearchChipSelected():
return chipSelected(_that.term);case JokeSearchLoadMore():
return loadMore();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String term)?  submitted,TResult? Function( String term)?  chipSelected,TResult? Function()?  loadMore,}) {final _that = this;
switch (_that) {
case JokeSearchSubmitted() when submitted != null:
return submitted(_that.term);case JokeSearchChipSelected() when chipSelected != null:
return chipSelected(_that.term);case JokeSearchLoadMore() when loadMore != null:
return loadMore();case _:
  return null;

}
}

}

/// @nodoc


class JokeSearchSubmitted implements JokeSearchEvent {
  const JokeSearchSubmitted({required this.term});
  

 final  String term;

/// Create a copy of JokeSearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokeSearchSubmittedCopyWith<JokeSearchSubmitted> get copyWith => _$JokeSearchSubmittedCopyWithImpl<JokeSearchSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeSearchSubmitted&&(identical(other.term, term) || other.term == term));
}


@override
int get hashCode => Object.hash(runtimeType,term);

@override
String toString() {
  return 'JokeSearchEvent.submitted(term: $term)';
}


}

/// @nodoc
abstract mixin class $JokeSearchSubmittedCopyWith<$Res> implements $JokeSearchEventCopyWith<$Res> {
  factory $JokeSearchSubmittedCopyWith(JokeSearchSubmitted value, $Res Function(JokeSearchSubmitted) _then) = _$JokeSearchSubmittedCopyWithImpl;
@useResult
$Res call({
 String term
});




}
/// @nodoc
class _$JokeSearchSubmittedCopyWithImpl<$Res>
    implements $JokeSearchSubmittedCopyWith<$Res> {
  _$JokeSearchSubmittedCopyWithImpl(this._self, this._then);

  final JokeSearchSubmitted _self;
  final $Res Function(JokeSearchSubmitted) _then;

/// Create a copy of JokeSearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? term = null,}) {
  return _then(JokeSearchSubmitted(
term: null == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class JokeSearchChipSelected implements JokeSearchEvent {
  const JokeSearchChipSelected({required this.term});
  

 final  String term;

/// Create a copy of JokeSearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokeSearchChipSelectedCopyWith<JokeSearchChipSelected> get copyWith => _$JokeSearchChipSelectedCopyWithImpl<JokeSearchChipSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeSearchChipSelected&&(identical(other.term, term) || other.term == term));
}


@override
int get hashCode => Object.hash(runtimeType,term);

@override
String toString() {
  return 'JokeSearchEvent.chipSelected(term: $term)';
}


}

/// @nodoc
abstract mixin class $JokeSearchChipSelectedCopyWith<$Res> implements $JokeSearchEventCopyWith<$Res> {
  factory $JokeSearchChipSelectedCopyWith(JokeSearchChipSelected value, $Res Function(JokeSearchChipSelected) _then) = _$JokeSearchChipSelectedCopyWithImpl;
@useResult
$Res call({
 String term
});




}
/// @nodoc
class _$JokeSearchChipSelectedCopyWithImpl<$Res>
    implements $JokeSearchChipSelectedCopyWith<$Res> {
  _$JokeSearchChipSelectedCopyWithImpl(this._self, this._then);

  final JokeSearchChipSelected _self;
  final $Res Function(JokeSearchChipSelected) _then;

/// Create a copy of JokeSearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? term = null,}) {
  return _then(JokeSearchChipSelected(
term: null == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class JokeSearchLoadMore implements JokeSearchEvent {
  const JokeSearchLoadMore();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeSearchLoadMore);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokeSearchEvent.loadMore()';
}


}




/// @nodoc
mixin _$JokeSearchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeSearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokeSearchState()';
}


}

/// @nodoc
class $JokeSearchStateCopyWith<$Res>  {
$JokeSearchStateCopyWith(JokeSearchState _, $Res Function(JokeSearchState) __);
}


/// Adds pattern-matching-related methods to [JokeSearchState].
extension JokeSearchStatePatterns on JokeSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( JokeSearchInitial value)?  initial,TResult Function( JokeSearchLoading value)?  loading,TResult Function( JokeSearchLoaded value)?  loaded,TResult Function( JokeSearchError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case JokeSearchInitial() when initial != null:
return initial(_that);case JokeSearchLoading() when loading != null:
return loading(_that);case JokeSearchLoaded() when loaded != null:
return loaded(_that);case JokeSearchError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( JokeSearchInitial value)  initial,required TResult Function( JokeSearchLoading value)  loading,required TResult Function( JokeSearchLoaded value)  loaded,required TResult Function( JokeSearchError value)  error,}){
final _that = this;
switch (_that) {
case JokeSearchInitial():
return initial(_that);case JokeSearchLoading():
return loading(_that);case JokeSearchLoaded():
return loaded(_that);case JokeSearchError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( JokeSearchInitial value)?  initial,TResult? Function( JokeSearchLoading value)?  loading,TResult? Function( JokeSearchLoaded value)?  loaded,TResult? Function( JokeSearchError value)?  error,}){
final _that = this;
switch (_that) {
case JokeSearchInitial() when initial != null:
return initial(_that);case JokeSearchLoading() when loading != null:
return loading(_that);case JokeSearchLoaded() when loaded != null:
return loaded(_that);case JokeSearchError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<JokeSearchResultEntity> results,  int totalJokes,  int totalPages,  int currentPage,  String searchTerm,  bool isLoadingMore)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case JokeSearchInitial() when initial != null:
return initial();case JokeSearchLoading() when loading != null:
return loading();case JokeSearchLoaded() when loaded != null:
return loaded(_that.results,_that.totalJokes,_that.totalPages,_that.currentPage,_that.searchTerm,_that.isLoadingMore);case JokeSearchError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<JokeSearchResultEntity> results,  int totalJokes,  int totalPages,  int currentPage,  String searchTerm,  bool isLoadingMore)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case JokeSearchInitial():
return initial();case JokeSearchLoading():
return loading();case JokeSearchLoaded():
return loaded(_that.results,_that.totalJokes,_that.totalPages,_that.currentPage,_that.searchTerm,_that.isLoadingMore);case JokeSearchError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<JokeSearchResultEntity> results,  int totalJokes,  int totalPages,  int currentPage,  String searchTerm,  bool isLoadingMore)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case JokeSearchInitial() when initial != null:
return initial();case JokeSearchLoading() when loading != null:
return loading();case JokeSearchLoaded() when loaded != null:
return loaded(_that.results,_that.totalJokes,_that.totalPages,_that.currentPage,_that.searchTerm,_that.isLoadingMore);case JokeSearchError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class JokeSearchInitial implements JokeSearchState {
  const JokeSearchInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeSearchInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokeSearchState.initial()';
}


}




/// @nodoc


class JokeSearchLoading implements JokeSearchState {
  const JokeSearchLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeSearchLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'JokeSearchState.loading()';
}


}




/// @nodoc


class JokeSearchLoaded implements JokeSearchState {
  const JokeSearchLoaded({required final  List<JokeSearchResultEntity> results, required this.totalJokes, required this.totalPages, required this.currentPage, required this.searchTerm, this.isLoadingMore = false}): _results = results;
  

 final  List<JokeSearchResultEntity> _results;
 List<JokeSearchResultEntity> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

 final  int totalJokes;
 final  int totalPages;
 final  int currentPage;
 final  String searchTerm;
@JsonKey() final  bool isLoadingMore;

/// Create a copy of JokeSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokeSearchLoadedCopyWith<JokeSearchLoaded> get copyWith => _$JokeSearchLoadedCopyWithImpl<JokeSearchLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeSearchLoaded&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.totalJokes, totalJokes) || other.totalJokes == totalJokes)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.searchTerm, searchTerm) || other.searchTerm == searchTerm)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results),totalJokes,totalPages,currentPage,searchTerm,isLoadingMore);

@override
String toString() {
  return 'JokeSearchState.loaded(results: $results, totalJokes: $totalJokes, totalPages: $totalPages, currentPage: $currentPage, searchTerm: $searchTerm, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $JokeSearchLoadedCopyWith<$Res> implements $JokeSearchStateCopyWith<$Res> {
  factory $JokeSearchLoadedCopyWith(JokeSearchLoaded value, $Res Function(JokeSearchLoaded) _then) = _$JokeSearchLoadedCopyWithImpl;
@useResult
$Res call({
 List<JokeSearchResultEntity> results, int totalJokes, int totalPages, int currentPage, String searchTerm, bool isLoadingMore
});




}
/// @nodoc
class _$JokeSearchLoadedCopyWithImpl<$Res>
    implements $JokeSearchLoadedCopyWith<$Res> {
  _$JokeSearchLoadedCopyWithImpl(this._self, this._then);

  final JokeSearchLoaded _self;
  final $Res Function(JokeSearchLoaded) _then;

/// Create a copy of JokeSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? results = null,Object? totalJokes = null,Object? totalPages = null,Object? currentPage = null,Object? searchTerm = null,Object? isLoadingMore = null,}) {
  return _then(JokeSearchLoaded(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<JokeSearchResultEntity>,totalJokes: null == totalJokes ? _self.totalJokes : totalJokes // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,searchTerm: null == searchTerm ? _self.searchTerm : searchTerm // ignore: cast_nullable_to_non_nullable
as String,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class JokeSearchError implements JokeSearchState {
  const JokeSearchError({required this.message});
  

 final  String message;

/// Create a copy of JokeSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JokeSearchErrorCopyWith<JokeSearchError> get copyWith => _$JokeSearchErrorCopyWithImpl<JokeSearchError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JokeSearchError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'JokeSearchState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $JokeSearchErrorCopyWith<$Res> implements $JokeSearchStateCopyWith<$Res> {
  factory $JokeSearchErrorCopyWith(JokeSearchError value, $Res Function(JokeSearchError) _then) = _$JokeSearchErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$JokeSearchErrorCopyWithImpl<$Res>
    implements $JokeSearchErrorCopyWith<$Res> {
  _$JokeSearchErrorCopyWithImpl(this._self, this._then);

  final JokeSearchError _self;
  final $Res Function(JokeSearchError) _then;

/// Create a copy of JokeSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(JokeSearchError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
