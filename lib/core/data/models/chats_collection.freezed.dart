// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chats_collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatsCollection {

 List<Chat> get chats; bool get fromCache;
/// Create a copy of ChatsCollection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatsCollectionCopyWith<ChatsCollection> get copyWith => _$ChatsCollectionCopyWithImpl<ChatsCollection>(this as ChatsCollection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatsCollection&&const DeepCollectionEquality().equals(other.chats, chats)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(chats),fromCache);

@override
String toString() {
  return 'ChatsCollection(chats: $chats, fromCache: $fromCache)';
}


}

/// @nodoc
abstract mixin class $ChatsCollectionCopyWith<$Res>  {
  factory $ChatsCollectionCopyWith(ChatsCollection value, $Res Function(ChatsCollection) _then) = _$ChatsCollectionCopyWithImpl;
@useResult
$Res call({
 List<Chat> chats, bool fromCache
});




}
/// @nodoc
class _$ChatsCollectionCopyWithImpl<$Res>
    implements $ChatsCollectionCopyWith<$Res> {
  _$ChatsCollectionCopyWithImpl(this._self, this._then);

  final ChatsCollection _self;
  final $Res Function(ChatsCollection) _then;

/// Create a copy of ChatsCollection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chats = null,Object? fromCache = null,}) {
  return _then(_self.copyWith(
chats: null == chats ? _self.chats : chats // ignore: cast_nullable_to_non_nullable
as List<Chat>,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatsCollection].
extension ChatsCollectionPatterns on ChatsCollection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatsCollection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatsCollection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatsCollection value)  $default,){
final _that = this;
switch (_that) {
case _ChatsCollection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatsCollection value)?  $default,){
final _that = this;
switch (_that) {
case _ChatsCollection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Chat> chats,  bool fromCache)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatsCollection() when $default != null:
return $default(_that.chats,_that.fromCache);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Chat> chats,  bool fromCache)  $default,) {final _that = this;
switch (_that) {
case _ChatsCollection():
return $default(_that.chats,_that.fromCache);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Chat> chats,  bool fromCache)?  $default,) {final _that = this;
switch (_that) {
case _ChatsCollection() when $default != null:
return $default(_that.chats,_that.fromCache);case _:
  return null;

}
}

}

/// @nodoc


class _ChatsCollection implements ChatsCollection {
  const _ChatsCollection({required final  List<Chat> chats, this.fromCache = false}): _chats = chats;
  

 final  List<Chat> _chats;
@override List<Chat> get chats {
  if (_chats is EqualUnmodifiableListView) return _chats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chats);
}

@override@JsonKey() final  bool fromCache;

/// Create a copy of ChatsCollection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatsCollectionCopyWith<_ChatsCollection> get copyWith => __$ChatsCollectionCopyWithImpl<_ChatsCollection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatsCollection&&const DeepCollectionEquality().equals(other._chats, _chats)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_chats),fromCache);

@override
String toString() {
  return 'ChatsCollection(chats: $chats, fromCache: $fromCache)';
}


}

/// @nodoc
abstract mixin class _$ChatsCollectionCopyWith<$Res> implements $ChatsCollectionCopyWith<$Res> {
  factory _$ChatsCollectionCopyWith(_ChatsCollection value, $Res Function(_ChatsCollection) _then) = __$ChatsCollectionCopyWithImpl;
@override @useResult
$Res call({
 List<Chat> chats, bool fromCache
});




}
/// @nodoc
class __$ChatsCollectionCopyWithImpl<$Res>
    implements _$ChatsCollectionCopyWith<$Res> {
  __$ChatsCollectionCopyWithImpl(this._self, this._then);

  final _ChatsCollection _self;
  final $Res Function(_ChatsCollection) _then;

/// Create a copy of ChatsCollection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chats = null,Object? fromCache = null,}) {
  return _then(_ChatsCollection(
chats: null == chats ? _self._chats : chats // ignore: cast_nullable_to_non_nullable
as List<Chat>,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
