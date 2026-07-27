// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchEvent()';
}


}

/// @nodoc
class $SearchEventCopyWith<$Res>  {
$SearchEventCopyWith(SearchEvent _, $Res Function(SearchEvent) __);
}


/// Adds pattern-matching-related methods to [SearchEvent].
extension SearchEventPatterns on SearchEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchStarted value)?  started,TResult Function( SearchQueryChanged value)?  queryChanged,TResult Function( SearchResultSelected value)?  resultSelected,TResult Function( SearchRecentSearchRemoved value)?  recentSearchRemoved,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchStarted() when started != null:
return started(_that);case SearchQueryChanged() when queryChanged != null:
return queryChanged(_that);case SearchResultSelected() when resultSelected != null:
return resultSelected(_that);case SearchRecentSearchRemoved() when recentSearchRemoved != null:
return recentSearchRemoved(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchStarted value)  started,required TResult Function( SearchQueryChanged value)  queryChanged,required TResult Function( SearchResultSelected value)  resultSelected,required TResult Function( SearchRecentSearchRemoved value)  recentSearchRemoved,}){
final _that = this;
switch (_that) {
case SearchStarted():
return started(_that);case SearchQueryChanged():
return queryChanged(_that);case SearchResultSelected():
return resultSelected(_that);case SearchRecentSearchRemoved():
return recentSearchRemoved(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchStarted value)?  started,TResult? Function( SearchQueryChanged value)?  queryChanged,TResult? Function( SearchResultSelected value)?  resultSelected,TResult? Function( SearchRecentSearchRemoved value)?  recentSearchRemoved,}){
final _that = this;
switch (_that) {
case SearchStarted() when started != null:
return started(_that);case SearchQueryChanged() when queryChanged != null:
return queryChanged(_that);case SearchResultSelected() when resultSelected != null:
return resultSelected(_that);case SearchRecentSearchRemoved() when recentSearchRemoved != null:
return recentSearchRemoved(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String query)?  queryChanged,TResult Function( RecentSearchEntity item)?  resultSelected,TResult Function( RecentSearchEntity item)?  recentSearchRemoved,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchStarted() when started != null:
return started();case SearchQueryChanged() when queryChanged != null:
return queryChanged(_that.query);case SearchResultSelected() when resultSelected != null:
return resultSelected(_that.item);case SearchRecentSearchRemoved() when recentSearchRemoved != null:
return recentSearchRemoved(_that.item);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String query)  queryChanged,required TResult Function( RecentSearchEntity item)  resultSelected,required TResult Function( RecentSearchEntity item)  recentSearchRemoved,}) {final _that = this;
switch (_that) {
case SearchStarted():
return started();case SearchQueryChanged():
return queryChanged(_that.query);case SearchResultSelected():
return resultSelected(_that.item);case SearchRecentSearchRemoved():
return recentSearchRemoved(_that.item);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String query)?  queryChanged,TResult? Function( RecentSearchEntity item)?  resultSelected,TResult? Function( RecentSearchEntity item)?  recentSearchRemoved,}) {final _that = this;
switch (_that) {
case SearchStarted() when started != null:
return started();case SearchQueryChanged() when queryChanged != null:
return queryChanged(_that.query);case SearchResultSelected() when resultSelected != null:
return resultSelected(_that.item);case SearchRecentSearchRemoved() when recentSearchRemoved != null:
return recentSearchRemoved(_that.item);case _:
  return null;

}
}

}

/// @nodoc


class SearchStarted implements SearchEvent {
  const SearchStarted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchStarted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchEvent.started()';
}


}




/// @nodoc


class SearchQueryChanged implements SearchEvent {
  const SearchQueryChanged({required this.query});
  

 final  String query;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchQueryChangedCopyWith<SearchQueryChanged> get copyWith => _$SearchQueryChangedCopyWithImpl<SearchQueryChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchQueryChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'SearchEvent.queryChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchQueryChangedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory $SearchQueryChangedCopyWith(SearchQueryChanged value, $Res Function(SearchQueryChanged) _then) = _$SearchQueryChangedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchQueryChangedCopyWithImpl<$Res>
    implements $SearchQueryChangedCopyWith<$Res> {
  _$SearchQueryChangedCopyWithImpl(this._self, this._then);

  final SearchQueryChanged _self;
  final $Res Function(SearchQueryChanged) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchQueryChanged(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchResultSelected implements SearchEvent {
  const SearchResultSelected({required this.item});
  

 final  RecentSearchEntity item;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultSelectedCopyWith<SearchResultSelected> get copyWith => _$SearchResultSelectedCopyWithImpl<SearchResultSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResultSelected&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,item);

@override
String toString() {
  return 'SearchEvent.resultSelected(item: $item)';
}


}

/// @nodoc
abstract mixin class $SearchResultSelectedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory $SearchResultSelectedCopyWith(SearchResultSelected value, $Res Function(SearchResultSelected) _then) = _$SearchResultSelectedCopyWithImpl;
@useResult
$Res call({
 RecentSearchEntity item
});




}
/// @nodoc
class _$SearchResultSelectedCopyWithImpl<$Res>
    implements $SearchResultSelectedCopyWith<$Res> {
  _$SearchResultSelectedCopyWithImpl(this._self, this._then);

  final SearchResultSelected _self;
  final $Res Function(SearchResultSelected) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(SearchResultSelected(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as RecentSearchEntity,
  ));
}


}

/// @nodoc


class SearchRecentSearchRemoved implements SearchEvent {
  const SearchRecentSearchRemoved({required this.item});
  

