// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_page_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchPageEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPageEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchPageEvent()';
}


}

/// @nodoc
class $SearchPageEventCopyWith<$Res>  {
$SearchPageEventCopyWith(SearchPageEvent _, $Res Function(SearchPageEvent) __);
}


/// Adds pattern-matching-related methods to [SearchPageEvent].
extension SearchPageEventPatterns on SearchPageEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchPageSubmitted value)?  submitted,TResult Function( SearchPageChipSelected value)?  chipSelected,TResult Function( SearchPageLoadMore value)?  loadMore,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchPageSubmitted() when submitted != null:
return submitted(_that);case SearchPageChipSelected() when chipSelected != null:
return chipSelected(_that);case SearchPageLoadMore() when loadMore != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchPageSubmitted value)  submitted,required TResult Function( SearchPageChipSelected value)  chipSelected,required TResult Function( SearchPageLoadMore value)  loadMore,}){
final _that = this;
switch (_that) {
case SearchPageSubmitted():
return submitted(_that);case SearchPageChipSelected():
return chipSelected(_that);case SearchPageLoadMore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchPageSubmitted value)?  submitted,TResult? Function( SearchPageChipSelected value)?  chipSelected,TResult? Function( SearchPageLoadMore value)?  loadMore,}){
final _that = this;
switch (_that) {
case SearchPageSubmitted() when submitted != null:
return submitted(_that);case SearchPageChipSelected() when chipSelected != null:
return chipSelected(_that);case SearchPageLoadMore() when loadMore != null:
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
case SearchPageSubmitted() when submitted != null:
return submitted(_that.term);case SearchPageChipSelected() when chipSelected != null:
return chipSelected(_that.term);case SearchPageLoadMore() when loadMore != null:
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
case SearchPageSubmitted():
return submitted(_that.term);case SearchPageChipSelected():
return chipSelected(_that.term);case SearchPageLoadMore():
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
case SearchPageSubmitted() when submitted != null:
return submitted(_that.term);case SearchPageChipSelected() when chipSelected != null:
return chipSelected(_that.term);case SearchPageLoadMore() when loadMore != null:
return loadMore();case _:
  return null;

}
}

}

/// @nodoc


class SearchPageSubmitted implements SearchPageEvent {
  const SearchPageSubmitted({required this.term});
  

 final  String term;

/// Create a copy of SearchPageEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchPageSubmittedCopyWith<SearchPageSubmitted> get copyWith => _$SearchPageSubmittedCopyWithImpl<SearchPageSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPageSubmitted&&(identical(other.term, term) || other.term == term));
}


@override
int get hashCode => Object.hash(runtimeType,term);

@override
String toString() {
  return 'SearchPageEvent.submitted(term: $term)';
}


}