 final  RecentSearchEntity item;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchRecentSearchRemovedCopyWith<SearchRecentSearchRemoved> get copyWith => _$SearchRecentSearchRemovedCopyWithImpl<SearchRecentSearchRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchRecentSearchRemoved&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,item);

@override
String toString() {
  return 'SearchEvent.recentSearchRemoved(item: $item)';
}


}

/// @nodoc
abstract mixin class $SearchRecentSearchRemovedCopyWith<$Res> implements $SearchEventCopyWith<$Res> {
  factory $SearchRecentSearchRemovedCopyWith(SearchRecentSearchRemoved value, $Res Function(SearchRecentSearchRemoved) _then) = _$SearchRecentSearchRemovedCopyWithImpl;
@useResult
$Res call({
 RecentSearchEntity item
});




}
/// @nodoc
class _$SearchRecentSearchRemovedCopyWithImpl<$Res>
    implements $SearchRecentSearchRemovedCopyWith<$Res> {
  _$SearchRecentSearchRemovedCopyWithImpl(this._self, this._then);

  final SearchRecentSearchRemoved _self;
  final $Res Function(SearchRecentSearchRemoved) _then;

/// Create a copy of SearchEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(SearchRecentSearchRemoved(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as RecentSearchEntity,
  ));
}


}

/// @nodoc
mixin _$SearchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState()';
}


}

/// @nodoc
class $SearchStateCopyWith<$Res>  {
$SearchStateCopyWith(SearchState _, $Res Function(SearchState) __);
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchLoading value)?  loading,TResult Function( SearchLoaded value)?  loaded,TResult Function( SearchError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchLoading() when loading != null:
return loading(_that);case SearchLoaded() when loaded != null:
return loaded(_that);case SearchError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchLoading value)  loading,required TResult Function( SearchLoaded value)  loaded,required TResult Function( SearchError value)  error,}){
final _that = this;
switch (_that) {
case SearchLoading():
return loading(_that);case SearchLoaded():
return loaded(_that);case SearchError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchLoading value)?  loading,TResult? Function( SearchLoaded value)?  loaded,TResult? Function( SearchError value)?  error,}){
final _that = this;
switch (_that) {
case SearchLoading() when loading != null:
return loading(_that);case SearchLoaded() when loaded != null:
return loaded(_that);case SearchError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( SearchEntity search,  String query,  bool searching,  SearchResultsEntity? results,  String? resultsError)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchLoading() when loading != null:
return loading();case SearchLoaded() when loaded != null:
return loaded(_that.search,_that.query,_that.searching,_that.results,_that.resultsError);case SearchError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( SearchEntity search,  String query,  bool searching,  SearchResultsEntity? results,  String? resultsError)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case SearchLoading():
return loading();case SearchLoaded():
return loaded(_that.search,_that.query,_that.searching,_that.results,_that.resultsError);case SearchError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( SearchEntity search,  String query,  bool searching,  SearchResultsEntity? results,  String? resultsError)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case SearchLoading() when loading != null:
return loading();case SearchLoaded() when loaded != null:
return loaded(_that.search,_that.query,_that.searching,_that.results,_that.resultsError);case SearchError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SearchLoading implements SearchState {
  const SearchLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState.loading()';
}


}




/// @nodoc


class SearchLoaded implements SearchState {
  const SearchLoaded({required this.search, this.query = '', this.searching = false, this.results, this.resultsError});
  

 final  SearchEntity search;
@JsonKey() final  String query;
@JsonKey() final  bool searching;
 final  SearchResultsEntity? results;
 final  String? resultsError;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchLoadedCopyWith<SearchLoaded> get copyWith => _$SearchLoadedCopyWithImpl<SearchLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLoaded&&(identical(other.search, search) || other.search == search)&&(identical(other.query, query) || other.query == query)&&(identical(other.searching, searching) || other.searching == searching)&&(identical(other.results, results) || other.results == results)&&(identical(other.resultsError, resultsError) || other.resultsError == resultsError));
}


@override
int get hashCode => Object.hash(runtimeType,search,query,searching,results,resultsError);

@override
String toString() {
  return 'SearchState.loaded(search: $search, query: $query, searching: $searching, results: $results, resultsError: $resultsError)';
}


}

/// @nodoc
abstract mixin class $SearchLoadedCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchLoadedCopyWith(SearchLoaded value, $Res Function(SearchLoaded) _then) = _$SearchLoadedCopyWithImpl;
@useResult
$Res call({
 SearchEntity search, String query, bool searching, SearchResultsEntity? results, String? resultsError
});




}
/// @nodoc
class _$SearchLoadedCopyWithImpl<$Res>
    implements $SearchLoadedCopyWith<$Res> {
  _$SearchLoadedCopyWithImpl(this._self, this._then);

  final SearchLoaded _self;
  final $Res Function(SearchLoaded) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? search = null,Object? query = null,Object? searching = null,Object? results = freezed,Object? resultsError = freezed,}) {
  return _then(SearchLoaded(
search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as SearchEntity,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,searching: null == searching ? _self.searching : searching // ignore: cast_nullable_to_non_nullable
as bool,results: freezed == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as SearchResultsEntity?,resultsError: freezed == resultsError ? _self.resultsError : resultsError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SearchError implements SearchState {
  const SearchError({required this.message});
  

 final  String message;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchErrorCopyWith<SearchError> get copyWith => _$SearchErrorCopyWithImpl<SearchError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SearchState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SearchErrorCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchErrorCopyWith(SearchError value, $Res Function(SearchError) _then) = _$SearchErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SearchErrorCopyWithImpl<$Res>
    implements $SearchErrorCopyWith<$Res> {
  _$SearchErrorCopyWithImpl(this._self, this._then);

  final SearchError _self;
  final $Res Function(SearchError) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SearchError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