/// @nodoc
abstract mixin class $SearchPageSubmittedCopyWith<$Res> implements $SearchPageEventCopyWith<$Res> {
  factory $SearchPageSubmittedCopyWith(SearchPageSubmitted value, $Res Function(SearchPageSubmitted) _then) = _$SearchPageSubmittedCopyWithImpl;
@useResult
$Res call({
 String term
});




}
/// @nodoc
class _$SearchPageSubmittedCopyWithImpl<$Res>
    implements $SearchPageSubmittedCopyWith<$Res> {
  _$SearchPageSubmittedCopyWithImpl(this._self, this._then);

  final SearchPageSubmitted _self;
  final $Res Function(SearchPageSubmitted) _then;

/// Create a copy of SearchPageEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? term = null,}) {
  return _then(SearchPageSubmitted(
term: null == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchPageChipSelected implements SearchPageEvent {
  const SearchPageChipSelected({required this.term});
  

 final  String term;

/// Create a copy of SearchPageEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchPageChipSelectedCopyWith<SearchPageChipSelected> get copyWith => _$SearchPageChipSelectedCopyWithImpl<SearchPageChipSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPageChipSelected&&(identical(other.term, term) || other.term == term));
}


@override
int get hashCode => Object.hash(runtimeType,term);

@override
String toString() {
  return 'SearchPageEvent.chipSelected(term: $term)';
}


}

/// @nodoc
abstract mixin class $SearchPageChipSelectedCopyWith<$Res> implements $SearchPageEventCopyWith<$Res> {
  factory $SearchPageChipSelectedCopyWith(SearchPageChipSelected value, $Res Function(SearchPageChipSelected) _then) = _$SearchPageChipSelectedCopyWithImpl;
@useResult
$Res call({
 String term
});




}
/// @nodoc
class _$SearchPageChipSelectedCopyWithImpl<$Res>
    implements $SearchPageChipSelectedCopyWith<$Res> {
  _$SearchPageChipSelectedCopyWithImpl(this._self, this._then);

  final SearchPageChipSelected _self;
  final $Res Function(SearchPageChipSelected) _then;

/// Create a copy of SearchPageEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? term = null,}) {
  return _then(SearchPageChipSelected(
term: null == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchPageLoadMore implements SearchPageEvent {
  const SearchPageLoadMore();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPageLoadMore);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchPageEvent.loadMore()';
}


}




/// @nodoc
mixin _$SearchPageState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPageState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchPageState()';
}


}

/// @nodoc
class $SearchPageStateCopyWith<$Res>  {
$SearchPageStateCopyWith(SearchPageState _, $Res Function(SearchPageState) __);
}


/// Adds pattern-matching-related methods to [SearchPageState].
extension SearchPageStatePatterns on SearchPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchPageInitial value)?  initial,TResult Function( SearchPageLoading value)?  loading,TResult Function( SearchPageLoaded value)?  loaded,TResult Function( SearchPageError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchPageInitial() when initial != null:
return initial(_that);case SearchPageLoading() when loading != null:
return loading(_that);case SearchPageLoaded() when loaded != null:
return loaded(_that);case SearchPageError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchPageInitial value)  initial,required TResult Function( SearchPageLoading value)  loading,required TResult Function( SearchPageLoaded value)  loaded,required TResult Function( SearchPageError value)  error,}){
final _that = this;
switch (_that) {
case SearchPageInitial():
return initial(_that);case SearchPageLoading():
return loading(_that);case SearchPageLoaded():
return loaded(_that);case SearchPageError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchPageInitial value)?  initial,TResult? Function( SearchPageLoading value)?  loading,TResult? Function( SearchPageLoaded value)?  loaded,TResult? Function( SearchPageError value)?  error,}){
final _that = this;
switch (_that) {
case SearchPageInitial() when initial != null:
return initial(_that);case SearchPageLoading() when loading != null:
return loading(_that);case SearchPageLoaded() when loaded != null:
return loaded(_that);case SearchPageError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<JokeEntity> results,  int totalJokes,  int totalPages,  int currentPage,  String searchTerm,  bool isLoadingMore)?  loaded,TResult Function( String message,  String searchTerm)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchPageInitial() when initial != null:
return initial();case SearchPageLoading() when loading != null:
return loading();case SearchPageLoaded() when loaded != null:
return loaded(_that.results,_that.totalJokes,_that.totalPages,_that.currentPage,_that.searchTerm,_that.isLoadingMore);case SearchPageError() when error != null:
return error(_that.message,_that.searchTerm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<JokeEntity> results,  int totalJokes,  int totalPages,  int currentPage,  String searchTerm,  bool isLoadingMore)  loaded,required TResult Function( String message,  String searchTerm)  error,}) {final _that = this;
switch (_that) {
case SearchPageInitial():
return initial();case SearchPageLoading():
return loading();case SearchPageLoaded():
return loaded(_that.results,_that.totalJokes,_that.totalPages,_that.currentPage,_that.searchTerm,_that.isLoadingMore);case SearchPageError():
return error(_that.message,_that.searchTerm);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<JokeEntity> results,  int totalJokes,  int totalPages,  int currentPage,  String searchTerm,  bool isLoadingMore)?  loaded,TResult? Function( String message,  String searchTerm)?  error,}) {final _that = this;
switch (_that) {
case SearchPageInitial() when initial != null:
return initial();case SearchPageLoading() when loading != null:
return loading();case SearchPageLoaded() when loaded != null:
return loaded(_that.results,_that.totalJokes,_that.totalPages,_that.currentPage,_that.searchTerm,_that.isLoadingMore);case SearchPageError() when error != null:
return error(_that.message,_that.searchTerm);case _:
  return null;

}
}

}

/// @nodoc


class SearchPageInitial implements SearchPageState {
  const SearchPageInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPageInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchPageState.initial()';
}


}




/// @nodoc


class SearchPageLoading implements SearchPageState {
  const SearchPageLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPageLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchPageState.loading()';
}


}




/// @nodoc


class SearchPageLoaded implements SearchPageState {
  const SearchPageLoaded({required final  List<JokeEntity> results, required this.totalJokes, required this.totalPages, required this.currentPage, required this.searchTerm, this.isLoadingMore = false}): _results = results;
  

 final  List<JokeEntity> _results;
 List<JokeEntity> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

 final  int totalJokes;
 final  int totalPages;
 final  int currentPage;
 final  String searchTerm;
@JsonKey() final  bool isLoadingMore;

/// Create a copy of SearchPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchPageLoadedCopyWith<SearchPageLoaded> get copyWith => _$SearchPageLoadedCopyWithImpl<SearchPageLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPageLoaded&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.totalJokes, totalJokes) || other.totalJokes == totalJokes)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.searchTerm, searchTerm) || other.searchTerm == searchTerm)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results),totalJokes,totalPages,currentPage,searchTerm,isLoadingMore);

@override
String toString() {
  return 'SearchPageState.loaded(results: $results, totalJokes: $totalJokes, totalPages: $totalPages, currentPage: $currentPage, searchTerm: $searchTerm, isLoadingMore: $isLoadingMore)';
}


}

/// @nodoc
abstract mixin class $SearchPageLoadedCopyWith<$Res> implements $SearchPageStateCopyWith<$Res> {
  factory $SearchPageLoadedCopyWith(SearchPageLoaded value, $Res Function(SearchPageLoaded) _then) = _$SearchPageLoadedCopyWithImpl;
@useResult
$Res call({
 List<JokeEntity> results, int totalJokes, int totalPages, int currentPage, String searchTerm, bool isLoadingMore
});




}
/// @nodoc
class _$SearchPageLoadedCopyWithImpl<$Res>
    implements $SearchPageLoadedCopyWith<$Res> {
  _$SearchPageLoadedCopyWithImpl(this._self, this._then);

  final SearchPageLoaded _self;
  final $Res Function(SearchPageLoaded) _then;

/// Create a copy of SearchPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? results = null,Object? totalJokes = null,Object? totalPages = null,Object? currentPage = null,Object? searchTerm = null,Object? isLoadingMore = null,}) {
  return _then(SearchPageLoaded(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<JokeEntity>,totalJokes: null == totalJokes ? _self.totalJokes : totalJokes // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,searchTerm: null == searchTerm ? _self.searchTerm : searchTerm // ignore: cast_nullable_to_non_nullable
as String,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SearchPageError implements SearchPageState {
  const SearchPageError({required this.message, required this.searchTerm});
  

 final  String message;
 final  String searchTerm;

/// Create a copy of SearchPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchPageErrorCopyWith<SearchPageError> get copyWith => _$SearchPageErrorCopyWithImpl<SearchPageError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPageError&&(identical(other.message, message) || other.message == message)&&(identical(other.searchTerm, searchTerm) || other.searchTerm == searchTerm));
}


@override
int get hashCode => Object.hash(runtimeType,message,searchTerm);

@override
String toString() {
  return 'SearchPageState.error(message: $message, searchTerm: $searchTerm)';
}


}

/// @nodoc
abstract mixin class $SearchPageErrorCopyWith<$Res> implements $SearchPageStateCopyWith<$Res> {
  factory $SearchPageErrorCopyWith(SearchPageError value, $Res Function(SearchPageError) _then) = _$SearchPageErrorCopyWithImpl;
@useResult
$Res call({
 String message, String searchTerm
});




}
/// @nodoc
class _$SearchPageErrorCopyWithImpl<$Res>
    implements $SearchPageErrorCopyWith<$Res> {
  _$SearchPageErrorCopyWithImpl(this._self, this._then);

  final SearchPageError _self;
  final $Res Function(SearchPageError) _then;

/// Create a copy of SearchPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? searchTerm = null,}) {
  return _then(SearchPageError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,searchTerm: null == searchTerm ? _self.searchTerm : searchTerm // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
